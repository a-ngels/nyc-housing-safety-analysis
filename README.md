# NYC Housing & Crime Analysis
Insights into the relationship between NYC housing activity and NYPD complaint patterns.

## Project Overview
This project combines NYC housing sales and NYPD complaint data to uncover how market trends align with public safety patterns across boroughs. SQL was used for data cleaning and analysis and Tableau was used to build interactive visualizations and dashboards. The analysis highlights differences in pricing, sales activity, and complaint levels across NYC from 2016–2024.

## Data Sources

### NYC Citywide Annualized Calendar Sales
- Downloaded: Oct 22, 2025
- Row count at download: ~761k
- Current row count (as of Nov 25, 2025): ~761k
- Source: [NYC Citywide Annualized Calendar Sales](https://data.cityofnewyork.us/City-Government/NYC-Citywide-Annualized-Calendar-Sales-Update/w2pb-icbu/about_data)

### NYPD Complaint Data Current (Year To Date)
- Downloaded: Oct 22, 2025
- Row count at downloaded: ~288k
- Current row count (as of Nov 25, 2025): ~439k
- Source: [NYPD Complaint Data](https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Current-Year-To-Date-/5uac-w243/about_data)

## Data Cleaning & Preparation

### Housing Sales
- Loaded raw NYC property sales data into the `nyc_property_sales` table
- Converted text based numeric fields (sale price, square footage, unit counts) into numeric data types
- Removed commas and dollar signs before casting
- Dropped original text columns to avoid redundancy
- Standardized date formatting by converting sale_date from text into date type
- Added a primary key for indexing and to ensure row uniqueness
- [SQL Cleaning File](./sql/sales_cleaning.sql)

### NYPD Complaints
- Loaded raw NYPD complaint data into the `nypd_complaints` table
- Replaced text `'(null)'` values with actual SQL NULLs across multiple text fields
- Converted text time fields into proper time type
- Added a primary key for indexing and to ensure row uniqueness
- [SQL Cleaning File](./sql/complaint_cleaning.sql)

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

## SQL Analysis Overview
