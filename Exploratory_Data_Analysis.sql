-- Exploratory data analysis
SELECT * 
FROM datacleaningproject1.layoffs2;

SELECT MIN(total_laid_off),
MAX(total_laid_off)
FROM layoffs2;

SELECT MIN(percentage_laid_off),
MAX(percentage_laid_off)
FROM layoffs2;

SELECT MIN(`date`),
MAX(`date`)
FROM layoffs2;


-- Countries that laid off most number of staff
SELECT country, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

SELECT company, country, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
WHERE country = 'United States'
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
LIMIT 5;

SELECT company, country, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
WHERE country = 'India'
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
LIMIT 5;

SELECT company, country, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
WHERE country = 'Netherlands'
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
LIMIT 5;


-- Companies that laid off their entire staff
SELECT *
FROM layoffs2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- Year by year number of companies laid off heir entire staff
WITH table_temp AS(
SELECT * 
FROM layoffs2
WHERE percentage_laid_off = 1
)
SELECT YEAR(`date`), COUNT(company)
FROM table_temp
GROUP BY YEAR(`date`)
ORDER BY COUNT(company) DESC; 


-- Companies that laid off the most number of employees from 2020 to 2023
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
GROUP BY company, year
ORDER BY 3 DESC;

SELECT company, SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
GROUP BY company, month
ORDER BY 3 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL 
GROUP BY month
ORDER BY 1;

-- Rolling sum
WITH temp_table AS(
SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY 1
)
SELECT *,
SUM(sum_total_laid_off) OVER (ORDER BY MONTH) AS rolling_sum
FROM temp_table;

-- Ranking them
SELECT company, YEAR(`date`) AS year,
SUM(total_laid_off) 
FROM layoffs2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, year
ORDER BY 3 DESC;

WITH temp_table2 as(
SELECT company, YEAR(`date`) AS year,
SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, year
ORDER BY 3 DESC
), Company_Year_Rank AS (
SELECT *,
DENSE_RANK() OVER (PARTITION BY year ORDER BY sum_total_laid_off DESC) AS laid_off_rank
FROM temp_table2
ORDER BY laid_off_rank
)
SELECT *
FROM Company_Year_Rank
WHERE laid_off_rank <= 5;


-- Industries that laid off the most number of employees from 2020 to 2023
SELECT industry, SUM(total_laid_off)
FROM layoffs2
GROUP BY industry
ORDER BY 2 DESC;


SELECT company, SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs2
GROUP BY company, month
ORDER BY 3 DESC;


-- Companies that raised most funds
SELECT company, `date`, funds_raised_millions, total_laid_off
FROM layoffs2
ORDER BY funds_raised_millions DESC;


 
  


  
