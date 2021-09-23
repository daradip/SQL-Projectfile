Select *
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 3,4

Select Location,date,total_cases,new_cases,total_deaths,population
From [Portfolio Project]..CovidDeaths
order by 1,2
-- Looking at Total Cases Vs Total Deaths
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as PercentageDeath
From [Portfolio Project]..CovidDeaths
Where location like '%Nigeria%'
order by 1,2

-- Total Cases VS Population
Select Location,date,total_cases,population,(total_cases/population)*100 as ContactedCOVID
From [Portfolio Project]..CovidDeaths
Where location like '%states%'

-- Countries With The highest Infection Rates

Select Location,population,MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as ContactedCOVID
From [Portfolio Project]..CovidDeaths
--Where location like '%France%'
Group by Location,population
order by ContactedCOVID desc


-- Countries with Highest Death
Select continent ,MAX(cast(total_deaths as int)) as Totaldeaths
From [Portfolio Project]..CovidDeaths
--Where location like '%Germany%'
Where continent is not null
Group by continent
order by Totaldeaths desc       

-- Showing continents with the highest death count per population
Select continent,population,MAX(cast(total_deaths as int)) as Totaldeaths
From [Portfolio Project]..
Where continent is not null
Group by continent
order by Totaldeaths desc       
--Global numbers
Select SUM(new_cases)as total_cases,SUM(cast(new_deaths as int)) as total_death,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as PercentageDeath
From [Portfolio Project]..CovidDeaths
Where continent is not null
--Group by date
order by 1,2
--Looking at Total Population vs Vaccinations
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) As RollingCountofpeoplevaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE
With PopvsVac (Continent,Location,Date,Population,New_vaccinations,RollingCountofpeoplevaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) As RollingCountofpeoplevaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *,(RollingCountofpeoplevaccinated/Population)*100 
From PopvsVac

--TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingCountofpeoplevaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) As RollingCountofpeoplevaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *,(RollingCountofpeoplevaccinated/Population)*100 
From #PercentPopulationVaccinated

-- Creating View for Visulization
Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) As RollingCountofpeoplevaccinated
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Create View CountrywithHighestcovidcount as
Select Location,population,MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as ContactedCOVID
From [Portfolio Project]..CovidDeaths
--Where location like '%Germany%'
Group by Location,population


