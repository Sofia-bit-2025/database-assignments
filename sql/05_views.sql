
USE CampusEventDesk;
GO

CREATE OR ALTER VIEW dbo.vw_ActiviteitOverzicht
AS
SELECT DISTINCT
    activiteitId,
    code,
    titel,
    beschrijving,
    publicatieStatus,
    capaciteit,
    locatieId,
    aanduiding,
    activiteitsvormId,
    activiteitsvormNaam,
    geplandeMomenten
FROM dbo.EventDeskRegistratie;
GO

CREATE OR ALTER VIEW dbo.vw_BetaalOverzicht
AS
SELECT
    aanmeldingId,
    persoonId,
    persoonNaam,
    activiteitId,
    titel,
    aanmelddatum,
    status,
    deelnamevormId,
    deelnamevormNaam,
    betalingId,
    betaalstatus
FROM dbo.EventDeskRegistratie
WHERE aanmeldingId IS NOT NULL;
GO

SELECT
    activiteitId,
    code,
    titel,
    publicatieStatus,
    capaciteit,
    aanduiding,
    activiteitsvormNaam,
    geplandeMomenten
FROM dbo.vw_ActiviteitOverzicht
ORDER BY activiteitId;
GO

SELECT
    aanmeldingId,
    persoonNaam,
    activiteitId,
    status,
    deelnamevormNaam,
    betalingId,
    betaalstatus
FROM dbo.vw_BetaalOverzicht
ORDER BY aanmelddatum, aanmeldingId;
GO

SELECT
    (SELECT COUNT(*)
     FROM dbo.vw_ActiviteitOverzicht) AS aantalActiviteiten,
    (SELECT COUNT(*)
     FROM dbo.vw_BetaalOverzicht) AS aantalAanmeldingen,
    (SELECT COUNT(*)
     FROM dbo.vw_BetaalOverzicht
     WHERE betalingId IS NOT NULL) AS aantalMetBetaling,
    (SELECT COUNT(*)
     FROM dbo.vw_BetaalOverzicht
     WHERE betalingId IS NULL) AS aantalZonderBetaling;
GO

SELECT
    activiteitId,
    COUNT(*) AS aantal
FROM dbo.vw_ActiviteitOverzicht
GROUP BY activiteitId
HAVING COUNT(*) > 1;
GO

SELECT *
FROM dbo.vw_BetaalOverzicht
WHERE aanmeldingId IS NULL;
GO
