USE SupplyChainRiskDB;
GO

--Count of records--
SELECT COUNT(*) AS Total_Registros
FROM dbo.Global_Supply_Chain_Risk_2026;

--Count of Null Values--
SELECT 
    SUM(CASE WHEN Shipment_ID IS NULL THEN 1 ELSE 0 END) AS Null_Shipment_ID,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
    SUM(CASE WHEN Origin_Port IS NULL THEN 1 ELSE 0 END) AS Null_Origin_Port,
    SUM(CASE WHEN Destination_Port IS NULL THEN 1 ELSE 0 END) AS Null_Destination_Port,
    SUM(CASE WHEN Transport_Mode IS NULL THEN 1 ELSE 0 END) AS Null_Transport_Mode,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS Null_Product_Category,
    SUM(CASE WHEN Distance_km IS NULL THEN 1 ELSE 0 END) AS Null_Distance_km,
    SUM(CASE WHEN Weight_MT IS NULL THEN 1 ELSE 0 END) AS Null_Weight_MT,
    SUM(CASE WHEN Fuel_Price_Index IS NULL THEN 1 ELSE 0 END) AS Null_Fuel_Price_Index,
    SUM(CASE WHEN Geopolitical_Risk_Score IS NULL THEN 1 ELSE 0 END) AS Null_Geopolitical_Risk_Score,
    SUM(CASE WHEN Carrier_Reliability_Score IS NULL THEN 1 ELSE 0 END) AS Null_Carrier_Reliability_Score,
    SUM(CASE WHEN Lead_Time_Days IS NULL THEN 1 ELSE 0 END) AS Null_Lead_Time_Days,
    SUM(CASE WHEN Disruption_Occurred IS NULL THEN 1 ELSE 0 END) AS Null_Disruption_Occurred
FROM dbo.Global_Supply_Chain_Risk_2026;

--Unique Values per Columns--
SELECT DISTINCT Origin_Port FROM dbo.Global_Supply_Chain_Risk_2026;
SELECT DISTINCT Destination_Port FROM dbo.Global_Supply_Chain_Risk_2026;
SELECT DISTINCT Transport_Mode FROM dbo.Global_Supply_Chain_Risk_2026;
SELECT DISTINCT Product_Category FROM dbo.Global_Supply_Chain_Risk_2026;

--Descriptive statistical analysis--

    -- Distance_km
SELECT 
    MIN(Distance_km) AS Min_Distance_km,
    MAX(Distance_km) AS Max_Distance_km,
    AVG(Distance_km) AS Avg_Distance_km,
    STDEV(Distance_km) AS Std_Distance_km
FROM dbo.Global_Supply_Chain_Risk_2026;

    -- Weight_MT
 SELECT
    MIN(Weight_MT) AS Min_Weight_MT,
    MAX(Weight_MT) AS Max_Weight_MT,
    AVG(Weight_MT) AS Avg_Weight_MT,
    STDEV(Weight_MT) AS Std_Weight_MT
FROM dbo.Global_Supply_Chain_Risk_2026;

    -- Fuel_Price_Index
SELECT
    MIN(Fuel_Price_Index) AS Min_FuelPrice,
    MAX(Fuel_Price_Index) AS Max_FuelPrice,
    AVG(Fuel_Price_Index) AS Avg_FuelPrice,
    STDEV(Fuel_Price_Index) AS Std_FuelPrice
FROM dbo.Global_Supply_Chain_Risk_2026;

    -- Geopolitical_Risk_Score
SELECT
    MIN(Geopolitical_Risk_Score) AS Min_GeoRisk,
    MAX(Geopolitical_Risk_Score) AS Max_GeoRisk,
    AVG(Geopolitical_Risk_Score) AS Avg_GeoRisk,
    STDEV(Geopolitical_Risk_Score) AS Std_GeoRisk
FROM dbo.Global_Supply_Chain_Risk_2026;

    -- Carrier_Reliability_Score
SELECT
    MIN(Carrier_Reliability_Score) AS Min_CarrierReliability,
    MAX(Carrier_Reliability_Score) AS Max_CarrierReliability,
    AVG(Carrier_Reliability_Score) AS Avg_CarrierReliability,
    STDEV(Carrier_Reliability_Score) AS Std_CarrierReliability
FROM dbo.Global_Supply_Chain_Risk_2026;

    -- Lead_Time_Days
SELECT
    MIN(Lead_Time_Days) AS Min_LeadTime,
    MAX(Lead_Time_Days) AS Max_LeadTime,
    AVG(Lead_Time_Days) AS Avg_LeadTime,
    STDEV(Lead_Time_Days) AS Std_LeadTime
FROM dbo.Global_Supply_Chain_Risk_2026;

    -- Disruption_Occurrences
SELECT
    MIN(Disruption_Occurred) AS Min_Disruptions,
    MAX(Disruption_Occurred) AS Max_Disruptions,
    AVG(Disruption_Occurred) AS Avg_Disruptions,
    STDEV(Disruption_Occurred) AS Std_Disruptions
FROM dbo.Global_Supply_Chain_Risk_2026;

--Disruption Distribution
SELECT 
    Disruption_Occurred,
    COUNT(*) AS Total
FROM dbo.Global_Supply_Chain_Risk_2026
GROUP BY Disruption_Occurred;

--Business Rules

--Suspicious Distances
SELECT *
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE Distance_km < 10 OR Distance_km > 20000;

--Suspicious LeadTime
SELECT *
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE Lead_Time_Days < 1 OR Lead_Time_Days > 120;

--Relation between disruptions and transport mode
SELECT 
    Transport_Mode,
    AVG(CAST(Disruption_Occurred AS FLOAT)) AS Disruption_Rate
FROM dbo.Global_Supply_Chain_Risk_2026
GROUP BY Transport_Mode
ORDER BY Disruption_Rate DESC;


--Average Lead Time per product category
SELECT 
    Product_Category,
    AVG(Lead_Time_Days) AS Avg_LeadTime
FROM dbo.Global_Supply_Chain_Risk_2026
GROUP BY Product_Category
ORDER BY Avg_LeadTime DESC;




