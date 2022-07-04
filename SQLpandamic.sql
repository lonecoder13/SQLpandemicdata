SELECT * 
FROM PortfolioProject..CovidDeaths$
select location ,date,total_cases,total_deaths,population
from PortfolioProject.dbo.CovidDeaths$
order by 1,2

--TOTAL CASES vs TOTAL DEATHS--
--showing likelihood of dying in my country
select location ,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
from PortfolioProject.dbo.CovidDeaths$
where  location='India'
order by DeathPercentage desc

--countries with high percentage of infection
select location,population,MAX(total_cases) AS hIGHEST_INFECTION_COUNT,MAX(total_cases/population)*100 AS INFECTED_POPULATION_PERCENTAGE
from PortfolioProject..CovidDeaths$
GROUP BY location,population
ORDER BY INFECTED_POPULATION_PERCENTAGE DESC

--COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

select location,population,MAX(total_deaths) AS total_death_COUNT,MAX(total_deaths/population)*100 AS death_POPULATION_PERCENTAGE
from PortfolioProject..CovidDeaths$
GROUP BY location,population
ORDER BY 3 DESC


--Global numbers
select  Sum(new_cases) totalcases, Sum(cast(new_deaths as int)) as totaldeath  ,MAX(total_deaths/population)*100 AS death_POPULATION_PERCENTAGE
from PortfolioProject..CovidDeaths$
where continent is not null
ORDER BY 1,2

--
select * 
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
---population vs vaccination
select dea.location , dea.date,dea.population,vac.new_vaccinations  
,sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by dea.location ,dea.date) as Total_vaccinated 
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location=vac.location
	and dea.date=vac.date
order by 1,2,3

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



