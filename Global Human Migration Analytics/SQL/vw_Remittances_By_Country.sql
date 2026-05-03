CREATE VIEW dbo.vw_Remittances_By_Country AS
SELECT 
    country,
    year,
    remittances_usd_billion,
    remittance_pct_gdp
FROM dbo.RemittancesSouthAsia;
