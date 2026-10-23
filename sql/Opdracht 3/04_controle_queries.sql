USE CampusEventDesk_Opdracht3;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.Activiteit) AS activiteiten,
    (SELECT COUNT(*) FROM dbo.Persoon) AS personen,
    (SELECT COUNT(*) FROM dbo.Aanmelding) AS aanmeldpogingen,
    (SELECT COUNT(*) FROM dbo.Betaling) AS betalingen,
    CASE
        WHEN (SELECT COUNT(*) FROM dbo.Activiteit) = 6
         AND (SELECT COUNT(*) FROM dbo.Persoon) = 6
         AND (SELECT COUNT(*) FROM dbo.Aanmelding) = 18
         AND (SELECT COUNT(*) FROM dbo.Betaling) = 11
        THEN 'PASS' ELSE 'FAIL'
    END AS resultaat;
GO

SELECT
    SUM(CASE WHEN aantal > 0 THEN 1 ELSE 0 END) AS aantalGevuldeRelaties,
    SUM(aantal) AS totaalRecords,
    CASE
        WHEN SUM(CASE WHEN aantal > 0 THEN 1 ELSE 0 END) >= 5
         AND SUM(aantal) >= 20
        THEN 'PASS' ELSE 'FAIL'
    END AS resultaat
FROM (
    SELECT 'Organisatie' AS relatie, COUNT(*) AS aantal FROM dbo.Organisatie
    UNION ALL SELECT 'Locatie', COUNT(*) FROM dbo.Locatie
    UNION ALL SELECT 'Categorie', COUNT(*) FROM dbo.Categorie
    UNION ALL SELECT 'Activiteitsvorm', COUNT(*) FROM dbo.Activiteitsvorm
    UNION ALL SELECT 'Tag', COUNT(*) FROM dbo.Tag
    UNION ALL SELECT 'DeelnameVorm', COUNT(*) FROM dbo.DeelnameVorm
    UNION ALL SELECT 'Persoon', COUNT(*) FROM dbo.Persoon
    UNION ALL SELECT 'Activiteit', COUNT(*) FROM dbo.Activiteit
    UNION ALL SELECT 'ActiviteitMoment', COUNT(*) FROM dbo.ActiviteitMoment
    UNION ALL SELECT 'ContactKanaal', COUNT(*) FROM dbo.ContactKanaal
    UNION ALL SELECT 'ActiviteitCategorie', COUNT(*) FROM dbo.ActiviteitCategorie
    UNION ALL SELECT 'ActiviteitTag', COUNT(*) FROM dbo.ActiviteitTag
    UNION ALL SELECT 'ActiviteitPublicatie', COUNT(*) FROM dbo.ActiviteitPublicatie
    UNION ALL SELECT 'ActiviteitOrganisatie', COUNT(*) FROM dbo.ActiviteitOrganisatie
    UNION ALL SELECT 'ActiviteitVoorwaarde', COUNT(*) FROM dbo.ActiviteitVoorwaarde
    UNION ALL SELECT 'Aanmelding', COUNT(*) FROM dbo.Aanmelding
    UNION ALL SELECT 'Betaling', COUNT(*) FROM dbo.Betaling
) AS T;
GO

SELECT
    A.activiteitId,
    A.code,
    A.titel,
    A.publicatieStatus
FROM dbo.Activiteit AS A
LEFT JOIN dbo.Aanmelding AS AM
    ON A.activiteitId = AM.activiteitId
WHERE AM.aanmeldingId IS NULL
ORDER BY A.activiteitId;

SELECT CASE
    WHEN (SELECT COUNT(*) FROM dbo.Activiteit AS A
          WHERE NOT EXISTS (SELECT 1 FROM dbo.Aanmelding AS AM
                            WHERE AM.activiteitId = A.activiteitId)) = 1
     AND NOT EXISTS (SELECT 1 FROM dbo.Aanmelding WHERE activiteitId = 'A05')
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    AM.aanmeldingId,
    AM.status,
    AM.activiteitId,
    AM.persoonId
FROM dbo.Aanmelding AS AM
LEFT JOIN dbo.Betaling AS B
    ON AM.aanmeldingId = B.aanmeldingId
WHERE B.betalingId IS NULL
ORDER BY AM.aanmeldingId;

SELECT CASE
    WHEN (SELECT COUNT(*) FROM dbo.Aanmelding AS AM
          WHERE NOT EXISTS (SELECT 1 FROM dbo.Betaling AS B
                            WHERE B.aanmeldingId = AM.aanmeldingId)) = 7
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    O.activiteitId AS oorspronkelijkeActiviteitId,
    O.code AS oorspronkelijkeCode,
    V.activiteitId AS vervolgActiviteitId,
    V.code AS vervolgCode
FROM dbo.Activiteit AS O
INNER JOIN dbo.Activiteit AS V
    ON O.vervolgActiviteitId = V.activiteitId
ORDER BY O.activiteitId;

SELECT
    AV.activiteitId,
    AV.voorwaardeActiviteitId
FROM dbo.ActiviteitVoorwaarde AS AV
ORDER BY AV.activiteitId;

SELECT CASE
    WHEN EXISTS (
        SELECT 1 FROM dbo.Activiteit
        WHERE activiteitId = 'A01' AND vervolgActiviteitId = 'A06'
    )
    AND EXISTS (
        SELECT 1 FROM dbo.ActiviteitVoorwaarde
        WHERE activiteitId = 'A06' AND voorwaardeActiviteitId = 'A01'
    )
    AND (SELECT COUNT(*) FROM dbo.Activiteit WHERE vervolgActiviteitId IS NOT NULL) = 1
    AND (SELECT COUNT(*) FROM dbo.ActiviteitVoorwaarde) = 1
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    AM.persoonId,
    AM.activiteitId,
    COUNT(*) AS aantalPogingen
FROM dbo.Aanmelding AS AM
GROUP BY AM.persoonId, AM.activiteitId
HAVING COUNT(*) > 1
ORDER BY AM.persoonId, AM.activiteitId;

SELECT CASE
    WHEN EXISTS (
        SELECT 1 FROM dbo.Aanmelding
        WHERE persoonId = 'P001' AND activiteitId = 'A01'
        GROUP BY persoonId, activiteitId
        HAVING COUNT(*) = 2
           AND SUM(CASE WHEN status = 'geannuleerd' THEN 1 ELSE 0 END) = 1
           AND SUM(CASE WHEN status = 'bevestigd' THEN 1 ELSE 0 END) = 1
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    AM.persoonId,
    AM.activiteitId,
    COUNT(*) AS aantalActief
FROM dbo.Aanmelding AS AM
WHERE AM.status IN ('wachtlijst', 'betaling_in_afwachting', 'bevestigd')
GROUP BY AM.persoonId, AM.activiteitId
HAVING COUNT(*) > 1;

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM dbo.Aanmelding
        WHERE status IN ('wachtlijst', 'betaling_in_afwachting', 'bevestigd')
        GROUP BY persoonId, activiteitId
        HAVING COUNT(*) > 1
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    AM.aanmeldingId,
    AM.persoonId,
    AM.activiteitId,
    AM.deelnamevormId
FROM dbo.Aanmelding AS AM
LEFT JOIN dbo.Persoon AS P
    ON AM.persoonId = P.persoonId
LEFT JOIN dbo.Activiteit AS A
    ON AM.activiteitId = A.activiteitId
LEFT JOIN dbo.DeelnameVorm AS DV
    ON AM.deelnamevormId = DV.deelnamevormId
WHERE P.persoonId IS NULL
   OR A.activiteitId IS NULL
   OR DV.deelnamevormId IS NULL;

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM dbo.Aanmelding AS AM
        LEFT JOIN dbo.Persoon AS P ON AM.persoonId = P.persoonId
        LEFT JOIN dbo.Activiteit AS A ON AM.activiteitId = A.activiteitId
        LEFT JOIN dbo.DeelnameVorm AS DV ON AM.deelnamevormId = DV.deelnamevormId
        WHERE P.persoonId IS NULL OR A.activiteitId IS NULL OR DV.deelnamevormId IS NULL
    )
     AND NOT EXISTS (
        SELECT 1
        FROM dbo.Betaling AS B
        LEFT JOIN dbo.Aanmelding AS AM ON B.aanmeldingId = AM.aanmeldingId
        WHERE AM.aanmeldingId IS NULL
    )
     AND NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys
        WHERE parent_object_id IN (SELECT object_id FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo'))
          AND (is_disabled = 1 OR is_not_trusted = 1)
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    A.activiteitId,
    A.code,
    A.titel,
    COUNT(AM.aanmeldingId) AS aantalAanmeldpogingen
FROM dbo.Activiteit AS A
LEFT JOIN dbo.Aanmelding AS AM
    ON A.activiteitId = AM.activiteitId
GROUP BY A.activiteitId, A.code, A.titel
ORDER BY A.activiteitId;

WITH Verwacht AS (
    SELECT V.activiteitId, V.aantal
    FROM (VALUES
        ('A01', 5), ('A02', 5), ('A03', 3),
        ('A04', 4), ('A05', 0), ('A06', 1)
    ) AS V(activiteitId, aantal)
), Werkelijk AS (
    SELECT A.activiteitId, COUNT(AM.aanmeldingId) AS aantal
    FROM dbo.Activiteit AS A
    LEFT JOIN dbo.Aanmelding AS AM ON A.activiteitId = AM.activiteitId
    GROUP BY A.activiteitId
)
SELECT CASE
    WHEN NOT EXISTS (
        SELECT activiteitId, aantal FROM Verwacht
        EXCEPT
        SELECT activiteitId, aantal FROM Werkelijk
    )
    AND NOT EXISTS (
        SELECT activiteitId, aantal FROM Werkelijk
        EXCEPT
        SELECT activiteitId, aantal FROM Verwacht
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    A.activiteitId,
    A.code,
    A.titel
FROM dbo.Activiteit AS A
LEFT JOIN dbo.ActiviteitMoment AS M
    ON A.activiteitId = M.activiteitId
WHERE A.publicatieStatus = 'gepubliceerd'
GROUP BY A.activiteitId, A.code, A.titel
HAVING COUNT(M.momentId) = 0;

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM dbo.Activiteit AS A
        WHERE A.publicatieStatus = 'gepubliceerd'
          AND NOT EXISTS (SELECT 1 FROM dbo.ActiviteitMoment AS M
                          WHERE M.activiteitId = A.activiteitId)
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    A.activiteitId,
    A.code,
    A.titel
FROM dbo.Activiteit AS A
LEFT JOIN dbo.ActiviteitCategorie AS AC
    ON A.activiteitId = AC.activiteitId
GROUP BY A.activiteitId, A.code, A.titel
HAVING COUNT(AC.categorieId) = 0;

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1 FROM dbo.Activiteit AS A
        WHERE NOT EXISTS (SELECT 1 FROM dbo.ActiviteitCategorie AS AC
                          WHERE AC.activiteitId = A.activiteitId)
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    AM.aanmeldingId,
    P.persoonId,
    P.naam AS persoonNaam,
    A.activiteitId,
    A.code,
    A.titel,
    AM.aanmelddatum,
    AM.status,
    DV.deelnamevormId,
    DV.naam AS deelnamevormNaam,
    B.betalingId,
    B.betaalstatus
FROM dbo.Aanmelding AS AM
INNER JOIN dbo.Persoon AS P
    ON AM.persoonId = P.persoonId
INNER JOIN dbo.Activiteit AS A
    ON AM.activiteitId = A.activiteitId
INNER JOIN dbo.DeelnameVorm AS DV
    ON AM.deelnamevormId = DV.deelnamevormId
LEFT JOIN dbo.Betaling AS B
    ON AM.aanmeldingId = B.aanmeldingId
ORDER BY AM.aanmeldingId;
GO

SELECT
    A.activiteitId,
    A.code,
    AV.naam AS activiteitsvorm,
    COUNT(DISTINCT CONVERT(date, M.startDatumTijd)) AS verschillendeStartdatums
FROM dbo.Activiteit AS A
INNER JOIN dbo.Activiteitsvorm AS AV
    ON A.activiteitsvormId = AV.activiteitsvormId
LEFT JOIN dbo.ActiviteitMoment AS M
    ON A.activiteitId = M.activiteitId
WHERE A.publicatieStatus = 'gepubliceerd'
  AND AV.naam = N'meerdaagse training'
GROUP BY A.activiteitId, A.code, AV.naam
HAVING COUNT(DISTINCT CONVERT(date, M.startDatumTijd)) < 2;

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM dbo.Activiteit AS A
        INNER JOIN dbo.Activiteitsvorm AS AV
            ON A.activiteitsvormId = AV.activiteitsvormId
        LEFT JOIN dbo.ActiviteitMoment AS M
            ON A.activiteitId = M.activiteitId
        WHERE A.publicatieStatus = 'gepubliceerd'
          AND AV.naam = N'meerdaagse training'
        GROUP BY A.activiteitId
        HAVING COUNT(DISTINCT CONVERT(date, M.startDatumTijd)) < 2
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    A.activiteitId,
    A.code,
    A.capaciteit,
    COUNT(AM.aanmeldingId) AS actieveBezetting
FROM dbo.Activiteit AS A
LEFT JOIN dbo.Aanmelding AS AM
    ON A.activiteitId = AM.activiteitId
   AND AM.status IN ('bevestigd', 'betaling_in_afwachting')
GROUP BY A.activiteitId, A.code, A.capaciteit
HAVING COUNT(AM.aanmeldingId) > A.capaciteit;

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM dbo.Activiteit AS A
        LEFT JOIN dbo.Aanmelding AS AM
            ON A.activiteitId = AM.activiteitId
           AND AM.status IN ('bevestigd', 'betaling_in_afwachting')
        GROUP BY A.activiteitId, A.capaciteit
        HAVING COUNT(AM.aanmeldingId) > A.capaciteit
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

SELECT
    AM.aanmeldingId,
    AM.status,
    AM.reserveringVervaltOp
FROM dbo.Aanmelding AS AM
WHERE AM.status = 'betaling_in_afwachting'
  AND (AM.reserveringVervaltOp IS NULL
       OR AM.reserveringVervaltOp <= CAST(AM.aanmelddatum AS DATETIME2(0)));

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1 FROM dbo.Aanmelding AS AM
        WHERE AM.status = 'betaling_in_afwachting'
          AND (AM.reserveringVervaltOp IS NULL
               OR AM.reserveringVervaltOp <= CAST(AM.aanmelddatum AS DATETIME2(0)))
    )
    THEN 'PASS' ELSE 'FAIL'
END AS resultaat;
GO

IF DB_ID(N'CampusEventDesk') IS NOT NULL
   AND OBJECT_ID(N'CampusEventDesk.dbo.EventDeskRegistratie', N'U') IS NOT NULL
BEGIN
    EXEC sys.sp_executesql N'
        WITH Origineel AS (
            SELECT R.aanmeldingId, R.persoonId, R.activiteitId,
                   R.aanmelddatum, R.status, R.deelnamevormId,
                   R.betalingId, R.betaalstatus
            FROM CampusEventDesk.dbo.EventDeskRegistratie AS R
            WHERE R.aanmeldingId IS NOT NULL
        ), Genormaliseerd AS (
            SELECT AM.aanmeldingId, AM.persoonId, AM.activiteitId,
                   AM.aanmelddatum, AM.status, AM.deelnamevormId,
                   B.betalingId, B.betaalstatus
            FROM dbo.Aanmelding AS AM
            LEFT JOIN dbo.Betaling AS B
                ON AM.aanmeldingId = B.aanmeldingId
        )
        SELECT
            (SELECT COUNT(*) FROM (
                SELECT * FROM Origineel EXCEPT SELECT * FROM Genormaliseerd
            ) AS Ontbreekt) AS ontbreektInOpdracht3,
            (SELECT COUNT(*) FROM (
                SELECT * FROM Genormaliseerd EXCEPT SELECT * FROM Origineel
            ) AS Extra) AS ontbreektInOpdracht2,
            CASE WHEN NOT EXISTS (
                SELECT * FROM Origineel EXCEPT SELECT * FROM Genormaliseerd
            ) AND NOT EXISTS (
                SELECT * FROM Genormaliseerd EXCEPT SELECT * FROM Origineel
            ) THEN ''PASS'' ELSE ''FAIL'' END AS resultaat;
    ';
END
ELSE
BEGIN
    SELECT 'SKIP' AS resultaat,
           N'Originele tabel CampusEventDesk.dbo.EventDeskRegistratie is niet beschikbaar.' AS reden;
END;
GO

