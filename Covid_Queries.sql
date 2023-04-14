-- UK Total Cases vs UK Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM "CovidDeaths"
WHERE location LIKE 'United Kingdom'
ORDER BY 1,2;

-- UK Total Cases vs UK Population

SELECT location, date, total_cases, population, (total_cases/population)*100 as PositivePercentage
FROM "CovidDeaths"
WHERE location LIKE 'United Kingdom'
ORDER BY 1,2;

-- Countries with Highest Infection Rate Compared to Population

SELECT location, MAX(total_cases) as MaxInfectionCount, population, MAX((total_cases/population))*100 as InfectionRate
FROM "CovidDeaths"
WHERE total_cases IS NOT NULL
GROUP BY location, population
ORDER BY InfectionRate desc;

-- Countries with Highest Death Count 

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM "CovidDeaths"
WHERE continent IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc;

-- Continents with Highest Death Count

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM "CovidDeaths"
WHERE continent IS NULL AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY TotalDeathCount desc;

-- Total Population vs Vaccinations Using CTE

WITH PopvsVac (continent, location, date, population, New_Vaccinations, PeopleVaccinated)
AS 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinated 
FROM "CovidDeaths" dea
JOIN "CovidVaccinations" vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
	SELECT * , (PeopleVaccinated/population)*100
	FROM PopvsVac