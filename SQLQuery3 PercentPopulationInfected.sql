
Select *
From [PortfolioProject].[dbo].['CovidDeaths']
Where continent is not null
order by 3,4

--Select data that we are going to be using 

Select continent,date,total_cases,new_cases,total_deaths,population_density
From [PortfolioProject].[dbo].['CovidDeaths']
Where continent is not null
order by 3,4

--Looking at Total cases vs Total Deaths

Select continent,date, total_cases,total_deaths, cast(total_deaths/total_cases as int)*100 as DeathPercentage
From [PortfolioProject].[dbo].['CovidDeaths']
Where continent is not null
order by 1,2



--Looking at Countries with Highest Infection Rate compared to Population_density 

Select continent , Population_density, MAX(total_cases)as HighestInfectionCount, MAX ((total_cases/ population_density))*100 as PercentPopulationInfected 
From [PortfolioProject].[dbo].['CovidDeaths']
--Where location like '%Kenya%'
Where continent is not null
Group By continent, Population_density 
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select continent , MAX(cast (total_deaths as int)) as TotalDeathCount
From [PortfolioProject].[dbo].['CovidDeaths']
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
From [PortfolioProject].[dbo].['CovidDeaths']
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS
Select date, SUM (new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [PortfolioProject].[dbo].['CovidDeaths']
--where location like '%states%'
where continent is not null
Group by date
order by 1,2

--Looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location)
From [PortfolioProject].[dbo].['CovidDeaths']dea
Join [PortfolioProject].[dbo].['CovidVaccinations']vac
On dea.location = Vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--TEMP TABLE
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
From [PortfolioProject].[dbo].['CovidDeaths']dea
Join [PortfolioProject].[dbo].['CovidVaccinations']vac
On dea.location = Vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated