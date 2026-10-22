USE CampusEventDesk;
GO

SELECT DISTINCT
    activiteitId,
    code,
    titel,
    publicatieStatus
FROM dbo.EventDeskRegistratie
ORDER BY titel, activiteitId;
GO

SELECT DISTINCT
    activiteitId,
    titel
FROM dbo.EventDeskRegistratie
WHERE titel LIKE N'AI-%'
   OR titel LIKE N'% AI-%'
ORDER BY titel, activiteitId;
GO

SELECT
    aanmeldingId,
    persoonId,
    persoonNaam,
    activiteitId,
    titel,
    aanmelddatum
FROM dbo.EventDeskRegistratie
WHERE aanmelddatum BETWEEN '20260924' AND '20260929'
ORDER BY aanmelddatum, aanmeldingId;
GO

SELECT
    aanmeldingId,
    persoonId,
    persoonNaam,
    activiteitId,
    titel,
    activiteitsvormNaam
FROM dbo.EventDeskRegistratie
WHERE activiteitsvormNaam IN (N'workshop', N'gastlezing')
  AND aanmeldingId IS NOT NULL
ORDER BY activiteitId, persoonId, aanmeldingId;
GO

SELECT
    aanmeldingId,
    persoonId,
    persoonNaam,
    activiteitId,
    titel,
    deelnamevormNaam,
    status,
    betalingId,
    betaalstatus
FROM dbo.EventDeskRegistratie
WHERE aanmeldingId IS NOT NULL
  AND betalingId IS NULL
ORDER BY aanmelddatum, aanmeldingId;
GO

SELECT DISTINCT TOP (3)
    activiteitId,
    titel,
    capaciteit
FROM dbo.EventDeskRegistratie
ORDER BY capaciteit DESC, activiteitId ASC;
GO

SELECT DISTINCT
    activiteitId,
    titel,
    CONCAT(
        titel,
        N' - capaciteit: ',
        CAST(capaciteit AS VARCHAR(10)),
        N' plaatsen'
    ) AS capaciteitOmschrijving
FROM dbo.EventDeskRegistratie
ORDER BY activiteitId;
GO

SELECT
    aanmeldingId,
    persoonId,
    activiteitId,
    CONCAT(
        persoonNaam,
        N' - ',
        titel,
        N' - status: ',
        status
    ) AS aanmeldingOmschrijving
FROM dbo.EventDeskRegistratie
WHERE aanmeldingId IS NOT NULL
ORDER BY aanmelddatum, aanmeldingId;
GO