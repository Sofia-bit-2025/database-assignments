
USE CampusEventDesk_Opdracht3;
GO

SELECT
    AM.aanmeldingId,
    P.persoonId,
    P.naam AS deelnemer,
    A.activiteitId,
    A.code AS activiteitCode,
    A.titel AS activiteit,
    AM.aanmelddatum,
    AM.status
FROM dbo.Aanmelding AS AM
INNER JOIN dbo.Persoon AS P
    ON AM.persoonId = P.persoonId
INNER JOIN dbo.Activiteit AS A
    ON AM.activiteitId = A.activiteitId
ORDER BY AM.aanmeldingId;
GO

SELECT
    AM.aanmeldingId,
    P.naam AS deelnemer,
    A.code AS activiteitCode,
    A.titel AS activiteit,
    DV.naam AS deelnamevorm,
    AM.status
FROM dbo.Aanmelding AS AM
INNER JOIN dbo.Persoon AS P
    ON AM.persoonId = P.persoonId
INNER JOIN dbo.Activiteit AS A
    ON AM.activiteitId = A.activiteitId
INNER JOIN dbo.DeelnameVorm AS DV
    ON AM.deelnamevormId = DV.deelnamevormId
ORDER BY AM.aanmeldingId;
GO

SELECT
    A.code AS activiteitCode,
    A.titel AS activiteit,
    L.aanduiding AS locatie,
    AV.naam AS activiteitsvorm,
    M.momentId,
    M.startDatumTijd,
    M.eindDatumTijd
FROM dbo.Activiteit AS A
INNER JOIN dbo.Locatie AS L
    ON A.locatieId = L.locatieId
INNER JOIN dbo.Activiteitsvorm AS AV
    ON A.activiteitsvormId = AV.activiteitsvormId
INNER JOIN dbo.ActiviteitMoment AS M
    ON A.activiteitId = M.activiteitId
ORDER BY A.code, M.startDatumTijd, M.momentId;
GO

SELECT
    A.code AS activiteitCode,
    A.titel AS activiteit,
    A.publicatieStatus,
    AM.aanmeldingId,
    AM.status AS aanmeldStatus
FROM dbo.Activiteit AS A
LEFT JOIN dbo.Aanmelding AS AM
    ON A.activiteitId = AM.activiteitId
ORDER BY A.code, AM.aanmeldingId;
GO

SELECT
    AM.aanmeldingId,
    P.naam AS deelnemer,
    A.code AS activiteitCode,
    A.titel AS activiteit,
    DV.naam AS deelnamevorm,
    AM.status AS aanmeldStatus,
    B.betalingId,
    B.betaalstatus
FROM dbo.Aanmelding AS AM
INNER JOIN dbo.Persoon AS P
    ON AM.persoonId = P.persoonId
INNER JOIN dbo.Activiteit AS A
    ON AM.activiteitId = A.activiteitId
INNER JOIN dbo.DeelnameVorm AS DV
    ON AM.deelnamevormId = DV.deelnamevormId
LEFT JOIN dbo.Betaling AS B
    ON AM.aanmeldingId = B.aanmeldingId
ORDER BY AM.aanmeldingId;
GO

SELECT
    O.code AS oorspronkelijkeCode,
    O.titel AS oorspronkelijkeActiviteit,
    V.code AS vervolgCode,
    V.titel AS vervolgactiviteit
FROM dbo.Activiteit AS O
INNER JOIN dbo.Activiteit AS V
    ON O.vervolgActiviteitId = V.activiteitId
ORDER BY O.code, V.code;
GO

SELECT
    A.code AS activiteitCode,
    A.titel AS activiteit,
    COUNT(AM.aanmeldingId) AS aantalAanmeldpogingen
FROM dbo.Activiteit AS A
LEFT JOIN dbo.Aanmelding AS AM
    ON A.activiteitId = AM.activiteitId
GROUP BY A.activiteitId, A.code, A.titel
ORDER BY A.code;
GO

SELECT
    DV.deelnamevormId,
    DV.naam AS deelnamevorm,
    COUNT(AM.aanmeldingId) AS aantalAanmeldpogingen
FROM dbo.DeelnameVorm AS DV
INNER JOIN dbo.Aanmelding AS AM
    ON DV.deelnamevormId = AM.deelnamevormId
GROUP BY DV.deelnamevormId, DV.naam
HAVING COUNT(AM.aanmeldingId) > 3
ORDER BY aantalAanmeldpogingen DESC, DV.deelnamevormId;
GO
