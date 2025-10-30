---------------------------------------------------
-- NYC Housing & Safety Project
-- File: analysis.sql
-- Author: Angel Serrano
-- Description: SQL analysis queries for NYC Housing & Safety Project
---------------------------------------------------

---------------------------------------------------
-- Housing & Borough Views
---------------------------------------------------

-- View for valid housing data
CREATE OR REPLACE VIEW public.housing_sales AS 
SELECT *
FROM public.nyc_property_sales
WHERE residential_units >= 1
   AND sale_price > 0;

-- View for housing sales with borough names
CREATE OR REPLACE VIEW public.housing_sales_borough AS
SELECT
   *,
   CASE 
      WHEN borough = 1 then 'Manhattan'
      WHEN borough = 2 THEN 'Bronx'
      WHEN borough = 3 THEN 'Brooklyn'
      WHEN borough = 4 THEN 'Queens'
      WHEN borough = 5 THEN 'Staten Island'
      ELSE NULL
   END AS boro_name
FROM public.housing_sales;

---------------------------------------------------
-- General Data Exploration
---------------------------------------------------

-- Count total rows in housing sales
SELECT 
   COUNT(*) AS total_rows 
FROM public.housing_sales;

-- Get distinct neighborhoods in housing sales
SELECT 
   DISTINCT neighborhood 
FROM public.housing_sales 

-- Count total rows in NYPD complaints
SELECT 
   COUNT(*) AS total_complaints 
FROM public.nypd_complaints;

-- Get distinct offense descriptions in NYPD complaints
SELECT 
   DISTINCT ofns_desc
FROM public.nypd_complaints;

---------------------------------------------------
-- Housing Market Analysis
---------------------------------------------------

-- 1. How many housing sales were there in each borough?
SELECT
   boro_name,
   COUNT(*) AS total_sales
FROM public.housing_sales_borough
GROUP BY boro_name
ORDER BY total_sales DESC;

-- 2. What percentage of housing sales for sold less than $500,000 in each borough?
SELECT
   boro_name,
   SUM(CASE WHEN sale_price < 500000 THEN 1 ELSE 0 END) AS sales_under_500k,
   COUNT(*) AS total_sales,
   ROUND(
      SUM(CASE WHEN sale_price < 500000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
   , 2) AS percent_under_500k
FROM public.housing_sales_borough
GROUP BY boro_name
ORDER BY percent_under_500k DESC; 

-- 3. How have average sales prices changed over time in each borough?
with yearly_avg AS (
   SELECT
      boro_name,
      EXTRACT(YEAR FROM sale_date) AS year,
      ROUND(AVG(sale_price)) AS avg_sale_price
   FROM public.housing_sales_borough
   GROUP BY boro_name, EXTRACT(YEAR FROM sale_date)
), 
first_and_last_years AS (
   SELECT 
      boro_name,
      year,
      avg_sale_price,
      FIRST_VALUE(year) OVER (PARTITION BY boro_name ORDER BY year ASC) AS first_year,
      FIRST_VALUE(year) OVER (PARTITION BY boro_name ORDER BY year DESC) AS last_year,
      FIRST_VALUE(avg_sale_price) OVER (PARTITION BY boro_name ORDER BY year ASC) AS min_avg_price,
      FIRST_VALUE(avg_sale_price) OVER (PARTITION BY boro_name ORDER BY year DESC) AS max_avg_price
   FROM yearly_avg
)
SELECT DISTINCT
   boro_name,
   first_year,
   last_year,
   round((max_avg_price - min_avg_price) * 100.0 / min_avg_price, 2) AS percent_change
FROM first_and_last_years
ORDER BY percent_change DESC;

-- 4. Top 5 Neighborhoods in each borough by Price per Square Foot
WITH prices_sqft AS (
   SELECT 
      boro_name,
      neighborhood,
      ROUND(AVG(sale_price / gross_square_feet), 0) AS avg_price_per_sqft
   FROM public.housing_sales_borough
   WHERE gross_square_feet > 50
   GROUP BY boro_name, neighborhood
   HAVING COUNT(*) > 15
)
SELECT 
   *
FROM (
   SELECT
      boro_name,
      neighborhood,
      avg_price_per_sqft,
      RANK() OVER (PARTITION BY boro_name ORDER BY avg_price_per_sqft DESC) AS ranking
   FROM prices_sqft
   WHERE avg_price_per_sqft IS NOT NULL
) ranked
WHERE ranking <= 5
ORDER BY boro_name, ranking;

---------------------------------------------------
-- NYPD Complaint Analysis
---------------------------------------------------

-- 1. 



---------------------------------------------------
-- Combined Analysis
---------------------------------------------------

