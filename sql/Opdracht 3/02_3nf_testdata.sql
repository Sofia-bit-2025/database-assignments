USE CampusEventDesk_Opdracht3;
GO
SET XACT_ABORT ON;
GO
IF EXISTS (SELECT 1 FROM dbo.Organisatie)
    OR EXISTS (SELECT 1 FROM dbo.Locatie)
    OR EXISTS (SELECT 1 FROM dbo.Categorie)
    OR EXISTS (SELECT 1 FROM dbo.Activiteitsvorm)
    OR EXISTS (SELECT 1 FROM dbo.Tag)
    OR EXISTS (SELECT 1 FROM dbo.DeelnameVorm)
    OR EXISTS (SELECT 1 FROM dbo.Persoon)
    OR EXISTS (SELECT 1 FROM dbo.Activiteit)
    OR EXISTS (SELECT 1 FROM dbo.ActiviteitMoment)
    OR EXISTS (SELECT 1 FROM dbo.ContactKanaal)
    OR EXISTS (SELECT 1 FROM dbo.ActiviteitCategorie)
    OR EXISTS (SELECT 1 FROM dbo.ActiviteitTag)
    OR EXISTS (SELECT 1 FROM dbo.ActiviteitPublicatie)
    OR EXISTS (SELECT 1 FROM dbo.ActiviteitOrganisatie)
    OR EXISTS (SELECT 1 FROM dbo.ActiviteitVoorwaarde)
    OR EXISTS (SELECT 1 FROM dbo.Aanmelding)
    OR EXISTS (SELECT 1 FROM dbo.Betaling)
    THROW 51001, N'Er zijn al records aanwezig. Voer het script niet dubbel uit.', 1;
GO
BEGIN TRY
    BEGIN TRANSACTION;

INSERT INTO dbo.Organisatie (organisatieId, naam, soortOrganisatie)
VALUES
    (N'O01', N'ICT-opleiding', N'opleiding'),
    (N'O02', N'AI-kenniskring', N'kenniskring'),
    (N'O03', N'Studievereniging Code', N'studievereniging');

INSERT INTO dbo.Locatie (locatieId, aanduiding)
VALUES
    (N'L01', N'Gebouw A - lokaal 1.01'),
    (N'L02', N'Aula'),
    (N'L03', N'ICT-lab 2.14'),
    (N'L04', N'Innovatielab');

INSERT INTO dbo.Categorie (categorieId, naam)
VALUES
    (N'C01', N'onderwijs'),
    (N'C02', N'onderzoek'),
    (N'C03', N'technologie');

INSERT INTO dbo.Activiteitsvorm (activiteitsvormId, naam)
VALUES
    (N'AV01', N'workshop'),
    (N'AV02', N'gastlezing'),
    (N'AV03', N'meerdaagse training'),
    (N'AV04', N'hybride bijeenkomst');

INSERT INTO dbo.Tag (tagId, trefwoord)
VALUES
    (N'T01', N'beginner'),
    (N'T02', N'hybride'),
    (N'T03', N'gevorderd');

INSERT INTO dbo.DeelnameVorm (deelnamevormId, naam)
VALUES
    (N'DV01', N'gratis'),
    (N'DV02', N'early bird'),
    (N'DV03', N'betaald');

INSERT INTO dbo.Persoon (persoonId, naam, typeDeelnemer, studentnummer, medewerkernummer, externeOrganisatieNaam)
VALUES
    (N'P001', N'Nora de Vries', N'StudentDeelnemer', N'S26001', NULL, NULL),
    (N'P002', N'Yassin El Amrani', N'StudentDeelnemer', N'S26002', NULL, NULL),
    (N'P003', N'Mila Jansen', N'MedewerkerDeelnemer', NULL, N'M26001', NULL),
    (N'P004', N'Amir Rahimi', N'ExterneDeelnemer', NULL, NULL, N'TechLab'),
    (N'P005', N'Lisa de Boer', N'MedewerkerDeelnemer', NULL, N'M26002', NULL),
    (N'P006', N'Noah Peters', N'ExterneDeelnemer', NULL, NULL, N'DataCo');

INSERT INTO dbo.Activiteit (activiteitId, code, titel, beschrijving, capaciteit, publicatieStatus, locatieId, activiteitsvormId, vervolgActiviteitId)
VALUES
    (N'A02', N'EVT002', N'Onderzoeksgastlezing', N'Gastlezing over praktijkgericht onderzoek', 80, N'gepubliceerd', N'L02', N'AV02', NULL),
    (N'A03', N'EVT003', N'Softwaretraining', N'Meerdaagse training softwareontwikkeling', 25, N'gepubliceerd', N'L03', N'AV03', NULL),
    (N'A04', N'EVT004', N'Hybride AI-sessie', N'Hybride bijeenkomst over AI in onderwijs en onderzoek', 2, N'gepubliceerd', N'L04', N'AV04', NULL),
    (N'A05', N'EVT005', N'Nieuwe dataworkshop', N'Concept voor een toekomstige workshop over data', 20, N'concept', N'L03', N'AV01', NULL),
    (N'A06', N'EVT006', N'Cybersecurityworkshop', N'Praktische introductie in digitale veiligheid', 12, N'gepubliceerd', N'L01', N'AV01', NULL),
    (N'A01', N'EVT001', N'AI-workshop', N'Introductie in AI-toepassingen', 30, N'gepubliceerd', N'L01', N'AV01', N'A06');

INSERT INTO dbo.ActiviteitMoment (momentId, startDatumTijd, eindDatumTijd, activiteitId)
VALUES
    (N'M01', N'2026-11-10T09:00:00', N'2026-11-10T12:00:00', N'A01'),
    (N'M02', N'2026-11-15T14:00:00', N'2026-11-15T16:00:00', N'A02'),
    (N'M03', N'2026-11-20T09:00:00', N'2026-11-20T16:00:00', N'A03'),
    (N'M04', N'2026-11-21T09:00:00', N'2026-11-21T16:00:00', N'A03'),
    (N'M05', N'2026-11-22T09:00:00', N'2026-11-22T16:00:00', N'A03'),
    (N'M06', N'2026-12-01T10:00:00', N'2026-12-01T13:00:00', N'A04'),
    (N'M07', N'2026-12-12T13:00:00', N'2026-12-12T16:00:00', N'A06');

INSERT INTO dbo.ContactKanaal (contactkanaalId, soort, waarde, persoonId)
VALUES
    (N'CK01', N'e-mail', N'nora.devries@example.nl', N'P001'),
    (N'CK02', N'telefoon', N'0611111111', N'P001'),
    (N'CK03', N'e-mail', N'yassin.elamrani@example.nl', N'P002'),
    (N'CK04', N'e-mail', N'mila.jansen@example.nl', N'P003'),
    (N'CK05', N'telefoon', N'0622222222', N'P003'),
    (N'CK06', N'e-mail', N'amir.rahimi@example.nl', N'P004'),
    (N'CK07', N'telefoon', N'0633333333', N'P004'),
    (N'CK08', N'e-mail', N'lisa.deboer@example.nl', N'P005'),
    (N'CK09', N'e-mail', N'noah.peters@example.nl', N'P006');

INSERT INTO dbo.ActiviteitCategorie (activiteitId, categorieId)
VALUES
    (N'A01', N'C01'),
    (N'A01', N'C02'),
    (N'A02', N'C02'),
    (N'A03', N'C01'),
    (N'A04', N'C01'),
    (N'A04', N'C02'),
    (N'A05', N'C01'),
    (N'A06', N'C01'),
    (N'A06', N'C03');

INSERT INTO dbo.ActiviteitTag (activiteitId, tagId)
VALUES
    (N'A01', N'T01'),
    (N'A01', N'T02'),
    (N'A03', N'T01'),
    (N'A04', N'T02'),
    (N'A04', N'T03'),
    (N'A06', N'T01');

INSERT INTO dbo.ActiviteitPublicatie (organisatieId, activiteitId)
VALUES
    (N'O01', N'A01'),
    (N'O01', N'A03'),
    (N'O01', N'A04'),
    (N'O01', N'A06'),
    (N'O02', N'A02'),
    (N'O02', N'A04');

INSERT INTO dbo.ActiviteitOrganisatie (organisatieId, activiteitId)
VALUES
    (N'O01', N'A01'),
    (N'O01', N'A03'),
    (N'O01', N'A05'),
    (N'O01', N'A06'),
    (N'O02', N'A01'),
    (N'O02', N'A02'),
    (N'O02', N'A04'),
    (N'O03', N'A04');

INSERT INTO dbo.ActiviteitVoorwaarde (activiteitId, voorwaardeActiviteitId)
VALUES
    (N'A06', N'A01');

INSERT INTO dbo.Aanmelding (aanmeldingId, aanmelddatum, status, reserveringVervaltOp, persoonId, activiteitId, deelnamevormId)
VALUES
    (N'AM001', N'2026-09-20', N'geannuleerd', NULL, N'P001', N'A01', N'DV01'),
    (N'AM002', N'2026-09-21', N'bevestigd', NULL, N'P002', N'A01', N'DV02'),
    (N'AM003', N'2026-09-22', N'bevestigd', NULL, N'P003', N'A01', N'DV03'),
    (N'AM004', N'2026-09-23', N'bevestigd', NULL, N'P004', N'A01', N'DV03'),
    (N'AM005', N'2026-09-24', N'bevestigd', NULL, N'P001', N'A02', N'DV01'),
    (N'AM006', N'2026-09-25', N'bevestigd', NULL, N'P003', N'A02', N'DV02'),
    (N'AM007', N'2026-09-26', N'bevestigd', NULL, N'P005', N'A02', N'DV03'),
    (N'AM008', N'2026-09-27', N'bevestigd', NULL, N'P002', N'A03', N'DV01'),
    (N'AM009', N'2026-09-28', N'bevestigd', NULL, N'P004', N'A03', N'DV02'),
    (N'AM010', N'2026-09-29', N'bevestigd', NULL, N'P006', N'A03', N'DV03'),
    (N'AM011', N'2026-09-30', N'bevestigd', NULL, N'P001', N'A04', N'DV01'),
    (N'AM012', N'2026-10-01', N'bevestigd', NULL, N'P005', N'A04', N'DV03'),
    (N'AM013', N'2026-10-02', N'bevestigd', NULL, N'P001', N'A01', N'DV01'),
    (N'AM014', N'2026-10-03', N'wachtlijst', NULL, N'P006', N'A04', N'DV01'),
    (N'AM015', N'2026-10-22', N'betaling_in_afwachting', N'2026-11-05T18:00:00', N'P003', N'A06', N'DV03'),
    (N'AM016', N'2026-10-04', N'geannuleerd', NULL, N'P006', N'A02', N'DV03'),
    (N'AM017', N'2026-10-05', N'geannuleerd', NULL, N'P004', N'A02', N'DV03'),
    (N'AM018', N'2026-10-06', N'wachtlijst', NULL, N'P002', N'A04', N'DV01');

INSERT INTO dbo.Betaling (betalingId, aanmeldingId, betaalstatus)
VALUES
    (N'B001', N'AM002', N'betaald'),
    (N'B002', N'AM003', N'betaald'),
    (N'B003', N'AM004', N'betaald'),
    (N'B004', N'AM006', N'betaald'),
    (N'B005', N'AM007', N'betaald'),
    (N'B006', N'AM009', N'betaald'),
    (N'B007', N'AM010', N'betaald'),
    (N'B008', N'AM012', N'betaald'),
    (N'B009', N'AM015', N'in_behandeling'),
    (N'B010', N'AM016', N'mislukt'),
    (N'B011', N'AM017', N'terugbetaald');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
 