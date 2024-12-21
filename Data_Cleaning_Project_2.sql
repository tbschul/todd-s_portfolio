#US Household Income Data Cleaning

SELECT * 
FROM us_project.us_household_income
;

SELECT * 
FROM us_project.us_household_income_statistics
;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT COUNT(*)
FROM us_household_income
;

SELECT COUNT(*)
FROM us_household_income_statistics;

#DATA CLEANING

# IDENTIFYING ID DUPLICATES
SELECT id, COUNT(id) 
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

#Removing Duplicates
SELECT *
FROM
(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;


#DELETED DUPLICATES WITH SUBQUERY
DELETE FROM  us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
	SELECT row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	FROM us_project.us_household_income
	) duplicates
	WHERE row_num > 1)
;

#REVEAL DUPLICATES - NONE IN THIS TABLE
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM us_project.us_household_income
;

#Reviewing incorrect state_names
SELECT state_name, COUNT(state_name)
FROM us_project.us_household_income
GROUP BY state_name
;

#Distinct State Names
SELECT DISTINCT state_name
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 1
;

#UPDATE INCORRECT STATE NAME georia to georgia
UPDATE us_project.us_household_income
SET state_name = 'Georgia' 
WHERE state_name = 'georia';

#UPDATE INCORRECT STATE NAME alabama to 'Alabama'
UPDATE us_project.us_household_income
SET state_name = 'Alabama' 
WHERE state_name = 'alabama';

#Review State Abrevs
SELECT DISTINCT state_ab
FROM us_project.us_household_income;

#MISSING PLACE NAMES
SELECT *
FROM us_project.us_household_income
WHERE place = ''
ORDER BY 1
;

#REPLACE MISSING PLACE VALUE
SELECT *
FROM us_project.us_household_income
WHERE county = 'Autauga County'
ORDER BY 1;

#UPDATE MISSING PLACE NAME
UPDATE us_household_income
SET place = 'Autaugaville'
WHERE county = 'Autauga County'
AND city = 'Vinemont';

#Reviewing type column
SELECT type, COUNT(type)
FROM us_project.us_household_income
GROUP BY type;

#UPDATE Boroughs to Borough
UPDATE us_project.us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';

#Review Table Awater only zeros
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = NULL OR AWater = '';

#Review Aland ONLY ZEROS CONFIRMED
SELECT Aland
FROM us_project.us_household_income
WHERE Aland = 0 OR Aland = NULL OR Aland = '';

SELECT *
FROM us_project.us_household_income
;

SELECT DISTINCT city, county
FROM us_project.us_household_income; 

#SPELLING ERROR Montgomery and Montgmomery
SELECT city
FROM us_project.us_household_income
WHERE city LIKE '%MONT%'
;

UPDATE us_project.us_household_income
SET city = 'Montgomery'
WHERE city = 'Montgmomery';




