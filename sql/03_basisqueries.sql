-- Database Opdracht 2
-- Campus EventDesk
-- Bestand 03: SQL-basisquery's

USE CampusEventDesk;
GO


-- Query 1
-- Informatievraag:
-- Welke verschillende activiteiten staan in de registratie,
-- gesorteerd op startmoment?

-- Waarom:
-- Dezelfde activiteit komt door meerdere aanmeldingen meerdere keren
-- voor in de platte registratie. DISTINCT voorkomt dubbele activiteiten.

SELECT DISTINCT
    activiteitId,
    titel,
    startmoment
FROM EventDeskRegistratie
ORDER BY startmoment;


-- Query 2
-- Informatievraag:
-- Welke activiteiten hebben 'AI' als herkenbaar onderdeel van de titel?

-- Waarom:
-- LIKE wordt gebruikt om titels te zoeken die beginnen met 'AI-'
-- of waarin ' AI-' als afzonderlijk onderdeel voorkomt.

SELECT DISTINCT
    activiteitId,
    titel
FROM EventDeskRegistratie
WHERE titel LIKE 'AI-%'
   OR titel LIKE '% AI-%';


-- Query 3
-- Informatievraag:
-- Welke aanmeldingen zijn gedaan tussen 24 september 2026
-- en 29 september 2026?

-- Waarom:
-- BETWEEN wordt gebruikt om aanmeldingen binnen een datumbereik
-- te selecteren. De begin- en einddatum vallen beide binnen het bereik.

SELECT
    persoonId,
    naam,
    activiteitId,
    titel,
    aanmelddatum
FROM EventDeskRegistratie
WHERE aanmelddatum BETWEEN '2026-09-24' AND '2026-09-29'
ORDER BY aanmelddatum;


-- Query 4
-- Informatievraag:
-- Welke aanmeldingen horen bij activiteiten met de activiteitvorm
-- 'workshop' of 'gastlezing'?

-- Waarom:
-- IN wordt gebruikt om meerdere gezochte waarden
-- voor hetzelfde veld in één voorwaarde te controleren.

SELECT
    persoonId,
    naam,
    activiteitId,
    titel,
    activiteitvorm
FROM EventDeskRegistratie
WHERE activiteitvorm IN ('workshop', 'gastlezing')
ORDER BY activiteitId, persoonId;


-- Query 5
-- Informatievraag:
-- Welke aanmeldingen hebben geen betaling?

-- Waarom:
-- IS NULL wordt gebruikt om aanmeldingen te vinden waarbij
-- geen betalingId aanwezig is.

SELECT
    persoonId,
    naam,
    activiteitId,
    titel,
    deelnamevormNaam,
    betalingId,
    betaalstatus
FROM EventDeskRegistratie
WHERE betalingId IS NULL
ORDER BY aanmelddatum;


-- Query 6
-- Informatievraag:
-- Welke drie verschillende activiteiten hebben de hoogste capaciteit?

-- Waarom:
-- TOP beperkt het resultaat tot drie activiteiten.
-- DISTINCT voorkomt dubbele activiteiten uit de platte registratie.
-- ORDER BY capaciteit DESC zet de hoogste capaciteit bovenaan.

SELECT DISTINCT TOP 3
    activiteitId,
    titel,
    capaciteit
FROM EventDeskRegistratie
ORDER BY capaciteit DESC;


-- Query 7
-- Informatievraag:
-- Hoe kan de capaciteit van iedere activiteit als leesbare
-- tekst voor een overzicht worden weergegeven?

-- Waarom:
-- CAST zet de numerieke capaciteit om naar tekst.
-- CONCAT combineert deze waarde daarna met andere tekst
-- tot een leesbare uitvoer.

SELECT DISTINCT
    activiteitId,
    titel,
    CONCAT(
        titel,
        ' - capaciteit: ',
        CAST(capaciteit AS VARCHAR(10)),
        ' plaatsen'
    ) AS capaciteitOmschrijving
FROM EventDeskRegistratie
ORDER BY activiteitId;


-- Query 8
-- Informatievraag:
-- Hoe kunnen de aanmeldingen als één leesbare omschrijving
-- worden weergegeven?

-- Waarom:
-- CONCAT combineert gegevens uit meerdere kolommen tot één
-- leesbare tekstwaarde voor bijvoorbeeld een overzicht of rapportage.

SELECT
    persoonId,
    activiteitId,
    CONCAT(
        naam,
        ' is aangemeld voor ',
        titel
    ) AS aanmeldingOmschrijving
FROM EventDeskRegistratie
ORDER BY aanmelddatum;


