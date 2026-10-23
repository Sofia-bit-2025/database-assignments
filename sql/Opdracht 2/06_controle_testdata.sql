USE CampusEventDesk;
GO

SELECT
    COUNT(*) AS aantalRegistraties,
    COUNT(aanmeldingId) AS aantalAanmeldpogingen,
    COUNT(DISTINCT persoonId) AS aantalPersonen,
    COUNT(DISTINCT activiteitId) AS aantalActiviteiten,
    COUNT(betalingId) AS aantalBetalingen
FROM dbo.EventDeskRegistratie;
GO

SELECT
    registratieId,
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
ORDER BY activiteitId, aanmelddatum, aanmeldingId, registratieId;
GO

SELECT
    COUNT(DISTINCT persoonId) AS aantalUniekePersonen,
    COUNT(DISTINCT activiteitId) AS aantalUniekeActiviteiten,
    COUNT(DISTINCT aanmeldingId) AS aantalUniekeAanmeldingen
FROM dbo.EventDeskRegistratie;
GO

SELECT
    activiteitId,
    titel,
    COUNT(aanmeldingId) AS aantalAanmeldingen
FROM dbo.EventDeskRegistratie
GROUP BY activiteitId, titel
ORDER BY activiteitId;
GO

SELECT
    COUNT(aanmeldingId) AS aantalAanmeldingen,
    COUNT(betalingId) AS metBetaling,
    COUNT(aanmeldingId) - COUNT(betalingId) AS zonderBetaling
FROM dbo.EventDeskRegistratie;
GO

SELECT DISTINCT
    persoonId,
    persoonNaam,
    typeDeelnemer,
    studentnummer,
    medewerkernummer,
    externeOrganisatieNaam
FROM dbo.EventDeskRegistratie
WHERE persoonId IS NOT NULL
ORDER BY persoonId;
GO

SELECT
    activiteitId,
    aanmeldingId,
    persoonId,
    geplandeMomenten,
    categorieen,
    tags,
    contactkanalen,
    publicerendeOrganisaties,
    organiserendeOrganisaties
FROM dbo.EventDeskRegistratie
ORDER BY activiteitId, aanmeldingId, registratieId;
GO

SELECT
    persoonId,
    activiteitId,
    COUNT(aanmeldingId) AS aantalAanmeldpogingen
FROM dbo.EventDeskRegistratie
WHERE aanmeldingId IS NOT NULL
GROUP BY persoonId, activiteitId
HAVING COUNT(aanmeldingId) > 1
ORDER BY persoonId, activiteitId;
GO

SELECT
    persoonId,
    activiteitId,
    COUNT(aanmeldingId) AS aantalActieveAanmeldingen
FROM dbo.EventDeskRegistratie
WHERE status IN ('wachtlijst', 'betaling_in_afwachting', 'bevestigd')
GROUP BY persoonId, activiteitId
HAVING COUNT(aanmeldingId) > 1;
GO

SELECT
    status,
    COUNT(aanmeldingId) AS aantalAanmeldingen
FROM dbo.EventDeskRegistratie
WHERE aanmeldingId IS NOT NULL
GROUP BY status
ORDER BY status;
GO

SELECT
    betaalstatus,
    COUNT(betalingId) AS aantalBetalingen
FROM dbo.EventDeskRegistratie
WHERE betalingId IS NOT NULL
GROUP BY betaalstatus
ORDER BY betaalstatus;
GO

SELECT
    SUM(CASE WHEN aanmeldingId IS NULL THEN 1 ELSE 0 END) AS registratiesZonderAanmelding,
    SUM(CASE WHEN aanmeldingId IS NOT NULL AND persoonId IS NULL THEN 1 ELSE 0 END) AS aanmeldingenZonderPersoon,
    SUM(CASE WHEN activiteitId IS NULL THEN 1 ELSE 0 END) AS registratiesZonderActiviteit,
    SUM(CASE WHEN categorieen IS NULL THEN 1 ELSE 0 END) AS registratiesZonderCategorieen,
    SUM(CASE WHEN betalingId IS NULL AND aanmeldingId IS NOT NULL THEN 1 ELSE 0 END) AS aanmeldingenZonderBetaling
FROM dbo.EventDeskRegistratie;
GO

SELECT
    activiteitId,
    COUNT(DISTINCT code) AS aantalCodes,
    COUNT(DISTINCT titel) AS aantalTitels,
    COUNT(DISTINCT capaciteit) AS aantalCapaciteiten,
    COUNT(DISTINCT locatieId) AS aantalLocaties,
    COUNT(DISTINCT activiteitsvormId) AS aantalActiviteitsvormen,
    COUNT(DISTINCT publicatieStatus) AS aantalPublicatiestatussen
FROM dbo.EventDeskRegistratie
GROUP BY activiteitId
HAVING COUNT(DISTINCT code) > 1
    OR COUNT(DISTINCT titel) > 1
    OR COUNT(DISTINCT capaciteit) > 1
    OR COUNT(DISTINCT locatieId) > 1
    OR COUNT(DISTINCT activiteitsvormId) > 1
    OR COUNT(DISTINCT publicatieStatus) > 1;
GO

SELECT
    activiteitId,
    titel,
    publicatieStatus,
    geplandeMomenten
FROM dbo.EventDeskRegistratie
WHERE (publicatieStatus = 'gepubliceerd' AND geplandeMomenten IS NULL)
   OR (publicatieStatus = 'concept' AND aanmeldingId IS NOT NULL)
ORDER BY activiteitId;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.vw_ActiviteitOverzicht) AS aantalActiviteitenInView,
    (SELECT COUNT(*) FROM dbo.vw_BetaalOverzicht) AS aantalAanmeldingenInView,
    (SELECT COUNT(*) FROM dbo.vw_BetaalOverzicht WHERE betalingId IS NOT NULL) AS metBetalingInView,
    (SELECT COUNT(*) FROM dbo.vw_BetaalOverzicht WHERE betalingId IS NULL) AS zonderBetalingInView;
GO

SELECT
    activiteitId,
    COUNT(*) AS aantalRijen
FROM dbo.vw_ActiviteitOverzicht
GROUP BY activiteitId
HAVING COUNT(*) > 1;
GO

SELECT
    aanmeldingId,
    COUNT(*) AS aantalRijen
FROM dbo.vw_BetaalOverzicht
GROUP BY aanmeldingId
HAVING aanmeldingId IS NULL OR COUNT(*) > 1;
GO
