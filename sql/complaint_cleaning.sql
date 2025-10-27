---------------------------------------------------
-- NYC Housing & Safety Project
-- Table: nyc_complaints
-- Author: Angel Serrano
-- Description: Contains NYC Complaint data provided by the NYPD from NYC Open Data
---------------------------------------------------

-- Drop the table if it already exists
DROP TABLE IF EXISTS public.nypd_complaints;

-- Create the nyc_complaints table
CREATE TABLE IF NOT EXISTS public.nypd_complaints (
   cmplnt_num TEXT,
   addr_pct_cd INT,
   boro_nm TEXT,
   cmplnt_fr_dt TIMESTAMP,
   cmplnt_fr_tm TEXT,
   cmplnt_to_dt TIMESTAMP,
   cmplnt_to_tm TEXT,
   crm_atpt_cptd_cd TEXT,
   hadevelopt TEXT,
   housing_psa INT,
   jurisdiction_code INT,
   juris_desc TEXT,
   ky_cd INT,
   law_cat_cd TEXT,
   loc_of_occur_desc TEXT,
   ofns_desc TEXT,
   parks_nm TEXT,
   patrol_boro TEXT,
   pd_cd INT,
   pd_desc TEXT,
   prem_typ_desc TEXT,
   rpt_dt TIMESTAMP,
   station_name TEXT,
   susp_age_group TEXT,
   susp_race TEXT,
   susp_sex TEXT,
   transit_district INT,
   vic_age_group TEXT,
   vic_race TEXT,
   vic_sex TEXT,
   x_coord_cd INT,
   y_coord_cd INT,
   latitude NUMERIC(10,6),
   longitude NUMERIC(10,6),
   lat_lon TEXT,
   new_geocoded_col TEXT
);

-- Wrap in Begin and Commit for safe stransactions
BEGIN;

-- update specified columns to replace '(null)' with actual NULL values
UPDATE public.nypd_complaints
SET
   cmplnt_fr_tm = NULLIF(cmplnt_fr_tm, '(null)'),
   cmplnt_to_tm = NULLIF(cmplnt_to_tm, '(null)'),
   crm_atpt_cptd_cd = NULLIF(crm_atpt_cptd_cd, '(null)'),
   hadevelopt = NULLIF(hadevelopt, '(null)'),
   boro_nm = NULLIF(boro_nm, '(null)'),
   juris_desc = NULLIF(juris_desc, '(null)'),
   law_cat_cd = NULLIF(law_cat_cd, '(null)'),
   loc_of_occur_desc = NULLIF(loc_of_occur_desc, '(null)'),
   ofns_desc = NULLIF(ofns_desc, '(null)'),
   parks_nm = NULLIF(parks_nm, '(null)'),
   patrol_boro = NULLIF(patrol_boro, '(null)'),
   pd_desc = NULLIF(pd_desc, '(null)'),
   prem_typ_desc = NULLIF(prem_typ_desc, '(null)'),
   station_name = NULLIF(station_name, '(null)'),
   susp_age_group = NULLIF(susp_age_group, '(null)'),
   susp_race = NULLIF(susp_race, '(null)'),
   susp_sex = NULLIF(susp_sex, '(null)'),
   vic_age_group = NULLIF(vic_age_group, '(null)'),
   vic_race = NULLIF(vic_race, '(null)'),
   vic_sex = NULLIF(vic_sex, '(null)'),
   lat_lon = NULLIF(lat_lon, '(null)');

-- convert text fields to appropriate data types
ALTER TABLE public.nypd_complaints
   ALTER COLUMN cmplnt_fr_tm TYPE TIME USING cmplnt_fr_tm::TIME,
   ALTER COLUMN cmplnt_to_tm TYPE TIME USING cmplnt_to_tm::TIME;

COMMIT;

-- Add Primary Key to Cleaned Table
ALTER TABLE public.nypd_complaints
ADD COLUMN IF NOT EXISTS id SERIAL PRIMARY KEY;