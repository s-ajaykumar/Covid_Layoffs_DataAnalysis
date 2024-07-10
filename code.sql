SELECT * 
FROM 
	datacleaningproject1.layoffs;
    
--Creating copy of the table

CREATE TABLE layoffs1
LIKE datacleaningproject1.layoffs;

SELECT *
FROM layoffs1;
INSERT layoffs1
SELECT *
FROM datacleaningproject1.layoffs;

SELECT *
FROM layoffs1;

-- Removing duplicates

SELECT *
, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions) AS rownumber
FROM layoffs1;

WITH layoffs_temp AS (
SELECT *
, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions) AS rownumber
FROM layoffs1 
)
SELECT *
FROM layoffs_temp
WHERE rownumber > 1;

SELECT * 
FROM layoffs1
WHERE company = 'Hibob';

CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs2;

INSERT layoffs2
SELECT *
, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions) AS rownumber
FROM layoffs1;

SELECT *
FROM layoffs2
WHERE row_num > 1;

DELETE 
FROM layoffs2
WHERE row_num > 1;

SELECT *
FROM layoffs2
WHERE row_num > 1;

SELECT *
FROM layoffs2;

ALTER TABLE layoffs2
DROP COLUMN row_num;

SELECT *
FROM layoffs2;


-- Standardizing the data

SELECT *
FROM layoffs2;

  -- Trimming whitespaces
SELECT company, TRIM(company)
FROM layoffs2;

UPDATE layoffs2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs2
ORDER BY industry;

  -- Handling data inconsistencies
SELECT *
FROM layoffs2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs2
ORDER BY country;

SELECT *
FROM layoffs2
WHERE country = 'United States.';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs2
WHERE country LIKE 'United States%'
ORDER BY country;

UPDATE layoffs2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT stage
FROM layoffs2;


  -- Converting the date column from string type into date type
SELECT `date`
, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs2;

UPDATE layoffs2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs2
MODIFY COLUMN `date` DATE;

SELECT DISTINCT stage
FROM layoffs2
ORDER BY stage asc;


-- Handling blanks and null values
SELECT *
FROM layoffs2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE
FROM layoffs2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs2
WHERE industry IS NULL OR industry = '';

  -- Converting the blanks into nulls
UPDATE layoffs2
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs2
WHERE industry IS NULL;

SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs2 t1
JOIN layoffs2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
 AND t2.industry IS NOT NULL;
 
UPDATE layoffs2 t1
JOIN layoffs2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
 AND t2.industry IS NOT NULL;
 
SELECT * 
FROM layoffs2
WHERE industry IS NULL;

SELECT * 
FROM layoffs2;

-- Checking outliers

SELECT DISTINCT total_laid_off
FROM layoffs2
ORDER BY total_laid_off;

SELECT DISTINCT percentage_laid_off
FROM layoffs2
ORDER BY percentage_laid_off;
 





























