USE [master];
GO

IF DB_ID(N'CampusEventDesk') IS NOT NULL
BEGIN
    ALTER DATABASE [CampusEventDesk]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [CampusEventDesk];
END;
GO

IF DB_ID(N'CampusEventDesk_Opdracht2') IS NOT NULL
BEGIN
    ALTER DATABASE [CampusEventDesk_Opdracht2]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [CampusEventDesk_Opdracht2];
END;
GO

IF DB_ID(N'CampusEventDesk_Opdracht3') IS NOT NULL
BEGIN
    ALTER DATABASE [CampusEventDesk_Opdracht3]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [CampusEventDesk_Opdracht3];
END;
GO

IF DB_ID(N'CampusEventDesk_Opdracht4') IS NOT NULL
BEGIN
    ALTER DATABASE [CampusEventDesk_Opdracht4]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [CampusEventDesk_Opdracht4];
END;
GO

IF DB_ID(N'CampusEventDesk_Opdracht5') IS NOT NULL
BEGIN
    ALTER DATABASE [CampusEventDesk_Opdracht5]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [CampusEventDesk_Opdracht5];
END;
GO

IF DB_ID(N'CampusEventDesk_Opdracht6') IS NOT NULL
BEGIN
    ALTER DATABASE [CampusEventDesk_Opdracht6]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [CampusEventDesk_Opdracht6];
END;
GO