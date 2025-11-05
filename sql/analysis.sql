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

-- 1. What offenses are most common in NYC complaints?
SELECT
   ofns_desc,
   COUNT(*) AS total_complaints
FROM public.nypd_complaints
WHERE ofns_desc IS NOT NULL
GROUP BY ofns_desc
ORDER BY total_complaints DESC;

-- 2. What percentage of complaints are classified as felonies in each borough?
SELECT
   boro_nm,
   SUM(CASE WHEN law_cat_cd = 'FELONY' THEN 1 ELSE 0 END) as felony_complaints,
   COUNT(*) AS total_complaints,
   ROUND(
      SUM(CASE WHEN law_cat_cd = 'FELONY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
   , 2) AS percent_felonies
FROM public.nypd_complaints
WHERE boro_nm IS NOT NULL
GROUP BY boro_nm
ORDER BY percent_felonies DESC;

-- 3. Top 10 precincts by total complaints and percent of total NYC complaints.
WITH precinct_counts AS (
   SELECT
      addr_pct_cd AS precinct,
      boro_nm AS borough,
      COUNT(*) AS total_complaints
   FROM public.nypd_complaints
   WHERE addr_pct_cd IS NOT NULL
      AND boro_nm IS NOT NULL
   GROUP BY addr_pct_cd, boro_nm
)
SELECT 
   precinct,
   borough,
   total_complaints,
   ROUND(
      total_complaints * 100.0 / (SELECT COUNT(*) FROM public.nypd_complaints)
   , 2) as percent_of_nyc
FROM precinct_counts
ORDER BY total_complaints DESC
LIMIT 10;

-- 4. Calculate a weighted average crime level by borough.
WITH crime_levels AS (
   SELECT
      boro_nm AS borough,
      CASE
         WHEN law_cat_cd = 'VIOLATION' THEN 1
         WHEN law_cat_cd = 'MISDEMEANOR' THEN 2
         WHEN law_cat_cd = 'FELONY' THEN 3
         ELSE 0
      END AS weighted_level
   FROM public.nypd_complaints
   WHERE boro_nm IS NOT NULL 
     AND law_cat_cd IS NOT NULL
),
total_ratings AS (
   SELECT
      borough,
      COUNT(*) AS total_complaints,
      ROUND(AVG(weighted_level), 2) AS avg_crime_level
   FROM crime_levels
   GROUP BY borough
)
SELECT 
   borough, 
   total_complaints,
   avg_crime_level
FROM total_ratings
ORDER BY avg_crime_level DESC;

---------------------------------------------------
-- Combined Analysis
---------------------------------------------------

-- 1. Do boroughs with higher crime levels tend to have lower housing prices?
WITH crime_levels AS (
   SELECT
      UPPER(boro_nm) AS borough,
      CASE
         WHEN law_cat_cd = 'VIOLATION' THEN 1
         WHEN law_cat_cd = 'MISDEMEANOR' THEN 2
         WHEN law_cat_cd = 'FELONY' THEN 3
         ELSE 0
      END AS weighted_level
   FROM public.nypd_complaints
   WHERE boro_nm IS NOT NULL 
     AND law_cat_cd IS NOT NULL
),
total_ratings AS (
   SELECT
      borough,
      COUNT(*) AS total_complaints,
      ROUND(AVG(weighted_level), 2) AS avg_crime_level
   FROM crime_levels
   GROUP BY borough
),
housing_avg AS (
   SELECT
      boro_name AS borough,
      ROUND(AVG(sale_price)) AS avg_sale_price
   FROM public.housing_sales_borough
   GROUP BY boro_name
)
SELECT
   r.borough,
   r.total_complaints,
   r.avg_crime_level,
   h.avg_sale_price
FROM total_ratings r
JOIN housing_avg h 
   ON r.borough = h.borough
ORDER BY avg_crime_level DESC;

-- 2. 
