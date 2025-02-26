create database netflix;
use netflix;
-- importing data into the database
--  1. Handle Missing Data
-- Fill or replace missing data for country, rating, and date_added:
-- Replace missing country with "Unknown"
UPDATE netflix_titles
SET country = 'Unknown'
WHERE country IS NULL OR country = '';

-- Replace missing ratings with "Not Rated"
UPDATE netflix_titles
SET rating = 'Not Rated'
WHERE rating IS NULL OR rating = '';

-- Convert missing date_added to NULL
UPDATE netflix_titles
SET date_added = NULL
WHERE date_added = '';


-- Remove Duplicates
-- Identify duplicates
SELECT show_id, COUNT(*)
FROM netflix_titles
GROUP BY show_id
HAVING COUNT(*) > 1;

--  Standardize Formats
-- Clean and format date_added, duration, and country fields:
-- Standardize date_added format to YYYY-MM-DD
UPDATE netflix_titles
SET date_added = STR_TO_DATE(date_added, '%M %d, %Y') 
WHERE date_added IS NOT NULL;

-- Extract numeric duration (only if applicable, e.g., "90 min" or "3 Seasons")
UPDATE netflix_titles
SET duration = TRIM(SUBSTRING_INDEX(duration, ' ', 1))
WHERE duration IS NOT NULL;


--  Filter Key Attributes
-- Remove irrelevant or invalid rows to focus on quality data:
-- Remove rows with missing critical fields
DELETE FROM netflix_titles
WHERE title IS NULL OR release_year IS NULL;

-- Remove invalid release years (e.g., negative or future years)
DELETE FROM netflix_titles
WHERE release_year < 1900 OR release_year > YEAR(CURDATE());

-- Keep only Movies and TV Shows
DELETE FROM netflix_titles
WHERE type NOT IN ('Movie', 'TV Show');


-- Data Integrity Validation
-- Validate column data types and counts for consistency:
-- Validate data types
SELECT 
    DATA_TYPE, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'netflix_titles';

-- Check for rows with invalid data
SELECT *
FROM netflix_titles
WHERE release_year NOT BETWEEN 1900 AND YEAR(CURDATE());



-- Preview cleaned data
SELECT * 
FROM netflix_titles
LIMIT 10;

-- Count remaining rows
SELECT COUNT(*) AS total_cleaned_rows
FROM netflix_titles;
-- delete irrelevant columns 
alter table netflix_titles drop column MyUnknownColumn;
