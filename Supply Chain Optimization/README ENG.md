# 📊 Global Supply Chain Risk Analytics
SQL + Power BI | Portfolio Project
Author: Britany Campos • Tools: SQL Server, Power BI, DAX

## 📌 Project Description
This project delivers a complete end‑to‑end analytical solution for evaluating global supply chain risk.
It begins with SQL-based data preparation, including cleaning, transformation, creation of analytical views, and correlation analysis.
The processed data is then modeled in Power BI using a professional star schema, followed by the development of a 4‑page dashboard that analyzes disruptions, transport modes, product vulnerabilities, operational factors, and predictive indicators.

## 🎯 Objectives
### SQL Objectives
- Clean and standardize raw logistics data
- Build analytical views for Power BI
- Create a calendar table for time intelligence
- Calculate correlations to identify risk drivers
- Prepare route, product, and operational metrics

### Power BI Objectives
- Build a star schema model
- Create DAX measures for risk, lead time, and disruptions
- Visualize risk across routes, products, and time
- Identify high‑risk shipments and predictive patterns


## 🗂 Data Engineering (SQL)
### 1. Data Cleaning & Standardization
The raw tables were cleaned using SQL to ensure consistent formats:
- Standardized date formats
- Normalized port names
- Converted categorical fields
- Removed duplicates
- Validated numeric ranges (lead time, distance, risk scores)


### 2. Analytical Views for Power BI
To avoid loading raw tables into Power BI, clean SQL views were created.

**Main Fact View**
```sql
CREATE VIEW dbo.vw_Fact_SupplyChainRisk AS
SELECT
    Shipment_ID,
    Date,
    Origin_Port,
    Destination_Port,
    Transport_Mode,
    Product_Category,
    Distance_km,
    Weight_MT,
    Fuel_Price_Index,
    Geopolitical_Risk_Score,
    Carrier_Reliability_Score,
    Lead_Time_Days,
    Disruption_Occurred,
    Composite_Risk_Score,
    Lead_Time_Category,
    Distance_Category,
    Month,
    Quarter,
    High_Risk_Route,
    Fuel_Cost_Impact,
    Weight_Distance_Interaction
FROM dbo.Global_Supply_Chain_Risk_FE;
```
**Dimensional Views**
```sql
CREATE VIEW dbo.vw_Dim_OriginPort AS
SELECT DISTINCT
    Origin_Port AS Port_Name
FROM dbo.Global_Supply_Chain_Risk_FE;
```
```sql
CREATE VIEW vw_Dim_Port AS
SELECT DISTINCT Origin_Port AS Port_Name
FROM vw_Fact_SupplyChainRisk
WHERE Origin_Port IS NOT NULL

UNION

SELECT DISTINCT Destination_Port
FROM vw_Fact_SupplyChainRisk
WHERE Destination_Port IS NOT NULL;
```

### 3. Correlation Analysis (Feature Importance Base)
To understand which variables drive disruptions, correlations were calculated in SQL:

```sql
--Key correlations CTE
WITH Stats AS (
    SELECT
        AVG(Distance_km) AS Avg_Distance,
        AVG(Lead_Time_Days) AS Avg_LeadTime,
        AVG(Fuel_Price_Index) AS Avg_Fuel,
        AVG(Geopolitical_Risk_Score) AS Avg_GeoRisk,
        AVG(Carrier_Reliability_Score) AS Avg_Carrier,
        AVG(Disruption_Occurred) AS Avg_Y
    FROM dbo.Global_Supply_Chain_Risk_Model
),
Base AS (
    SELECT
        Distance_km, Lead_Time_Days, Fuel_Price_Index,
        Geopolitical_Risk_Score, Carrier_Reliability_Score,
        Disruption_Occurred AS Y
    FROM dbo.Global_Supply_Chain_Risk_Model
)
SELECT * FROM (
    SELECT 
        'Distance_km' AS Variable,
        SUM((Distance_km - s.Avg_Distance) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Distance_km - s.Avg_Distance, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        ) AS Correlation
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Lead_Time_Days',
        SUM((Lead_Time_Days - s.Avg_LeadTime) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Lead_Time_Days - s.Avg_LeadTime, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Fuel_Price_Index',
        SUM((Fuel_Price_Index - s.Avg_Fuel) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Fuel_Price_Index - s.Avg_Fuel, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Geopolitical_Risk_Score',
        SUM((Geopolitical_Risk_Score - s.Avg_GeoRisk) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Geopolitical_Risk_Score - s.Avg_GeoRisk, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s

    UNION ALL
    SELECT 
        'Carrier_Reliability_Score',
        SUM((Carrier_Reliability_Score - s.Avg_Carrier) * (Y - s.Avg_Y)) /
        SQRT(
            SUM(POWER(Carrier_Reliability_Score - s.Avg_Carrier, 2)) *
            SUM(POWER(Y - s.Avg_Y, 2))
        )
    FROM Base, Stats s
) AS t
ORDER BY ABS(Correlation) DESC;
```

## 🧩 Data Modeling (Power BI)
Star Schema
**Fact Table: vw_Fact_SupplyChainRisk**

Dimensions:

- vw_Dim_Product
- vw_Dim_OriginPort
- vw_Dim_DestinationPort
- vw_Calendar

Relationships were kept single-direction, avoiding ambiguity and ensuring clean DAX behavior.

### 📐 Main DAX Measures
#### 1. Actual Disruption
```DAX
Actual Disruption =
AVERAGE ( vw_Fact_SupplyChainRisk[Disruption_Occurred] )
```
#### 2. Average Lead Time
``` DAX
Avg Lead Time =
AVERAGE ( vw_Fact_SupplyChainRisk[Lead_Time_Days] )
```
#### 3. Composite Risk Score (Avg)
```DAX
Avg Risk Score =
AVERAGE ( vw_Fact_SupplyChainRisk[Composite_Risk_Score] )
```
#### 4. Predicted Disruption
```DAX
Predicted_Disruption = 
DIVIDE(
    AVERAGE(vw_Fact_SupplyChainRisk[Composite_Risk_Score]),
    100
) 
```
#### 5. Route Label
```DAX
Route =
vw_Fact_SupplyChainRisk[Origin_Port] & " → " &
vw_Fact_SupplyChainRisk[Destination_Port]
```
## 🗂 Dashboard Structure
### Page 1 — Executive Overview
- KPIs
- Disruption trend
- Risk by transport mode
- Port disruption matrix

### Page 2 — Route & Transport Risk
- Top 10 high‑risk routes
- Mode comparison
- Distance vs lead time
- Route map

### Page 3 — Product & Operational Risk
- Disruption by product
- Lead time by product
- Geopolitical trend
- Carrier reliability vs disruption

### Page 4 — Predictive Insights
- Feature importance (from SQL correlations)
- Risk score distribution
- Predicted vs actual disruption
- High‑risk shipments

## 🧠 Key Insights
1. Lead time and geopolitical risk are the strongest predictors of disruption
These two variables dominate the correlation analysis and the predictive model.

2. Maritime routes and long‑distance shipments show the highest risk
Sea transport consistently ranks as the most vulnerable mode.

3. Textiles and pharmaceuticals are the most disruption‑prone categories
They show the highest disruption rates and longest lead times.

## 🧾 General Conclusion
This project demonstrates a complete SQL + Power BI pipeline for global supply chain risk analytics.

- SQL was used to clean, transform, model, and analyze the data.
- Power BI was used to visualize, explore, and interpret the risk patterns.
- The combination of both tools enabled a predictive, data‑driven understanding of disruptions.

The result is a robust analytical solution that transforms raw logistics data into actionable intelligence, helping organizations anticipate disruptions, optimize routing strategies, and build a more resilient supply chain.