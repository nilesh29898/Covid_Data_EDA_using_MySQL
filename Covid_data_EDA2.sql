SELECT * FROM portfolio_project.covid_data;

use portfolio_project;

select * from covid_death order by location, date;

create table deaths as select * from covid_death;

select date, concat(right(date,4),'-',substring(date,4,2),'-',left(date,2)) from covid_death;

update deaths set date = concat(right(date,4),'-',substring(date,4,2),'-',left(date,2));

select * from deaths;

create table covid_vaccinations as select * from covid_vaccination;

update covid_vaccinations set date = concat(right(date,4),'-',substring(date,4,2),'-',left(date,2));

use portfolio_project;

create table covid_data as  select d.*, v.* from covid_deaths as d inner join covid_vaccinations as v on d.id = v.vid;


select d.location, d.date, d.total_cases, d.new_cases, d.total_deaths, v.population 
from covid_deaths as d inner join covid_vaccinations as v on d.id = v.id order by location, date;


use portfolio_project;

alter table covid_data drop column vid;




select location, date, total_cases, new_cases, total_deaths, population 
from covid_data where location = 'afghanistan' order by date desc;

-- Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage 
from covid_data where location = 'india' order by date desc;

-- Total Cases vs Population

SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS total_cases_percentage
FROM
    covid_data;

-- Highest Infection rate compared to population

SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS total_cases_percentage
FROM
    covid_data
WHERE
    date = '2021-09-25'
ORDER BY total_cases_percentage DESC;

-- Countries with highest dealth count

SELECT 
    location,
    date,
    total_cases, cast(total_deaths as unsigned) as total_deaths_per_country,
    population
FROM
    covid_data
WHERE
    date = '2021-09-25'
ORDER BY total_deaths_per_country DESC;

-- Highest number of total cases

SELECT 
    location, cast(total_cases as unsigned) as total_cases_per_country , population
FROM
    covid_data
WHERE
    date = '2021-09-25'
ORDER BY date DESC , total_cases_per_country DESC;


-- continents with highest death count

select continent, sum(total_deaths) as t_deaths, sum(total_cases ), sum(population) from covid_data
 where date = '2021-09-25' group by continent order by t_deaths desc ;
 
-- Global numbers by date
 
 SELECT 
    date,
    SUM(new_cases),
    SUM(new_deaths),
    SUM(total_deaths),
    SUM(total_cases)
FROM
    covid_data
GROUP BY date
ORDER BY date DESC; 

-- New vaccination done per day globally

 SELECT 
    date,
    SUM(new_cases) as new_cases,
    SUM(new_deaths) as new_deaths,
    SUM(total_deaths) as total_deaths,
    SUM(total_cases) as total_cases, 
    sum(population) as population,
    sum(new_vaccinations) as new_vaccinations,
    sum(total_vaccinations) as total_vaccinations
    
FROM
    covid_data 
GROUP BY date
ORDER BY date DESC;

-- Total deaths, cases , vaccinations and vaccination percentage uptil now by each country

SELECT 
    location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_deaths,
    MAX(CAST(total_cases AS UNSIGNED)) AS total_cases,
    MAX(CAST(population AS UNSIGNED)) AS population,
    MAX(CAST(total_vaccinations AS UNSIGNED)) AS total_vaccinations,
    ROUND((MAX(CAST(total_vaccinations AS UNSIGNED)) / population) * 100,2) AS vaccination_percentage
FROM
    covid_data
GROUP BY location
ORDER BY total_cases DESC;


 -- Create a Views from data visualization
 
 -- continents with highest death count
CREATE VIEW continents_death_ratio AS
    SELECT 
        continent,
        SUM(total_deaths) AS total_deaths,
        SUM(total_cases) AS total_cases,
        SUM(population) AS population
    FROM
        covid_data
    WHERE
        date = '2021-09-25'
    GROUP BY continent
    ORDER BY total_deaths DESC;

 
 -- New vaccination done per day globally
 
CREATE VIEW vaccination_per_day_globally AS
    SELECT 
        date,
        SUM(new_cases) AS new_cases,
        SUM(new_deaths) AS new_deaths,
        SUM(total_deaths) AS total_deaths,
        SUM(total_cases) AS total_cases,
        SUM(population) AS population,
        SUM(new_vaccinations) AS new_vaccinations,
        SUM(total_vaccinations) AS total_vaccinations
    FROM
        covid_data
    GROUP BY date
    ORDER BY date DESC;


--  Population vaccinated percentages

create view population_vaccinated_percentage as 
SELECT 
    location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_deaths,
    MAX(CAST(total_cases AS UNSIGNED)) AS total_cases,
    MAX(CAST(population AS UNSIGNED)) AS population,
    MAX(CAST(total_vaccinations AS UNSIGNED)) AS total_vaccinations,
    ROUND((MAX(CAST(total_vaccinations AS UNSIGNED)) / population) * 100, 2) AS vaccination_percentage
FROM
    covid_data
GROUP BY location
ORDER BY total_cases DESC;


