-- Database Opdracht 2
-- Campus EventDesk
-- Bestand 05: views

USE CampusEventDesk;
GO


-- View 1
-- Informatiebehoefte:
-- Een herbruikbaar overzicht van de verschillende activiteiten
-- met hun locatie, planning en capaciteit.

-- Waarom:
-- Activiteitgegevens komen door meerdere aanmeldingen meerdere keren
-- voor in de platte registratie.
-- DISTINCT zorgt ervoor dat iedere activiteit één keer wordt weergegeven.

CREATE VIEW dbo.vw_ActiviteitOverzicht
AS
SELECT DISTINCT
    activiteitId,
    code,
    titel,
    beschrijving,
    startmoment,
    eindmoment,
    capaciteit,
    activiteitvorm,
    locatieId,
    aanduiding
FROM dbo.EventDeskRegistratie;
GO


-- Test View 1
-- Controleert of het activiteitsoverzicht correcte
-- en unieke activiteiten teruggeeft.

SELECT *
FROM dbo.vw_ActiviteitOverzicht
ORDER BY startmoment;
GO


-- View 2
-- Informatiebehoefte:
-- Een herbruikbaar overzicht van aanmeldingen
-- met hun deelnamevorm en eventuele betaling.

-- Waarom:
-- De view brengt aanmeldings- en betaalgegevens samen
-- in één herbruikbaar overzicht.
-- Betaling is optioneel, daarom kunnen betalingId
-- en betaalstatus NULL zijn.

CREATE VIEW dbo.vw_BetaalOverzicht
AS
SELECT
    persoonId,
    naam,
    activiteitId,
    titel,
    aanmelddatum,
    deelnamevormId,
    deelnamevormNaam,
    betalingId,
    betaalstatus
FROM dbo.EventDeskRegistratie;
GO


-- Test View 2
-- Controleert of alle aanmeldingen met hun
-- deelnamevorm en eventuele betaling worden weergegeven.

SELECT *
FROM dbo.vw_BetaalOverzicht
ORDER BY aanmelddatum;
GO


/*

vw_ActiviteitOverzicht
- geeft een herbruikbaar overzicht van unieke activiteiten;
- bevat locatie, planning en capaciteit;
- voorkomt dubbele activiteiten uit de platte registratie
  door DISTINCT te gebruiken.

vw_BetaalOverzicht
- geeft een herbruikbaar overzicht van aanmeldingen,
  deelnamevormen en betalingen;
- laat zowel aanwezige als ontbrekende betalingen zien;
- betalingId en betaalstatus kunnen NULL zijn
  wanneer geen betaling aanwezig is.

Testresultaten:
vw_ActiviteitOverzicht :4 unieke activiteiten
vw_BetaalOverzicht     :12 aanmeldingen
*/