
USE CampusEventDesk_Opdracht3;
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO

SELECT
    'Organisatie' AS tabel,
    COUNT(*) AS aantalRecords
FROM dbo.Organisatie

UNION ALL

SELECT
    'Persoon',
    COUNT(*)
FROM dbo.Persoon

UNION ALL

SELECT
    'Activiteit',
    COUNT(*)
FROM dbo.Activiteit

UNION ALL

SELECT
    'Aanmelding',
    COUNT(*)
FROM dbo.Aanmelding

UNION ALL

SELECT
    'Betaling',
    COUNT(*)
FROM dbo.Betaling;
GO

SELECT
    t.name AS tabel,
    SUM(p.rows) AS aantalRecords
FROM sys.tables AS t
INNER JOIN sys.partitions AS p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY t.name;
GO
