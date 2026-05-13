--Dadabase creation--

CREATE DATABASE SupplyChainRiskDB;
GO

USE SupplyChainRiskDB;
GO

USE SupplyChainRiskDB;
GO

--Table creation--

CREATE TABLE dbo.Global_Supply_Chain_Risk (
    Shipment_ID INT,
    Date DATE,
    Origin_Port VARCHAR(100),
    Destination_Port VARCHAR(100),
    Transport_Mode VARCHAR(50),
    Product_Category VARCHAR(100),
    Distance_km FLOAT,
    Weight_MT FLOAT,
    Fuel_Price_Index FLOAT,
    Geopolitical_Risk_Score FLOAT,
    Weather_Condition VARCHAR(50),
    Carrier_Reliability_Score FLOAT,
    Lead_Time_Days INT,
    Disruption_Occurred INT
);