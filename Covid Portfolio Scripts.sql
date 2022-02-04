--SELECT * 
--FROM PortfolioProject..CovidDeaths
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER by 3,4

--Select Data that we are using
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2

--Looking at Total Cases v Total Deaths
--Shows likelihood of dying if catch covid by country
--SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) *100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%kingdom%'
--ORDER BY 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid
--SELECT location, date, population, total_cases, (total_cases / population) *100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%kingdom%'
--ORDER BY 1,2

--Looking at countries with highest infection rate, compared to population
--SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases / population)) *100 AS CasePercentage
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%kingdom%'
--GROUP BY population, location
--ORDER BY CasePercentage desc


-- Showing Countries with highest death count per population
--cast total deaths as int - too comply with query
--SELECT location, MAX(CAST(total_deaths as int )) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%kingdom%'
--WHERE continent is not null
--GROUP BY location

--BREAK DOWN BY CONTINENT

--showing continent with highest deathcount per population 
--SELECT continent, MAX(CAST(total_deaths as int )) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%kingdom%'
--WHERE continent is not null
--GROUP BY continent
--order by TotalDeathCount desc

-- GLOBAL NUMBERS

--SELECT date, SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%kingdom%'
--where continent is not null
--GROUP BY date
--ORDER BY 1,2

--SELECT  SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--where continent is not null
--ORDER BY 1,2

--WITH PopvsVac(Continent, Location, date, population, new_vaccinations, Rolling_People_Vacinated)
--as(
----Total population vs vaccinations
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vacinated -- rolling count of vacinations 
--FROM PortfolioProject..CovidDeaths AS dea
--JOIN PortfolioProject..CovidVaccinations AS vac
--ON dea.location = vac.location
--AND dea.date = vac.date
--WHERE dea.continent is not null
----order by 2,3
--)

--SELECT *, (Rolling_People_Vacinated / population) * 100
--FROM PopvsVac
--WHERE Location = 'Albania'


--TEMP Table
--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric, 
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated -- rolling count of vacinations 
--FROM PortfolioProject..CovidDeaths AS dea
--JOIN PortfolioProject..CovidVaccinations AS vac
--ON dea.location = vac.location
--AND dea.date = vac.date
--WHERE dea.continent is not null and dea.location = 'Albania'
----order by 2,3

--SELECT *, (RollingPeopleVaccinated/Population) *100
--FROM #PercentPopulationVaccinated

--creating View to store data for later visualisation
--USE PortfolioProject;
--GO
--CREATE VIEW PercentPopulationVaccinatedView as
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated -- rolling count of vacinations 
--FROM PortfolioProject..CovidDeaths AS dea
--JOIN PortfolioProject..CovidVaccinations AS vac
--ON dea.location = vac.location
--AND dea.date = vac.date
--WHERE dea.continent is not null --and dea.location = 'Albania'
----order by 2,3

SELECT * FROM PercentPopulationVaccinatedView