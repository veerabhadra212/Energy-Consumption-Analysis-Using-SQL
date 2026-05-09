CREATE DATABASE Energydb;
USE Energydb;


 -- 1. country table 
CREATE TABLE country ( 
CID VARCHAR(10) PRIMARY KEY, 
Country VARCHAR(100) UNIQUE 
); 

SELECT * FROM country; 


-- 2. emission table 
CREATE TABLE emission ( 
country VARCHAR(100), 
energy_type VARCHAR(50), 
year INT, 
emission INT, 
per_capita_emission DOUBLE, 
FOREIGN KEY (country) REFERENCES country(Country) 
); 

SELECT * FROM emission;

-- 3. population table 
CREATE TABLE population ( 
countries VARCHAR(100), 
year INT, 
Value DOUBLE, 
FOREIGN KEY (countries) REFERENCES country(Country) 
); 

SELECT * FROM population; 

-- 4. production table 
CREATE TABLE production ( 
country VARCHAR(100), 
energy VARCHAR(50), 
year INT, 
production INT, 
FOREIGN KEY (country) REFERENCES country(Country) 
); 

SELECT * FROM production;

-- 5. gdp table 
CREATE TABLE gdp ( 
Country VARCHAR(100), 
year INT, 
Value DOUBLE, 
FOREIGN KEY (Country) REFERENCES country(Country) 
); 

SELECT * FROM gdp; 

-- 6. consumption table 
CREATE TABLE consumption ( 
country VARCHAR(100), 
energy VARCHAR(50), 
year INT, 
consumption INT, 
FOREIGN KEY (country) REFERENCES country(Country) 
); 

DESC consumption; 

-- General & Comparative Analysis 

-- 1. What is the total emission per country for the most recent year available? 
SELECT e.country,
       SUM(e.emission) AS total_emission
FROM emission e
WHERE e.year = (SELECT MAX(year) FROM emission)
GROUP BY e.country
ORDER BY total_emission DESC;

-- 2. What are the top 5 countries by GDP in the most recent year? 
SELECT g.Country,
       g.Value AS gdp_value
FROM gdp g
WHERE g.year = (SELECT MAX(year) FROM gdp)
ORDER BY g.Value DESC
LIMIT 5;

-- 3. Compare energy production and consumption by country and year. 
SELECT p.country,
       p.year,
       p.energy AS energy_type,
       p.production,
       c.consumption,
       (p.production - c.consumption) AS net_surplus
FROM production p
JOIN consumption c
  ON p.country = c.country
 AND p.year    = c.year
 AND p.energy  = c.energy
ORDER BY p.country, p.year, p.energy;
 
-- 4. Which energy types contribute most to emissions across all countries? 
SELECT energy_type,
       SUM(emission) AS total_emission
FROM emission
GROUP BY energy_type
ORDER BY total_emission DESC;

-- Trend Analysis Over Time 

-- 5. How have global emissions changed year over year? 
WITH yearly AS (
  SELECT year,
         SUM(emission) AS total_emission
  FROM emission
  GROUP BY year
)
SELECT year,
       total_emission,
       total_emission - LAG(total_emission) OVER (ORDER BY year)
         AS yoy_change,
       ROUND(
         100 * (total_emission - LAG(total_emission) OVER (ORDER BY year))
         / NULLIF(LAG(total_emission) OVER (ORDER BY year), 0), 2
       ) AS pct_change
FROM yearly
ORDER BY year;

-- 6. What is the trend in GDP for each country over the given years? 
SELECT Country,
       year,
       Value AS gdp,
       Value - LAG(Value) OVER (PARTITION BY Country ORDER BY year)
         AS gdp_change
FROM gdp
ORDER BY Country, year;

-- 7. How has population growth affected total emissions in each country? -- combine all the yrs in one country
SELECT e.country,
       e.year,
       SUM(e.emission)   AS total_emission,
       p.Value           AS population,
       ROUND(SUM(e.emission) / NULLIF(p.Value, 0) * 1000000, 2)
         AS emission_per_million
FROM emission e
JOIN population p
  ON e.country = p.countries
 AND e.year    = p.year
GROUP BY e.country, e.year, p.Value
ORDER BY e.country, e.year;

-- 8. Has energy consumption increased or decreased over the years for major economies? 
SELECT country,
       year,
       SUM(consumption) AS total_consumption,
       SUM(consumption)
         - LAG(SUM(consumption)) OVER (PARTITION BY country ORDER BY year)
         AS yoy_change
FROM consumption
WHERE country IN ('USA', 'China', 'India',
                   'Germany', 'Japan')
GROUP BY country, year
ORDER BY country, year;

-- 9. What is the average yearly change in emissions per capita for each country? -- compare by yrs
WITH ranked AS (
  SELECT country, year, per_capita_emission,
         per_capita_emission
           - LAG(per_capita_emission) OVER
               (PARTITION BY country ORDER BY year) AS yearly_change
  FROM emission
)
SELECT country,
       ROUND(AVG(yearly_change), 4) AS avg_yearly_change
FROM ranked
WHERE yearly_change IS NOT NULL
GROUP BY country
ORDER BY avg_yearly_change;

-- Ratio & Per Capita Analysis 

-- 10. What is the emission-to-GDP ratio for each country by year? 
SELECT e.country,
       e.year,
       SUM(e.emission) AS total_emission,
       g.Value AS gdp,
       ROUND(SUM(e.emission) / NULLIF(g.Value, 0), 6)
         AS emission_to_gdp_ratio
FROM emission e
JOIN gdp g
  ON e.country = g.Country
 AND e.year    = g.year
GROUP BY e.country, e.year, g.Value
ORDER BY e.country, e.year;

-- 11. What is the energy consumption per capita for each country over the last decade? 
SELECT c.country,
       c.year,
       SUM(c.consumption) AS total_consumption,
       p.Value AS population,
       ROUND(SUM(c.consumption) / NULLIF(p.Value, 0), 4)
         AS consumption_per_capita
FROM consumption c
JOIN population p
  ON c.country = p.countries
 AND c.year    = p.year
WHERE c.year >= (SELECT MAX(year) - 10 FROM consumption)
GROUP BY c.country, c.year, p.Value
ORDER BY c.country, c.year;

-- 12. How does energy production per capita vary across countries? 
SELECT pr.country,
       pr.year,
       SUM(pr.production) AS total_production,
       p.Value AS population,
       ROUND(SUM(pr.production) / NULLIF(p.Value, 0), 4)
         AS production_per_capita
FROM production pr
JOIN population p
  ON pr.country = p.countries
 AND pr.year    = p.year
WHERE pr.year = (SELECT MAX(year) FROM production)
GROUP BY pr.country, pr.year, p.Value
ORDER BY production_per_capita DESC;

-- 13. Which countries have the highest energy consumption relative to GDP? -- 
SELECT c.country,
       c.year,
       SUM(c.consumption) AS total_consumption,
       g.Value AS gdp,
       ROUND(SUM(c.consumption) / NULLIF(g.Value, 0), 6)
         AS consumption_to_gdp
FROM consumption c
JOIN gdp g
  ON c.country = g.Country
 AND c.year    = g.year
GROUP BY c.country, c.year, g.Value
ORDER BY consumption_to_gdp DESC
LIMIT 4;

-- 14. What is the correlation between GDP growth and energy production growth? 
WITH growth AS (
  SELECT g.Country AS country, g.year,
         (g.Value - LAG(g.Value) OVER (PARTITION BY g.Country ORDER BY g.year))
           / NULLIF(LAG(g.Value) OVER (PARTITION BY g.Country ORDER BY g.year), 0)
           AS gdp_growth,
         (SUM(p.production)
           - LAG(SUM(p.production)) OVER (PARTITION BY g.Country ORDER BY g.year))
           / NULLIF(LAG(SUM(p.production)) OVER (PARTITION BY g.Country ORDER BY g.year), 0)
           AS prod_growth
  FROM gdp g
  JOIN production p
    ON g.Country = p.country AND g.year = p.year
  GROUP BY g.Country, g.year, g.Value
)
SELECT ROUND(
  (COUNT(*) * SUM(gdp_growth * prod_growth)
    - SUM(gdp_growth) * SUM(prod_growth))
  / NULLIF(
      SQRT(
        (COUNT(*) * SUM(gdp_growth * gdp_growth) - POW(SUM(gdp_growth), 2))
        * (COUNT(*) * SUM(prod_growth * prod_growth) - POW(SUM(prod_growth), 2))
      ), 0
    ), 4
) AS pearson_correlation
FROM growth
WHERE gdp_growth IS NOT NULL AND prod_growth IS NOT NULL;

-- Global Comparisons 

-- 15. What are the top 10 countries by population and how do their emissions compare? 
WITH top_pop AS (
  SELECT countries, Value AS population
  FROM population
  WHERE year = (SELECT MAX(year) FROM population)
  ORDER BY Value DESC
  LIMIT 10
)
SELECT tp.countries,
       tp.population,
       SUM(e.emission) AS total_emission
FROM top_pop tp
LEFT JOIN emission e
  ON tp.countries = e.country
 AND e.year = (SELECT MAX(year) FROM emission)
GROUP BY tp.countries, tp.population
ORDER BY tp.population DESC;

--  16. Which countries have improved (reduced) their per capita emissions the most over the last decade? -- atleast return 0 for no emission change
WITH latest AS (
  SELECT country, AVG(per_capita_emission) AS latest_pce
  FROM emission
  WHERE year = 2023
  GROUP BY country
),
year_start AS (
  SELECT country, AVG(per_capita_emission) AS start_pce
  FROM emission
  WHERE year = 2020
  GROUP BY country

)
SELECT l.country,
       ROUND(ds.start_pce, 4) AS pce_Year2020,
       ROUND(l.latest_pce, 4) AS pce_Year2023,
       ROUND(l.latest_pce - ds.start_pce, 4) AS change_in_emission
FROM latest l
JOIN year_start ds ON l.country = ds.country
ORDER BY change_in_emission ASC
LIMIT 10;


-- 17. What is the global share (%) of emissions by country? 
WITH totals AS (
  SELECT SUM(emission) AS global_total
  FROM emission
)
SELECT e.country,
       SUM(e.emission) AS total_emission,
       ROUND(100.0 * SUM(e.emission) / t.global_total, 2) AS global_share_pct
FROM emission e, totals t
GROUP BY e.country, t.global_total
ORDER BY global_share_pct DESC;

-- 18. What is the global average GDP, emission, and population by year?
SELECT e.year,
       ROUND(AVG(g.Value), 2)   AS avg_gdp,
       ROUND(AVG(e.emission), 2) AS avg_emission,
       ROUND(AVG(p.Value), 2)   AS avg_population
FROM emission e
JOIN gdp g
  ON e.country = g.Country AND e.year = g.year
JOIN population p
  ON e.country = p.countries AND e.year = p.year
GROUP BY e.year
ORDER BY e.year;
