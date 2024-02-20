select *
from portfolioproject..covidDeaths$
where continent is not null
order by 3,4

--select *
--from portfolioproject..covidVaccinations$
--order by 3,4

--select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..covidDeaths$
order by 1,2

-- looking at total cases vs total deaths
--shows the likelyhood of dying if you contract in your country

Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as deathPercentage
From portfolioproject..covidDeaths$
where location like '%states%'
order by 1,2
-- looking at the total cases vs the population
--showa what percentage of population got covid
Select Location, date, total_cases, population, (Total_cases/population)*100 as deathPercentage
From portfolioproject..covidDeaths$
where location like '%states%'
order by 1,2

--looking at countries with highest rate compared to population
Select Location, MAX(total_cases) as HigestInfectionCount, population, MAX((Total_cases/population))*100 as PercentagePopulationInfected
From portfolioproject..covidDeaths$
--where location like '%states%'
group by location, population
order by PercentagePopulationInfected desc

--showing Countries with higest deathcount per population
Select Location,  MAX(cast(Total_Deaths)) as TotalDeathCount
From portfolioproject..covidDeaths$
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

--lets break things down by continents
Select continent,  MAX(cast(Total_Deaths as int)) as TotalDeathCount
From portfolioproject..covidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

---GLOBAL NUMBERS 
Select date, SUM(new_cases), SUM(cast(new_deaths as int)) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From portfolioproject..covidDeaths$
where continent is not null
--Group by date
order by 1,2

--temp table
drop table if exists #percentPopulationVaccinated 
Create Table #percentPopulationVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
population numeric,

new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)


insert into #percentPopulationVaccinated 
select (continent,location, date, population, RollingPeopleVaccinated )
as
(
---looking at total population
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, da.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from portfolioproject..covidDeaths$ dea
join portfolioproject..covidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
--use CTE


select*,(RollingPeopleVaccinated/population)*100 
from
#percentPopulationVaccinated 



--creating view to store data for later visualization
create view percentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, da.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from portfolioproject..covidDeaths$ dea
join portfolioproject..covidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)

select*
from percentPopulationVaccinated











 


 


