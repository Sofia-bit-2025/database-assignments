-- Database Opdracht 2
-- Campus EventDesk
-- Bestand 04: aggregatiequery's

USE CampusEventDesk;
GO


-- Query 1
-- Informatievraag:
-- Hoeveel aanmeldingen heeft iedere activiteit?

-- Waarom:
-- COUNT telt het aantal aanmeldingen.
-- GROUP BY groepeert de rijen per activiteit.

SELECT
    activiteitId,
    titel,
    COUNT(*) AS aantalAanmeldingen
FROM EventDeskRegistratie
GROUP BY
    activiteitId,
    titel
ORDER BY activiteitId;


-- Query 2
-- Informatievraag:
-- Wat is de gemiddelde capaciteit per activiteitvorm?

-- Waarom:
-- AVG berekent de gemiddelde capaciteit.
-- GROUP BY groepeert de activiteiten per activiteitvorm.
-- De subquery haalt eerst de unieke activiteiten op,
-- zodat dezelfde activiteit niet meerdere keren meetelt
-- door herhaalde aanmeldingen in de platte registratie.

SELECT
    activiteitvorm,
    CAST(
        AVG(CAST(capaciteit AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS gemiddeldeCapaciteit
FROM
(
    SELECT DISTINCT
        activiteitId,
        activiteitvorm,
        capaciteit
    FROM EventDeskRegistratie
) AS uniekeActiviteiten
GROUP BY activiteitvorm
ORDER BY activiteitvorm;


-- Query 3
-- Informatievraag:
-- Wat is de laagste en hoogste capaciteit per activiteitvorm?

-- Waarom:
-- MIN geeft de laagste capaciteit binnen een activiteitvorm.
-- MAX geeft de hoogste capaciteit binnen een activiteitvorm.
-- De subquery haalt eerst de unieke activiteiten op,
-- zodat herhaalde aanmeldingen de uitkomst niet beïnvloeden.

SELECT
    activiteitvorm,
    MIN(capaciteit) AS laagsteCapaciteit,
    MAX(capaciteit) AS hoogsteCapaciteit
FROM
(
    SELECT DISTINCT
        activiteitId,
        activiteitvorm,
        capaciteit
    FROM EventDeskRegistratie
) AS uniekeActiviteiten
GROUP BY activiteitvorm
ORDER BY activiteitvorm;


-- Query 4
-- Informatievraag:
-- Welke activiteiten hebben meer dan twee aanmeldingen?

-- Waarom:
-- COUNT telt het aantal aanmeldingen per activiteit.
-- GROUP BY vormt per activiteit één groep.
-- HAVING filtert daarna de gevormde groepen
-- op het aantal aanmeldingen.

SELECT
    activiteitId,
    titel,
    COUNT(*) AS aantalAanmeldingen
FROM EventDeskRegistratie
GROUP BY
    activiteitId,
    titel
HAVING COUNT(*) > 2
ORDER BY aantalAanmeldingen DESC, activiteitId;


-- Query 5
-- Informatievraag:
-- Welke deelnamevormen zijn bij meer dan drie aanmeldingen gebruikt?

-- Waarom:
-- COUNT telt hoeveel aanmeldingen iedere deelnamevorm heeft.
-- GROUP BY vormt per deelnamevorm één groep.
-- HAVING filtert daarna alleen de groepen
-- met meer dan drie aanmeldingen.

SELECT
    deelnamevormId,
    deelnamevormNaam,
    COUNT(*) AS aantalAanmeldingen
FROM EventDeskRegistratie
GROUP BY
    deelnamevormId,
    deelnamevormNaam
HAVING COUNT(*) > 3
ORDER BY aantalAanmeldingen DESC;


/*
Verschil tussen WHERE en HAVING:

WHERE filtert individuele rijen voordat de groepering
met GROUP BY plaatsvindt.

Voorbeeld uit de basisquery's:
WHERE betalingId IS NULL

Hier worden eerst alleen aanmeldingen zonder betaling geselecteerd.

HAVING filtert groepen nadat GROUP BY de rijen
heeft gegroepeerd.

Voorbeeld uit Query 4:
HAVING COUNT(*) > 2

Hier worden eerst de aanmeldingen per activiteit gegroepeerd.
Daarna blijven alleen activiteiten met meer dan twee aanmeldingen over.

Voorbeeld uit Query 5:
HAVING COUNT(*) > 3

Hier worden eerst de aanmeldingen per deelnamevorm gegroepeerd.
Daarna blijven alleen deelnamevormen met meer dan drie aanmeldingen over.

WHERE:
filtert individuele rijen vóór GROUP BY.

HAVING:
filtert groepen nadat GROUP BY is uitgevoerd.
*/