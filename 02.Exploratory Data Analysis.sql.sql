-- Exploratory Data Analysis

SELECT *
FROM layoffs_editing2;


-- Looking for the maximum total layoff and maximum persentage of layoff
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_editing2;


-- Looking for the data where parsentage of layoff is 1 that means 100%
SELECT *
FROM layoffs_editing2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT *
FROM layoffs_editing2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Total no. of layoff in companys
 SELECT company, SUM(total_laid_off)
 FROM layoffs_editing2
 GROUP BY company
 ORDER BY 2 DESC;
 
 
 SELECT industry, SUM(total_laid_off)
 FROM layoffs_editing2
 GROUP BY industry
 ORDER BY 2 DESC;
 
 
SELECT country, SUM(total_laid_off)
FROM layoffs_editing2
GROUP BY country
ORDER BY 2 DESC;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_editing2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 


SELECT stage, SUM(total_laid_off)
FROM layoffs_editing2
GROUP BY stage
ORDER BY 2 DESC;


 -- Date duration of the layoffs
 SELECT MIN(`date`), MAX(`date`)
 FROM layoffs_editing2;
 
 
SELECT SUBSTRING(`date`,1,7) AS `Month`, sum(total_laid_off)
FROM layoffs_editing2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;
 
 
 WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, sum(total_laid_off) AS total_off
FROM layoffs_editing2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`,total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_editing2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_editing2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS `Rank`
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE `Rank` <= 5;