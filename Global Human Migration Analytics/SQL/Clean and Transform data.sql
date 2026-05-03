SELECT 'Diaspora' AS TableName, COUNT(*) AS TotalRows FROM dbo.DiasporaPopulationByCountry
UNION ALL
SELECT 'Corridors', COUNT(*) FROM dbo.MigrationCorridors
UNION ALL
SELECT 'StockTotals', COUNT(*) FROM dbo.MigrationStockTotals
UNION ALL
SELECT 'PakistanEmigration', COUNT(*) FROM dbo.PakistanAnnualEmigration
UNION ALL
SELECT 'Remittances', COUNT(*) FROM dbo.RemittancesSouthAsia;

SELECT TOP 5 * FROM dbo.MigrationCorridors;
SELECT TOP 5 * FROM dbo.DiasporaPopulationByCountry;
SELECT TOP 5 * FROM dbo.MigrationStockTotals;
SELECT TOP 5 * FROM dbo.RemittancesSouthAsia;
SELECT 
    origin_country, destination_country, year_estimate, migration_type,
    COUNT(*) AS duplicates
FROM dbo.DiasporaPopulationByCountry
GROUP BY origin_country, destination_country, year_estimate, migration_type
HAVING COUNT(*) > 1;

/*Check Data Type*/
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DiasporaPopulationByCountry';

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'MigrationCorridors';

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'MigrationStockTotals';

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PakistanAnnualEmigration';

/*Modify columns*/
ALTER TABLE dbo.PakistanAnnualEmigration
ALTER COLUMN skilled_pct DECIMAL(5,2);
ALTER TABLE dbo.PakistanAnnualEmigration
ALTER COLUMN semi_skilled_pct DECIMAL(5,2);
ALTER TABLE dbo.PakistanAnnualEmigration
ALTER COLUMN unskilled_pct DECIMAL(5,2);


SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RemittancesSouthAsia';

/*Modify columns*/
ALTER TABLE dbo.RemittancesSouthAsia
ALTER COLUMN remittances_usd_billion VARCHAR(MAX);

ALTER TABLE dbo.RemittancesSouthAsia
ALTER COLUMN remittance_pct_gdp VARCHAR (MAX);

SELECT remittances_usd_billion
FROM dbo.RemittancesSouthAsia
WHERE TRY_CONVERT(DECIMAL(10,2), remittances_usd_billion) IS NULL
  AND remittances_usd_billion IS NOT NULL;


  SELECT remittance_pct_gdp
FROM dbo.RemittancesSouthAsia
WHERE TRY_CONVERT(DECIMAL(10,2), remittance_pct_gdp) IS NULL
  AND remittance_pct_gdp IS NOT NULL;

  ALTER TABLE dbo.RemittancesSouthAsia
ALTER COLUMN remittances_usd_billion DECIMAL(10,2);

ALTER TABLE dbo.RemittancesSouthAsia
ALTER COLUMN remittance_pct_gdp DECIMAL(5,2);


/* Check duplicates*/

SELECT origin_country, destination_country, year_estimate, migration_type, COUNT(*) AS duplicates
FROM dbo.DiasporaPopulationByCountry
GROUP BY origin_country, destination_country, year_estimate, migration_type
HAVING COUNT(*) > 1;

SELECT origin_country, destination_country, year, COUNT(*) AS duplicates
FROM dbo.MigrationCorridors
GROUP BY origin_country, destination_country, year
HAVING COUNT(*) > 1;

SELECT year, country, COUNT(*) AS duplicates
FROM dbo.RemittancesSouthAsia
GROUP BY year, country
HAVING COUNT(*) > 1;


