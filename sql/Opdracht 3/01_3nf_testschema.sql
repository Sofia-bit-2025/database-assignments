
IF DB_ID(N'CampusEventDesk_Opdracht3') IS NOT NULL
    THROW 51000, N'Testdatabase bestaat al. Maak een bewuste back-up voordat je opnieuw begint.', 1;
GO

CREATE DATABASE CampusEventDesk_Opdracht3;
GO

USE CampusEventDesk_Opdracht3;
GO

CREATE TABLE dbo.Organisatie (
    organisatieId VARCHAR(10) NOT NULL PRIMARY KEY,
    naam NVARCHAR(100) NOT NULL,
    soortOrganisatie NVARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Locatie (
    locatieId VARCHAR(10) NOT NULL PRIMARY KEY,
    aanduiding NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.Categorie (
    categorieId VARCHAR(10) NOT NULL PRIMARY KEY,
    naam NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.Activiteitsvorm (
    activiteitsvormId VARCHAR(10) NOT NULL PRIMARY KEY,
    naam NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dbo.Tag (
    tagId VARCHAR(10) NOT NULL PRIMARY KEY,
    trefwoord NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.DeelnameVorm (
    deelnamevormId VARCHAR(10) NOT NULL PRIMARY KEY,
    naam NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dbo.Persoon (
    persoonId VARCHAR(10) NOT NULL PRIMARY KEY,
    naam NVARCHAR(100) NOT NULL,
    typeDeelnemer VARCHAR(30) NOT NULL,
    studentnummer VARCHAR(20) NULL,
    medewerkernummer VARCHAR(20) NULL,
    externeOrganisatieNaam NVARCHAR(100) NULL,

    CONSTRAINT CK_Persoon_Subtype CHECK (
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
    )
);

CREATE TABLE dbo.Activiteit (
    activiteitId VARCHAR(10) NOT NULL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    titel NVARCHAR(100) NOT NULL,
    beschrijving NVARCHAR(255) NOT NULL,
    capaciteit INT NOT NULL
        CHECK (capaciteit >= 0),
    publicatieStatus VARCHAR(20) NOT NULL
        CHECK (publicatieStatus IN ('concept', 'gepubliceerd')),
    locatieId VARCHAR(10) NOT NULL
        REFERENCES dbo.Locatie(locatieId),
    activiteitsvormId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteitsvorm(activiteitsvormId),
    vervolgActiviteitId VARCHAR(10) NULL
        REFERENCES dbo.Activiteit(activiteitId),

    CONSTRAINT CK_Activiteit_GeenEigenVervolg CHECK (
        vervolgActiviteitId IS NULL
        OR vervolgActiviteitId <> activiteitId
    )
);

CREATE TABLE dbo.ActiviteitMoment (
    momentId VARCHAR(10) NOT NULL PRIMARY KEY,
    startDatumTijd DATETIME2(0) NOT NULL,
    eindDatumTijd DATETIME2(0) NOT NULL,
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),

    CONSTRAINT CK_ActiviteitMoment_Tijd CHECK (
        startDatumTijd < eindDatumTijd
    )
);

CREATE TABLE dbo.ContactKanaal (
    contactkanaalId VARCHAR(10) NOT NULL PRIMARY KEY,
    soort NVARCHAR(40) NOT NULL,
    waarde NVARCHAR(150) NOT NULL,
    persoonId VARCHAR(10) NOT NULL
        REFERENCES dbo.Persoon(persoonId),

    CONSTRAINT UQ_ContactKanaal UNIQUE (
        persoonId,
        soort,
        waarde
    )
);

CREATE TABLE dbo.ActiviteitCategorie (
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),
    categorieId VARCHAR(10) NOT NULL
        REFERENCES dbo.Categorie(categorieId),

    PRIMARY KEY (activiteitId, categorieId)
);

CREATE TABLE dbo.ActiviteitTag (
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),
    tagId VARCHAR(10) NOT NULL
        REFERENCES dbo.Tag(tagId),

    PRIMARY KEY (activiteitId, tagId)
);

CREATE TABLE dbo.ActiviteitPublicatie (
    organisatieId VARCHAR(10) NOT NULL
        REFERENCES dbo.Organisatie(organisatieId),
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),

    PRIMARY KEY (organisatieId, activiteitId)
);

CREATE TABLE dbo.ActiviteitOrganisatie (
    organisatieId VARCHAR(10) NOT NULL
        REFERENCES dbo.Organisatie(organisatieId),
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),

    PRIMARY KEY (organisatieId, activiteitId)
);

CREATE TABLE dbo.ActiviteitVoorwaarde (
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),
    voorwaardeActiviteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),

    PRIMARY KEY (activiteitId),

    CONSTRAINT CK_Voorwaarde_NietZelf CHECK (
        activiteitId <> voorwaardeActiviteitId
    )
);

CREATE TABLE dbo.Aanmelding (
    aanmeldingId VARCHAR(10) NOT NULL PRIMARY KEY,
    aanmelddatum DATE NOT NULL,
    status VARCHAR(30) NOT NULL
        CHECK (
            status IN (
                'wachtlijst',
                'betaling_in_afwachting',
                'bevestigd',
                'geannuleerd'
            )
        ),
    reserveringVervaltOp DATETIME2(0) NULL,
    persoonId VARCHAR(10) NOT NULL
        REFERENCES dbo.Persoon(persoonId),
    activiteitId VARCHAR(10) NOT NULL
        REFERENCES dbo.Activiteit(activiteitId),
    deelnamevormId VARCHAR(10) NOT NULL
        REFERENCES dbo.DeelnameVorm(deelnamevormId),

    CONSTRAINT CK_Aanmelding_Reservering CHECK (
        status <> 'betaling_in_afwachting'
        OR reserveringVervaltOp IS NOT NULL
    )
);

CREATE TABLE dbo.Betaling (
    betalingId VARCHAR(10) NOT NULL PRIMARY KEY,
    aanmeldingId VARCHAR(10) NOT NULL UNIQUE
        REFERENCES dbo.Aanmelding(aanmeldingId),
    betaalstatus VARCHAR(30) NOT NULL
        CHECK (
            betaalstatus IN (
                'in_behandeling',
                'betaald',
                'mislukt',
                'terugbetaald'
            )
        )
);
GO

CREATE UNIQUE INDEX UX_Aanmelding_EenActievePoging
ON dbo.Aanmelding (persoonId, activiteitId)
WHERE status IN (
    'wachtlijst',
    'betaling_in_afwachting',
    'bevestigd'
);
GO
t