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
