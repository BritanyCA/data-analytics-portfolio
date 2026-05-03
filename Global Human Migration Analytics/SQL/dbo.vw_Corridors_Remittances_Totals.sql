CREATE VIEW dbo.vw_Corridors_Remittances_Totals AS
SELECT 
    mc.origin_country,
    mc.destination_country,
    mc.year,
    mc.migrant_stock,
    r.remittances_usd_billion,
    m.Pakistan_total_emigrants,
    m.India_total_emigrants,
    m.Bangladesh_total_emigrants,
    m.Sri_Lanka_total_emigrants,
    m.Nepal_total_emigrants
FROM dbo.MigrationCorridors mc
LEFT JOIN dbo.RemittancesSouthAsia r
    ON mc.year = r.year
    AND mc.origin_country = r.country
LEFT JOIN dbo.MigrationStockTotals m
    ON mc.year = m.year;
