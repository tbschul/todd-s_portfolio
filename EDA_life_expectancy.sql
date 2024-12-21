# World Life Expectancy Project (EDA)

SELECT *
FROM world_life_expectancy
;

SELECT country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND (MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_increase_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY  Life_increase_15_years DESC
;

SELECT year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE (`Life expectancy`) <> 0
AND (`Life expectancy`) <> 0
GROUP BY year
ORDER BY year 
;

SELECT *
FROM world_life_expectancy
;


SELECT country, ROUND(AVG(`Life expectancy`),1) AS life_e, ROUND(AVG(gdp),1) as gdp
FROM world_life_expectancy
GROUP BY country
HAVING life_e > 0
AND GDP > 0
ORDER BY GDP DESC
;

#High coorelation between GDP and Life Expectancy
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) high_gdp_count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) high_gdp_life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) low_gdp_count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) low_gdp_life_expectancy
FROM world_life_expectancy
;

SELECT *
FROM world_life_expectancy
;

SELECT status, ROUND(AVG(`Life expectancy`),1) AS life_e
FROM world_life_expectancy
GROUP BY status;

#LIFE EXP VS BMI
SELECT country, ROUND(AVG(`Life expectancy`),1) AS life_exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0
AND BMI > 0 
ORDER BY BMI DESC
;

#ROLLING TOTAL
SELECT country,
year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY country ORDER BY year) AS rolling_total
FROM world_life_expectancy
WHERE country like '%United%'
;
