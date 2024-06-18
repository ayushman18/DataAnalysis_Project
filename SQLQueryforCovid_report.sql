SELECT * 
From PortfolioProject..CovidDeaths order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths 
order by 1,2

-- Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

--Total cases vs population
--shows what % of population got Covid

Select location, date, Population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

-- looking at Countries with Highest Infection Rate compared to population

Select location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 
as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
Group by Location, population
order by  PercentagePopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
order by  TotalDeathCount desc

--LET'S BREAK DOWN THINGS DOWN BY CONTINENTS

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by  TotalDeathCount desc 

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--Where location like '%India%'
where continent is not null 
--Group by date
order by 1,2



--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
From PortfolioProject..CovidDeaths dea
Join  PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2 ,3


--USE CTE

With PopvsVac  (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
From PortfolioProject..CovidDeaths dea
Join  PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2 ,3
)
Select *
From PopvsVac










