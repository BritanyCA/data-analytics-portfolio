SELECT TOP (1000) [Shipment_ID]
      ,[Date]
      ,[Origin_Port]
      ,[Destination_Port]
      ,[Transport_Mode]
      ,[Product_Category]
      ,[Distance_km]
      ,[Weight_MT]
      ,[Fuel_Price_Index]
      ,[Geopolitical_Risk_Score]
      ,[Weather_Condition]
      ,[Carrier_Reliability_Score]
      ,[Lead_Time_Days]
      ,[Disruption_Occurred]
  FROM [SupplyChainRiskDB].[dbo].[global_supply_chain_risk]

  EXEC sp_help 'dbo.Global_Supply_Chain_Risk_2026';
  EXEC sp_rename 'dbo.Global_Supply_Chain_Risk', 'Global_Supply_Chain_Risk_2026';

  SELECT Distance_km
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Distance_km) IS NULL AND Distance_km IS NOT NULL;
SELECT Weight_MT
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Weight_MT) IS NULL AND Weight_MT IS NOT NULL;

SELECT Fuel_Price
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Fuel_Price) IS NULL AND Fuel_Price IS NOT NULL;

SELECT Geopolitical_Risk_Score
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Geopolitical_Risk_Score) IS NULL AND Geopolitical_Risk_Score IS NOT NULL;

SELECT Carrier_Reliability_Score
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Carrier_Reliability_Score) IS NULL AND Carrier_Reliability_Score IS NOT NULL;

SELECT Lead_Time_Days
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Lead_Time_Days) IS NULL AND Lead_Time_Days IS NOT NULL;

SELECT Disruption_Occurred
FROM dbo.Global_Supply_Chain_Risk_2026
WHERE TRY_CONVERT(float, Disruption_Occurred) IS NULL AND Disruption_Occurred IS NOT NULL;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Distance_km FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Weight_MT FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Fuel_Price_Index FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Geopolitical_Risk_Score FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Carrier_Reliability_Score FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Lead_Time_Days FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Disruption_Occurred FLOAT;

ALTER TABLE dbo.Global_Supply_Chain_Risk_2026
ALTER COLUMN Date DATE;
