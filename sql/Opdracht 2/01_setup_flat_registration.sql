
IF DB_ID(N'CampusEventDesk') IS NULL
    EXEC(N'CREATE DATABASE CampusEventDesk');
GO

USE CampusEventDesk;
GO

IF OBJECT_ID(N'dbo.EventDeskRegistratie', N'U') IS NOT NULL
    THROW 50001, N'EventDeskRegistratie bestaat al. Maak eerst een back-up en controleer de bestaande structuur.', 1;
GO

CREATE TABLE dbo.EventDeskRegistratie
(
    registratieId INT IDENTITY(1,1) NOT NULL,
    activiteitId VARCHAR(10) NOT NULL,
    code VARCHAR(20) NOT NULL,
    titel NVARCHAR(100) NOT NULL,
    beschrijving NVARCHAR(255) NOT NULL,
    capaciteit INT NOT NULL,
    publicatieStatus VARCHAR(20) NOT NULL,
    locatieId VARCHAR(10) NOT NULL,
    aanduiding NVARCHAR(100) NOT NULL,
    activiteitsvormId VARCHAR(10) NOT NULL,
    activiteitsvormNaam NVARCHAR(50) NOT NULL,
    geplandeMomenten NVARCHAR(2000) NULL,
    categorieen NVARCHAR(1000) NOT NULL,
    tags NVARCHAR(1000) NULL,
    publicerendeOrganisaties NVARCHAR(1000) NULL,
    organiserendeOrganisaties NVARCHAR(1000) NULL,
    voorwaardeActiviteitId VARCHAR(10) NULL,
    vervolgActiviteitId VARCHAR(10) NULL,
    aanmeldingId VARCHAR(10) NULL,
    persoonId VARCHAR(10) NULL,
    persoonNaam NVARCHAR(100) NULL,
    typeDeelnemer VARCHAR(30) NULL,
    studentnummer VARCHAR(20) NULL,
    medewerkernummer VARCHAR(20) NULL,
    externeOrganisatieNaam NVARCHAR(100) NULL,
    contactkanalen NVARCHAR(1000) NULL,
    aanmelddatum DATE NULL,
    status VARCHAR(30) NULL,
    reserveringVervaltOp DATETIME2(0) NULL,
    deelnamevormId VARCHAR(10) NULL,
    deelnamevormNaam NVARCHAR(50) NULL,
    betalingId VARCHAR(10) NULL,
    betaalstatus VARCHAR(30) NULL,

    CONSTRAINT PK_EventDeskRegistratie
        PRIMARY KEY (registratieId),

    CONSTRAINT CK_EventDesk_VerplichteActiviteitVelden
        CHECK (
            LEN(LTRIM(RTRIM(activiteitId))) > 0
            AND LEN(LTRIM(RTRIM(code))) > 0
            AND LEN(LTRIM(RTRIM(titel))) > 0
            AND LEN(LTRIM(RTRIM(beschrijving))) > 0
            AND LEN(LTRIM(RTRIM(locatieId))) > 0
            AND LEN(LTRIM(RTRIM(aanduiding))) > 0
            AND LEN(LTRIM(RTRIM(activiteitsvormId))) > 0
            AND LEN(LTRIM(RTRIM(activiteitsvormNaam))) > 0
            AND LEN(LTRIM(RTRIM(categorieen))) > 0
        ),

    CONSTRAINT CK_EventDesk_Capaciteit
        CHECK (capaciteit >= 0),

    CONSTRAINT CK_EventDesk_PublicatieStatus
        CHECK (publicatieStatus IN ('concept', 'gepubliceerd')),

    CONSTRAINT CK_EventDesk_GeplandeMomenten
        CHECK (
            publicatieStatus = 'concept'
            OR (
                geplandeMomenten IS NOT NULL
                AND LEN(LTRIM(RTRIM(geplandeMomenten))) > 0
            )
        ),

    CONSTRAINT CK_EventDesk_Voorwaarde
        CHECK (
            voorwaardeActiviteitId IS NULL
            OR voorwaardeActiviteitId <> activiteitId
        ),

    CONSTRAINT CK_EventDesk_Vervolgactiviteit
        CHECK (
            vervolgActiviteitId IS NULL
            OR vervolgActiviteitId <> activiteitId
        ),

    CONSTRAINT CK_EventDesk_OptioneleTekstvelden
        CHECK (
            (geplandeMomenten IS NULL
             OR LEN(LTRIM(RTRIM(geplandeMomenten))) > 0)
            AND (tags IS NULL
                 OR LEN(LTRIM(RTRIM(tags))) > 0)
            AND (publicerendeOrganisaties IS NULL
                 OR LEN(LTRIM(RTRIM(publicerendeOrganisaties))) > 0)
            AND (organiserendeOrganisaties IS NULL
                 OR LEN(LTRIM(RTRIM(organiserendeOrganisaties))) > 0)
            AND (voorwaardeActiviteitId IS NULL
                 OR LEN(LTRIM(RTRIM(voorwaardeActiviteitId))) > 0)
            AND (vervolgActiviteitId IS NULL
                 OR LEN(LTRIM(RTRIM(vervolgActiviteitId))) > 0)
            AND (contactkanalen IS NULL
                 OR LEN(LTRIM(RTRIM(contactkanalen))) > 0)
        ),

    CONSTRAINT CK_EventDesk_AanmeldStatus
        CHECK (
            status IS NULL
            OR status IN (
                'wachtlijst',
                'betaling_in_afwachting',
                'bevestigd',
                'geannuleerd'
            )
        ),

    CONSTRAINT CK_EventDesk_BetaalStatus
        CHECK (
            betaalstatus IS NULL
            OR betaalstatus IN (
                'in_behandeling',
                'betaald',
                'mislukt',
                'terugbetaald'
            )
        ),

    CONSTRAINT CK_EventDesk_AanmeldingVelden
        CHECK (
            (
                aanmeldingId IS NULL
                AND persoonId IS NULL
                AND persoonNaam IS NULL
                AND typeDeelnemer IS NULL
                AND studentnummer IS NULL
                AND medewerkernummer IS NULL
                AND externeOrganisatieNaam IS NULL
                AND contactkanalen IS NULL
                AND aanmelddatum IS NULL
                AND status IS NULL
                AND reserveringVervaltOp IS NULL
                AND deelnamevormId IS NULL
                AND deelnamevormNaam IS NULL
                AND betalingId IS NULL
                AND betaalstatus IS NULL
            )
            OR
            (
                aanmeldingId IS NOT NULL
                AND LEN(LTRIM(RTRIM(aanmeldingId))) > 0
                AND persoonId IS NOT NULL
                AND LEN(LTRIM(RTRIM(persoonId))) > 0
                AND persoonNaam IS NOT NULL
                AND LEN(LTRIM(RTRIM(persoonNaam))) > 0
                AND typeDeelnemer IS NOT NULL
                AND aanmelddatum IS NOT NULL
                AND status IS NOT NULL
                AND deelnamevormId IS NOT NULL
                AND LEN(LTRIM(RTRIM(deelnamevormId))) > 0
                AND deelnamevormNaam IS NOT NULL
                AND LEN(LTRIM(RTRIM(deelnamevormNaam))) > 0
            )
        ),

    CONSTRAINT CK_EventDesk_Deelnemerstype
        CHECK (
            typeDeelnemer IS NULL
            OR
            (
                typeDeelnemer = 'StudentDeelnemer'
                AND studentnummer IS NOT NULL
                AND LEN(LTRIM(RTRIM(studentnummer))) > 0
                AND medewerkernummer IS NULL
                AND externeOrganisatieNaam IS NULL
            )
            OR
            (
                typeDeelnemer = 'MedewerkerDeelnemer'
                AND studentnummer IS NULL
                AND medewerkernummer IS NOT NULL
                AND LEN(LTRIM(RTRIM(medewerkernummer))) > 0
                AND externeOrganisatieNaam IS NULL
            )
            OR
            (
                typeDeelnemer = 'ExterneDeelnemer'
                AND studentnummer IS NULL
                AND medewerkernummer IS NULL
                AND externeOrganisatieNaam IS NOT NULL
                AND LEN(LTRIM(RTRIM(externeOrganisatieNaam))) > 0
            )
        ),

    CONSTRAINT CK_EventDesk_BetalingVelden
        CHECK (
            (
                betalingId IS NULL
                AND betaalstatus IS NULL
            )
            OR
            (
                betalingId IS NOT NULL
                AND LEN(LTRIM(RTRIM(betalingId))) > 0
                AND betaalstatus IS NOT NULL
                AND aanmeldingId IS NOT NULL
            )
        ),

    CONSTRAINT CK_EventDesk_Reservering
        CHECK (
            status IS NULL
            OR status <> 'betaling_in_afwachting'
            OR reserveringVervaltOp IS NOT NULL
        )
);
GO

CREATE UNIQUE INDEX UX_EventDesk_AanmeldingId
    ON dbo.EventDeskRegistratie (aanmeldingId)
    WHERE aanmeldingId IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_EventDesk_BetalingId
    ON dbo.EventDeskRegistratie (betalingId)
    WHERE betalingId IS NOT NULL;
GO

SELECT TOP (0) *
FROM dbo.EventDeskRegistratie;
GO
