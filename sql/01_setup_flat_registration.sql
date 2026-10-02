-- Database Opdracht 2
-- Campus EventDesk
-- Bestand 01: database en platte 0NF-tabel aanmaken

CREATE DATABASE CampusEventDesk;
GO

USE CampusEventDesk;
GO

CREATE TABLE EventDeskRegistratie
(
    activiteitId VARCHAR(10) NOT NULL,
    code VARCHAR(20) NOT NULL,
    titel VARCHAR(100) NOT NULL,
    beschrijving VARCHAR(255) NOT NULL,
    startmoment DATETIME2(0) NOT NULL,
    eindmoment DATETIME2(0) NOT NULL,
    capaciteit INT NOT NULL,
    activiteitvorm VARCHAR(50) NOT NULL,

    locatieId VARCHAR(10) NOT NULL,
    aanduiding VARCHAR(100) NOT NULL,

    persoonId VARCHAR(10) NOT NULL,
    naam VARCHAR(100) NOT NULL,
    studentnummer VARCHAR(20) NULL,
    medewerkernummer VARCHAR(20) NULL,
    externeOrganisatieNaam VARCHAR(100) NULL,

    aanmelddatum DATE NOT NULL,
    status VARCHAR(30) NOT NULL,

    deelnamevormId VARCHAR(10) NOT NULL,
    deelnamevormNaam VARCHAR(50) NOT NULL,

    betalingId VARCHAR(10) NULL,
    betaalstatus VARCHAR(30) NULL,

    contactkanalen VARCHAR(500) NULL,
    categorieen VARCHAR(500) NOT NULL,
    tags VARCHAR(500) NULL,

    PRIMARY KEY (persoonId, activiteitId)
);
GO