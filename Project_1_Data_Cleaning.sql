#World Life Expetancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

#REMOVE DUPLICATES
SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year)) AS count_year
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country, year)
HAVING count_year > 1
;

SELECT *
FROM (
	SELECT row_id,
	CONCAT(country, year),
	row_number() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
	FROM world_life_expectancy
    ) AS row_table
WHERE row_num > 1
;

DELETE FROM world_life_expectancy
WHERE 
	row_id IN (
	SELECT row_id
FROM (
	SELECT row_id,
	CONCAT(country, year),
	row_number() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
	FROM world_life_expectancy
    ) AS row_table
WHERE row_num > 1
)
;

SELECT *
FROM world_life_expectancy
WHERE country = 'United States of America'
;



SELECT DISTINCT(status) 
FROM world_life_expectancy
WHERE Status <>''
;

SELECT DISTINCT (country) 
FROM world_life_expectancy
WHERE Status = 'Developing'
;

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE country IN (SELECT DISTINCT (country) 
FROM world_life_expectancy
WHERE Status = 'Developing')
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country = t2.country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country = t2.country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT *
FROM world_life_expectancy
# WHERE `life expectancy` = ''
;


SELECT country, year, `life expectancy`
FROM world_life_expectancy
# WHERE `life expectancy` = ''
;

SELECT t1.country, t1.year, t1.`life expectancy`, 
t2.country, t2.year, t2.`life expectancy`,
t3.country, t3.year, t3.`life expectancy`,
ROUND((t2.`life expectancy` + t3.`life expectancy`) / 2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country = t2.country
AND T1.year = t2.year - 1
JOIN world_life_expectancy t3
ON t1.country = t3.country
AND T1.year = t3.year + 1
WHERE t1.`Life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
	AND T1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
	AND T1.year = t3.year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`) / 2,1)
WHERE t1.`life expectancy` = ''
;

SELECT *
FROM world_life_expectancy
# WHERE `life expectancy` = ''
;


