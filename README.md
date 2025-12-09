# NYC Housing & Crime Analysis
Insights into the relationship between NYC housing activity and NYPD complaint patterns.

## Project Overview
This project combines NYC housing sales and NYPD complaint data to uncover how market trends align with public safety patterns across boroughs. SQL was used for data cleaning and analysis and Tableau was used to build interactive visualizations and dashboards. The analysis highlights differences in pricing, sales activity, and complaint levels across NYC from 2016–2024.

## Data Sources

### NYC Citywide Annualized Calendar Sales
- Downloaded: Oct 22, 2025
- Row count at download: ~761k
- Current row count (as of Nov 25, 2025): ~761k
- Source: [`NYC Citywide Annualized Calendar Sales`](https://data.cityofnewyork.us/City-Government/NYC-Citywide-Annualized-Calendar-Sales-Update/w2pb-icbu/about_data)

### NYPD Complaint Data Current (Year To Date)
- Downloaded: Oct 22, 2025
- Row count at downloaded: ~288k
- Current row count (as of Nov 25, 2025): ~439k
- Source: [`NYPD Complaint Data`](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Current-Year-To-Date-/5uac-w243/about_data)

## Data Cleaning & Preparation

### Housing Sales
- Loaded raw NYC property sales data into the `nyc_property_sales` table
- Converted text based numeric fields (sale price, square footage, unit counts) into numeric data types
- Removed commas and dollar signs before casting
- Dropped original text columns to avoid redundancy
- Standardized date formatting by converting sale_date from text into date type
- Added a primary key for indexing and to ensure row uniqueness
- [`SQL Cleaning File`](./sql/sales_cleaning.sql)

### NYPD Complaints
- Loaded raw NYPD complaint data into the `nypd_complaints` table
- Replaced text `'(null)'` values with actual SQL NULLs across multiple text fields
- Converted text time fields into proper time type
- Added a primary key for indexing and to ensure row uniqueness
- [`SQL Cleaning File`](./sql/complaint_cleaning.sql)

## Repository Structure
```
├── data/                                 # Sample versions of the raw datasets
│   ├── NYC_Citywide_Sales_Sample.csv
│   └── NYPD_Complaint_Data_Sample.csv
│
├── query_results/                        # Outputs from SQL queries (used in Tableau)
│   ├── analysis_query1.csv
│   ├── analysis_query2.csv
│   ├── analysis_query3.csv
│   ├── analysis_query4.csv
│   ├── analysis_query5.csv
│   ├── complaint_query1.csv
│   ├── complaint_query2.csv
│   ├── complaint_query3.csv
│   ├── complaint_query4.csv
│   ├── housing_query1.csv
│   ├── housing_query2.csv
│   ├── housing_query3.csv
│   └── housing_query4.csv
│
├── sql/                                  # SQL scripts for cleaning + full analysis
│   ├── analysis_queries.sql
│   ├── complaint_cleaning.sql
│   └── sales_cleaning.sql
├── .gitignore
├── LICENSE
└── README.md
```

## SQL Analysis

All SQL queries used for this project can be viewed in this file:
[`analysis.sql`](./sql/analysis.sql)

### 1. Views for Housing Sales
These views prepare the NYC Citywide Sales dataset for analysis:

- `housing_sales` view  
Filters all property sales for valid housing sales (sale price > 0 and at least 1 residential unit).
- `housing_sales_borough` view  
Adds borough names (Queens, Manhattan, Bronx, Brooklyn, Staten Island) based on borough number.

### 2. Data Exploration Queries
These queries ensure that data was imported correctly before working on analysis queries.

- **Total rows** in housing data and complaint data
- **Distinct neighborhoods** in housing data
- **Distinct offense descriptions** in the complaints data

### 3. Housing Market Analysis
These queries explore trends in sales, affordability, price changes, and neighborhood comparisons.

- **Total housing sales by borough**  
- **Housing sales under $500k**
- **Percent change in average sale price over time**
- **Top 5 neighborhoods by price per square foot**  

### 4. NYPD Complaint Analysis
These queries analyze citywide complaint patterns, offense types, and severity levels across NYC boroughs.

- **Most common NYPD offenses**  
- **Felony percentage by borough**
- **Complaint totals ranked by precinct**
- **Weighted complaint severity (1–3 scale)**

### 5. Combined Analysis
These queries connect NYC housing trends with public safety patterns.

- **Complaints per housing sale**
- **Housing prices vs. complaint severity**
- **Top 3 expensive neighborhoods compared with borough complaint totals**
- **Monthly housing sales vs. monthly complaints**
- **Complaint density per million square feet**

## Tableau Dashboards
Dashboards built in tableau visualize trends in housing, public safety and the relationships between the two.

- **Dashboard 1 - Housing Trends Overview**
Visualizes borough-level sales, affordability trends, and changes in average housing prices.
[`Dashboard 1`](https://public.tableau.com/app/profile/angel.serrano2901/viz/NYCHousingandSafetyAnalysis/dashboard_housing_overview)

- **Dashboard 2 - Public Safety Overview**
Shows the most common offenses, felony share, complaint distribution, and severity levels across NYC boroughs.
[`Dashboard 2`](https://public.tableau.com/app/profile/angel.serrano2901/viz/NYCHousingandSafetyAnalysis/dashboard_safety_overview)

- **Dashboard 3 - Combined Analysis Overview**
Combines housing and complaint data to show how housing market trends align with public safety trends.
[`Dashboard 3`](https://public.tableau.com/app/profile/angel.serrano2901/viz/NYCHousingandSafetyAnalysis/dashboard_combined_overview)

## Key Findings

### 1. Housing Market Findings
- Queens and Brooklyn have the most sales, with the Bronx having the least.
- Queens, Staten Island, and the Bronx have the most sales under $500k, with Manhattan having the fewest. Overall, the number of sales under $500k is low across all boroughs. 
- Staten Island, Queens, and Brooklyn had the strongest growth in average sale price from 2016 to 2024. Manhattan and the Bronx had minimal growth.
- Manhattan's top neighborhoods are by far the most expensive with Brooklyn following closely behind and still priced higher than the rest of the boroughs.

### 2. Public Safety Findings
- Most NYC offenses are non-violent with petit larceny and harassment making up the largest share of complaints, while violent crimes occur far less frequently.
- Brooklyn and Manhattan have the most complaints overall while Staten Island has the fewest. Felonies make up a small percentage of total complaints in every borough, generally around 25-30%.
- Brooklyn makes up the largest percentage of NYC complaints followed closely by Manhattan, the Bronx, and Queens. Staten Island has the smallest percentage.
- Although the Bronx and Manhattan have slightly higher severity levels, complaint severity is similar across all boroughs averaging around 2.15, just above misdemeanor level.

### 3. Combined Analysis Findings
- Monthly housing sales show a consistent pattern with sales dipping in winter and increasing in the spring and summer, with a sharp decline in 2020 that aligns with the COVID-19 shutdown followed by a spike of sales post-pandemic. However, monthly complaint data cannot be interpreted meaningfully as complaints are not recorded evenly over time, most were logged in 2024.
- The Bronx has the highest complaint rate per housing sale, close to double Manhattan's rate and far above the other boroughs.
- Manhattan has by far the highest housing prices (around $4 million), with Brooklyn following closely while the other boroughs are much lower. However, complaint severity only varies slightly across boroughs, showing there is no clear link between housing prices and complaint severity.
- Manhattan's top neighborhoods are significantly more expensive than those in any other borough. Brooklyn neighborhoods are the next closest but still far behind.
- The Bronx has by far the highest complaint density relative to housing area, higher than every other borough with Staten Island having the lowest.

## Technologies Used
- **PostgreSQL** - data storage and SQL analysis
- **SQL** - data cleaning, filtering, and transformations
- **Tableau Public** - visualizations and interactive dashboards
- **Git & GitHub** - version control and project documentation

## Limitations & Future Work
- The NYPD complaint dataset was updated after download. It increased from ~288k rows (Oct 22, 2025) to ~439k rows (Nov 25, 2025).
- Complaint dates are not recorded evenly, most of them were recorded in 2024, which makes monthly complaint trends unreliable. 
- Housing data only shows final sale prices and does not show initial listing prices or any bidding activity.
- Complaint data was analyzed at the borough level, so safety insights at the nieghborhood level are less detailed.

## Conclusion
This project shows how SQL and Tableau can be used together to discover patterns across large real-world datasets. When exploring the NYC housing market, we see how Manhattan and Brooklyn dominate in pricing while affordability and sales activity differ across boroughs. Complaint numbers are more evenly distributed across the city. However, when the two datasets are combined, the results show that housing prices do not correlate with complaint severity. The Bronx stands out for having a high number of complaints, which may be influenced by population density, housing conditions, or higher reporting volume.  

The final dashboards summarize these patterns and provide a foundation for deeper analysis such as potential demographic or neighborhood-level insights in future work.