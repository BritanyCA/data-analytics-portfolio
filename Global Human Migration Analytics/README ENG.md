# 📊 Global Migration, Remittances & Labor Mobility Dashboard
Power BI | Portfolio Project
Analyzing global migration flows, diaspora distribution, labor migration from Pakistan, and the economic impact of remittances.

Author: Britany Campos • Tools: Power BI, SQL

## 🚀 Project Overview
This project explores how migration patterns shape economic outcomes across South Asia.
Using SQL, Power BI, and a star‑schema data model, the dashboard provides insights into:

- Migration corridors
- Diaspora distribution
- Labor migration dynamics
- Remittances and their macroeconomic impact

The goal is to understand how people move, where they go, and how their financial contributions affect home economies.

## 🛠️ Tech Stack
- **SQL Server** — Data cleaning, joins, CTEs, and creation of analytical views
- **Power BI** — Data modeling, DAX measures, and dashboard design
- **DAX** — Time intelligence, YoY calculations, moving averages
- **Star Schema** — Calendar dimension + fact views

## 📐 Data Model
The model follows a star schema:

- Calendar (dimension)
- vw_Diaspora_By_Country
- vw_Migration_Corridors
- vw_Remittances_By_Country
- vw_Pakistan_Emigration
- vw_Pakistan_Migration

All fact tables connect to **Calendar[Year]** to enable time intelligence.
## 🔍 Key Insights
1. India dominates global remittance inflows.
India consistently leads all South Asian countries, reflecting a large overseas workforce and strong economic ties with high‑income host nations.

2. Remittances show a resilient long‑term upward trend.
Even during global disruptions, remittances continue to grow, proving they are a stable and counter‑cyclical financial flow.

3. Migration and remittances move together.
Higher migration volumes correlate with higher remittances, confirming that labor mobility is a structural driver of economic inflows.
## 📈 DAX Highlights
#### 🔸Total Remittances
Calculates the total amount of remittances received across all countries and years.
It is the main financial indicator of diaspora contribu
``` DAX
Total Remittances =
SUM(vw_Remittances_By_Country[remittances_usd_billion])
```

#### 🔸Total Migrants
Counts the total number of workers who emigrated from Pakistan.
Used to analyze labor mobility and migration trends.
``` DAX
Total Migrants =
SUM(vw_Pakistan_Emigration[workers_emigrated])

```

#### 🔸YoY Growth
Measures how much remittances increased or decreased compared to the previous year.
Helps identify acceleration or slowdown in financial inflows.
``` DAX
Remittances YoY =
VAR CurrentYear = [Total Remittances]
VAR PreviousYear =
    CALCULATE([Total Remittances], DATEADD(Calendar[Date], -1, YEAR))
RETURN
CurrentYear - PreviousYear
```

#### 🔸Moving Average (3Y)
Smooths short‑term fluctuations by averaging remittances over the last 3 years.
Useful for identifying long‑term trends.
``` DAX
Remittances Moving Avg 3Y =
AVERAGEX(
    DATESINPERIOD(Calendar[Date], MAX(Calendar[Date]), -3, YEAR),
    [Total Remittances]
)
```
#### 🔸Skilled vs Unskilled %
Shows the proportion of skilled and unskilled workers among all migrants.
Helps understand the labor profile and earning potential of the migrant workforce.
``` DAX
Skilled % =
DIVIDE([Skilled Workers], [Total Migrants])

Unskilled % =
DIVIDE([Unskilled Workers], [Total Migrants])
```
#### 🔸Remittances per Migrant

``` DAX
Remittances per Migrant =
DIVIDE([Total Remittances], [Total Migrants])
```

## 🎯 Purpose of the Project
This dashboard is designed for:

- Policy analysis
- Economic research
- Migration studies
- Portfolio demonstration
- Data storytelling

It showcases advanced BI skills: modeling, DAX, visualization, and analytical storytelling.

# ⭐ Conclusion 
Migration and remittances form a tightly connected economic system.  
The data shows that remittances grow steadily over time, driven by sustained labor migration—especially from Pakistan and India. Migration corridors reveal how specific routes shape economic flows, while remittances remain a stable source of income even during global uncertainty. Overall, the project demonstrates that human mobility is not only a demographic trend but a key economic engine for South Asian countries.
