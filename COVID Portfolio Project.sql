SELECT * 
FROM 
profilioproject1..CovidDeaths
ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population 
FROM
profilioproject1..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at Total cases VS Total Deaths
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage 
FROM
profilioproject1..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Shows likelihood of dying if you contract covid in your country
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage 
FROM
profilioproject1..CovidDeaths
WHERE location LIKE '%lanka%' and continent is not null
ORDER BY 1,2

--shows what percentage of population got covid
SELECT location,date,total_cases,population,(total_cases/population)*100 AS Totalcasepercentage
FROM
profilioproject1..CovidDeaths
WHERE location LIKE '%lanka%' and continent is not null
ORDER BY 1,2

--Looking at country with highest infection rate compared to Population
SELECT location,population,MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population))*100 AS PercentPopulationInfected 
FROM
profilioproject1..CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

--Showing countries with highest Death Count Per Population
SELECT location,population,MAX(cast(total_deaths AS INT)) AS HighestDeathCount
FROM
profilioproject1..CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY HighestDeathCount DESC

--LETS BREAK THINGS DOWN BY CONTINENT

SELECT continent,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
profilioproject1..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC 

--GLOBAL NUMBERS
SELECT date,SUM(new_cases) AS Total_Case,SUM(CAST(new_deaths AS INT)) AS Total_Death,
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM
profilioproject1..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1

--Looking at Total Population VS Vaccinations

SELECT dea.continent,dea.location,dea.date,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.Date)
AS RollingPeopleVaccinated
FROM
profilioproject1..CovidDeaths Dea
JOIN profilioproject1..CovidVaccinations Vac
ON Dea.location=Vac.location
AND Dea.date=Vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--USE CTE

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.Date)
AS RollingPeopleVaccinated
FROM
profilioproject1..CovidDeaths Dea
JOIN profilioproject1..CovidVaccinations Vac
ON Dea.location=Vac.location
AND Dea.date=Vac.date
WHERE dea.continent is not null
)
SELECT *,(RollingPeopleVaccinated/population)*100 
FROM PopvsVac

--Creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent,dea.location,dea.date,vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.Date)
AS RollingPeopleVaccinated
FROM
profilioproject1..CovidDeaths Dea
JOIN profilioproject1..CovidVaccinations Vac
ON Dea.location=Vac.location
AND Dea.date=Vac.date
WHERE dea.continent is not null

SELECT * FROM 
PercentPopulationVaccinated










