select *
from Project_portfolio..CovidDeaths

select *
from Project_portfolio..CovidDeaths
order by 3,4
select *
from Project_portfolio..CovidVaccinations
order by 3,4

-- Project sql commands	
select location, date, total_cases,new_cases,total_deaths,population
from Project_portfolio..CovidDeaths
order by 1,2

-- Total death vs Total cases - Death Percentage
select location, date, total_cases,total_deaths,ROUND((total_deaths/total_cases)*100,2) AS DEATHPERCENTAGE
from Project_portfolio..CovidDeaths
order by 1,2

--Total cases vs Population ( what percentage of population got Covid)
select location, date, total_cases,population,ROUND((total_cases/population)*100,2) AS DEATHPERCENTAGE
from Project_portfolio..CovidDeaths
order by  deathpercentage desc

--Maximum covid infected country
select location, max(total_cases) as Max_affected
from Project_portfolio..CovidDeaths
where continent is not null
group by location
order by Max_affected desc

---countries with highest death counts
select location, max(total_deaths) as maxdeath
from Project_portfolio..CovidDeaths
group by location
order by maxdeath desc

---Interpret by continent
select continent, max(total_cases) as maxcases
from Project_portfolio..CovidDeaths
where continent is not null
group by continent 
order by maxcases desc

--Showing the continent with highest death count
select continent, count(total_deaths)as deathcount
from Project_portfolio..CovidDeaths
where continent is not null
group by continent
order by deathcount desc

--- GLOBAL INSIGHTS
Select date, sum(new_cases) AS total_cases,sum(CAST(new_deaths AS int)) AS total_deaths,
sum(CAST(new_deaths AS int))/sum(new_cases)*100 AS death_Perc
from Project_portfolio..CovidDeaths
where continent is not null
group by date
ORDER BY 1,2

--- JOINING TWO TABLES
Select *
from Project_portfolio..CovidDeaths dea
join Project_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	
--TOTAL POPULATION VS TOTAL VACCINCATION
select dea.continent, dea.location, dea.date, vac.new_vaccinations
from Project_portfolio..CovidDeaths dea
join Project_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

---  PARTITION CLAUSE
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(
from Project_portfolio..CovidDeaths dea
join Project_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- To create partition by clause
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingnum
from Project_portfolio..CovidDeaths dea
join Project_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

---Using CTE in SQL

With cteresult AS 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingnum
from Project_portfolio..CovidDeaths dea
join Project_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select *, round(Rollingnum/population *100,2) AS tot
from cteresult

--Creating VIEW to store data for Visualisations
create view cteVIEW AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingnum
from Project_portfolio..CovidDeaths dea
join Project_portfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

SELECT *
FROM cteview



