CREATE TABLE dbo.DimCountry (
    CountryId INT IDENTITY(1,1) PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO dbo.DimCountry (CountryName)
SELECT CountryName
FROM (
    SELECT DISTINCT origin_country AS CountryName FROM dbo.DiasporaPopulationByCountry
    UNION
    SELECT DISTINCT destination_country FROM dbo.DiasporaPopulationByCountry
    UNION
    SELECT DISTINCT origin_country FROM dbo.MigrationCorridors
    UNION
    SELECT DISTINCT destination_country FROM dbo.MigrationCorridors
) AS AllCountries
EXCEPT
SELECT CountryName FROM dbo.DimCountry;

SELECT * FROM dbo.DimCountry ORDER BY CountryName;

/*Join Dim table with DiasporaPopulationByCountry table*/
SELECT 
DiasporaPopulationByCountry.origin_country,
DimCountry.CountryId
FROM DBO.DiasporaPopulationByCountry
INNER JOIN DBO.DimCountry
ON DiasporaPopulationByCountry.origin_country=DimCountry.CountryName;

/*Join Migration Stocks, Corridors and Remittances*/

