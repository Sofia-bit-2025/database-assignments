
USE CampusEventDesk;
GO

SELECT
    activiteitId,
    titel,
    COUNT(aanmeldingId) AS aantalAanmeldingen
FROM dbo.EventDeskRegistratie
GROUP BY
    activiteitId,
    titel
ORDER BY activiteitId;
GO

SELECT
    activiteitsvormId,
    activiteitsvormNaam,
    CAST(
        AVG(CAST(capaciteit AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS gemiddeldeCapaciteit
FROM
(
    SELECT DISTINCT
        activiteitId,
        activiteitsvormId,
        activiteitsvormNaam,
        capaciteit
    FROM dbo.EventDeskRegistratie
) AS uniekeActiviteiten
GROUP BY
    activiteitsvormId,
    activiteitsvormNaam
ORDER BY activiteitsvormNaam;
GO

SELECT
    activiteitsvormId,
    activiteitsvormNaam,
    MIN(capaciteit) AS laagsteCapaciteit,
    MAX(capaciteit) AS hoogsteCapaciteit
FROM
(
    SELECT DISTINCT
        activiteitId,
        activiteitsvormId,
        activiteitsvormNaam,
        capaciteit
    FROM dbo.EventDeskRegistratie
) AS uniekeActiviteiten
GROUP BY
    activiteitsvormId,
    activiteitsvormNaam
ORDER BY activiteitsvormNaam;
GO

SELECT
    activiteitId,
    titel,
    COUNT(aanmeldingId) AS aantalAanmeldingen
FROM dbo.EventDeskRegistratie
GROUP BY
    activiteitId,
    titel
HAVING COUNT(aanmeldingId) > 2
ORDER BY aantalAanmeldingen DESC, activiteitId;
GO

SELECT
    deelnamevormId,
    deelnamevormNaam,
    COUNT(aanmeldingId) AS aantalAanmeldingen
FROM dbo.EventDeskRegistratie
WHERE aanmeldingId IS NOT NULL
GROUP BY
    deelnamevormId,
    deelnamevormNaam
HAVING COUNT(aanmeldingId) > 3
ORDER BY aantalAanmeldingen DESC, deelnamevormId;
GO
