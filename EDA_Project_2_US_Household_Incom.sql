# US Household Income (EDA)

SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;


#Exploring Aland and Awater
SELECT state_name, SUM(Aland), SUM(Awater)
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 2 DESC;

SELECT state_name, SUM(Aland), SUM(Awater)
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 3 DESC
LIMIT 10;

# INNER JOIN BOTH TABLES
SELECT *
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id;

#FILTER OUT 0 STATITISCS REPORTED IN MEAN, MEDIAN, STDEV
SELECT *
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id
WHERE mean <> 0;

SELECT u.state_name, county, type, `primary`, mean, median
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id
WHERE mean <> 0;

#Reviewing AVG household income
SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 3 DESC
LIMIT 10;

SELECT type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id
WHERE mean <> 0
GROUP BY type
ORDER BY 3 DESC
;

SELECT type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id
WHERE mean <> 0
GROUP BY 1
HAVING COUNT(type) > 100
ORDER BY 4 DESC
;

SELECT *
FROM us_project.us_household_income
WHERE type = 'urban';

SELECT u.state_name, city, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income AS u
JOIN us_project.us_household_income_statistics AS us
ON u.id = us.id
GROUP BY u.state_name, city
ORDER BY ROUND(AVG(mean),1) DESC;

