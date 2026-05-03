CREATE VIEW dbo.vw_Pakistan_Migration_Remittances AS
SELECT 
    p.year,
    p.workers_emigrated,
    p.skilled_workers,
    p.unskilled_workers,
    r.remittances_usd_billion,
    r.remittance_pct_gdp
FROM dbo.PakistanAnnualEmigration p
LEFT JOIN dbo.RemittancesSouthAsia r
    ON p.year = r.year
    AND r.country = 'Pakistan'
    ;
