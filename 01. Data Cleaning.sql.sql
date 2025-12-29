-- Data Cleaning

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Populate Null Values or Blank Values
-- 4. Remove Any Columns and rows that are not necessary

SELECT *
FROM layoffs;

-- Create a new table where we will perform all the queries. Let the raw data to be as it is.
CREATE TABLE layoffs_editing
LIKE layoffs;

INSERT INTO layoffs_editing
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_editing;

-- Ckeck for duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_editing
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- A method for removing duplicates
CREATE TABLE `layoffs_editing2` (
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

INSERT INTO layoffs_editing2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_editing;

SELECT *
FROM layoffs_editing2;

SELECT *
FROM layoffs_editing2
WHERE row_num > 1;

DELETE
FROM layoffs_editing2
WHERE row_num > 1;

-- 2. Standardizing data

SELECT DISTINCT company
FROM layoffs_editing2;

UPDATE layoffs_editing2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_editing2
ORDER BY 1;

SELECT *
FROM layoffs_editing2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_editing2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_editing2;

SELECT DISTINCT location
FROM layoffs_editing2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_editing2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_editing2
ORDER BY 1;

UPDATE layoffs_editing2
SET country = TRIM(TRAILING '.' FROM country);

SELECT DISTINCT `date`
FROM layoffs_editing2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_editing2;

UPDATE layoffs_editing2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_editing2
MODIFY COLUMN `date` DATE;

-- 3. Populate Null Values or Blank Values
SELECT *
FROM layoffs_editing2
WHERE industry IS NULL
OR industry = '';

-- we need to check if we can populate those null values
SELECT *
FROM layoffs_editing2
WHERE company = 'Airbnb';

UPDATE layoffs_editing2
SET industry = NULL
WHERE industry = '';
-- Let's populate the null values
SELECT *
FROM layoffs_editing2 t1
JOIN layoffs_editing2 t2
	ON t1.company = t2.company
    AND t1.location = t1.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_editing2 t1
JOIN layoffs_editing2 t2
	ON t1.company = t2.company
    AND t1.location = t1.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 4. Remove Any Columns and rows that are not necessary

SELECT *
FROM layoffs_editing2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_editing2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_editing2
DROP COLUMN row_num;

SELECT *
FROM layoffs_editing2;
-- The final Cleaned Data