---------------------------------------------------
-- NYC Housing & Safety Project
-- Table: nyc_property_sales
-- Author: Angel Serrano
-- Description: Contains NYC property sales data provided by the Department of Finance from NYC Open Data
---------------------------------------------------

-- Drop the table if it already exists
DROP TABLE IF EXISTS public.nyc_property_sales;

-- Create the nyc_property_sales table
CREATE TABLE IF NOT EXISTS public.nyc_property_sales (
   borough INT,
   neighborhood TEXT,
   building_class_category TEXT,
   tax_class_as_of_final_roll TEXT,
   block TEXT,
   lot TEXT,
   ease_ment TEXT,
   building_class_as_of_final_roll TEXT,
   address TEXT,
   apartment_number TEXT,
   zip_code TEXT,
   residential_units TEXT,
   commercial_units TEXT,
   total_units TEXT,
   land_square_feet TEXT,
   gross_square_feet TEXT,
   year_built INT,
   tax_class_at_time_of_sale TEXT,
   building_class_at_time_of_sale TEXT,
   sale_price TEXT,
   sale_date TEXT,
   latitude NUMERIC(10,6),
   longitude NUMERIC(10,6),
   community_board TEXT,
   council_district TEXT,
   bin TEXT,
   bbl TEXT,
   census_tract_2020 TEXT,
   nta_2020 TEXT
);

-- Wrap in Begin and Commit for safe stransactions
BEGIN;

-- Create cleaned numeric columns
ALTER TABLE public.nyc_property_sales
ADD COLUMN residential_units_num INT,
ADD COLUMN commercial_units_num INT,
ADD COLUMN total_units_num INT,
ADD COLUMN land_square_feet_num NUMERIC,
ADD COLUMN gross_square_feet_num NUMERIC,
ADD COLUMN sale_price_num NUMERIC;

-- Clean and convert columns to appropriate data types
UPDATE public.nyc_property_sales
SET
   residential_units_num = replace(residential_units, ',', '')::INT,
   commercial_units_num = replace(commercial_units, ',', '')::INT,
   total_units_num = replace(total_units, ',', '')::INT,
   land_square_feet_num = replace(land_square_feet, ',', '')::NUMERIC,
   gross_square_feet_num = replace(gross_square_feet, ',', '')::NUMERIC,
   sale_price_num = round(replace(replace(sale_price, '$', ''), ',', '')::NUMERIC, 0);

-- Drop old text columns
ALTER TABLE public.nyc_property_sales
DROP COLUMN residential_units,
DROP COLUMN commercial_units,
DROP COLUMN total_units,
DROP COLUMN land_square_feet,
DROP COLUMN gross_square_feet,
DROP COLUMN sale_price;

-- Rename cleaned columns to original names
ALTER TABLE public.nyc_property_sales RENAME COLUMN residential_units_num TO residential_units;
ALTER TABLE public.nyc_property_sales RENAME COLUMN commercial_units_num TO commercial_units;
ALTER TABLE public.nyc_property_sales RENAME COLUMN total_units_num TO total_units;
ALTER TABLE public.nyc_property_sales RENAME COLUMN land_square_feet_num TO land_square_feet;
ALTER TABLE public.nyc_property_sales RENAME COLUMN gross_square_feet_num TO gross_square_feet;
ALTER TABLE public.nyc_property_sales RENAME COLUMN sale_price_num TO sale_price;

-- convert sale_date to DATE type
ALTER TABLE public.nyc_property_sales
   ALTER COLUMN sale_date TYPE DATE USING TO_DATE(sale_date, 'MM/DD/YYYY');

COMMIT;

-- Add Primary Key to Cleaned Table
ALTER TABLE public.nyc_property_sales
ADD COLUMN IF NOT EXISTS id SERIAL PRIMARY KEY;