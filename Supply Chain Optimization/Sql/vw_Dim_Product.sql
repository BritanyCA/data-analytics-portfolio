CREATE VIEW vw_Dim_Product AS
SELECT DISTINCT
    Product_Category
FROM vw_Fact_SupplyChainRisk
WHERE Product_Category IS NOT NULL;