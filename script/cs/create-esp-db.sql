DROP TABLE
    IF EXISTS tLookupService ;
DROP TABLE
    IF EXISTS tProviderGrid;
DROP TABLE
    IF EXISTS tServiceCfg ;
DROP TABLE
    IF EXISTS tServiceCost ;
DROP TABLE
    IF EXISTS tServiceGrid ;
DROP TABLE
    IF EXISTS tService ;
DROP TABLE
    IF EXISTS tProvider;
CREATE TABLE
    tLookupService
    (
        ServiceCode NVARCHAR(20) NOT NULL,
        ServiceDesc NVARCHAR(50) ,
        Sort INT,
        CategoryCode NVARCHAR(6) ,
        PRIMARY KEY (ServiceCode)
    );
CREATE TABLE
    tProvider
    (
        ProviderID INT NOT NULL,
        Name NVARCHAR(80) ,
        TypeAgency NVARCHAR(35) ,
        Contact NVARCHAR(40) ,
        ContactTitle NVARCHAR(35) ,
        LocAddress NVARCHAR(80) ,
        LocCity NVARCHAR(25) ,
        LocState NVARCHAR(2) ,
        LocZipCode NVARCHAR(5) ,
        LocZipPlus4 NVARCHAR(4) ,
        MailAddress NVARCHAR(80) ,
        MailCity NVARCHAR(25) ,
        MailState NVARCHAR(2) ,
        MailZipCode NVARCHAR(5) ,
        MailZipPlus4 NVARCHAR(4) ,
        County NVARCHAR(25) ,
        AreaCode1 NVARCHAR(3) ,
        Phone1 NVARCHAR(15) ,
        AreaCode2 NVARCHAR(3) ,
        Phone2 NVARCHAR(15) ,
        Phone2TTY BIT DEFAULT 0 NOT NULL,
        AreaCodeFax NVARCHAR(3) ,
        PhoneFax NVARCHAR(8) ,
        Email TEXT ,
        URL TEXT ,
        Inactive BIT DEFAULT 0 NOT NULL,
        ReasonInactive NVARCHAR(35) ,
        LocalID NVARCHAR(15) ,
        TaxID NVARCHAR(15) ,
        DateAdded DATETIME,
        DateUpdated DATETIME,
        Comments TEXT ,
        Longitude INT,
        Latitude INT,
        Override BIT DEFAULT 0 NOT NULL,
        StateFIPS NVARCHAR(2) ,
        CountyFIPS NVARCHAR(3) ,
        Xid INT,
        PRIMARY KEY (ProviderID)
    );
CREATE TABLE
    tProviderGrid
    (
        InfoID INT NOT NULL,
        ProviderID INT,
        Grp NVARCHAR(6) ,
        Item NVARCHAR(35) ,
        PRIMARY KEY (InfoID)
    );
CREATE TABLE
    tService
    (
        ServiceID INT NOT NULL,
        OrgName NVARCHAR(80) ,
        ProviderID INT,
        ServiceCode NVARCHAR(6) ,
        Contact NVARCHAR(40) ,
        ContactTitle NVARCHAR(35) ,
        TypeAgency NVARCHAR(35) ,
        Inactive BIT DEFAULT 0 NOT NULL,
        ReasonInactive NVARCHAR(35) ,
        LocAddress NVARCHAR(80) ,
        LocCity NVARCHAR(25) ,
        LocState NVARCHAR(2) ,
        LocZipCode NVARCHAR(5) ,
        LocZipPlus4 NVARCHAR(4) ,
        MailAddress NVARCHAR(80) ,
        MailCity NVARCHAR(25) ,
        MailState NVARCHAR(2) ,
        MailZipCode NVARCHAR(5) ,
        MailZipPlus4 NVARCHAR(4) ,
        StateFIPS NVARCHAR(2) ,
        CountyFIPS NVARCHAR(3) ,
        AreaCode1 NVARCHAR(3) ,
        Phone1 NVARCHAR(15) ,
        AreaCode2 NVARCHAR(3) ,
        Phone2 NVARCHAR(15) ,
        Phone2TTY BIT DEFAULT 0 NOT NULL,
        AreaCodeFax NVARCHAR(3) ,
        PhoneFax NVARCHAR(8) ,
        Email TEXT ,
        URL TEXT ,
        DateAdded DATETIME,
        DateUpdated DATETIME,
        DateReview DATETIME,
        ReviewedBy NVARCHAR(35) ,
        DataFrom NVARCHAR(35) ,
        LicenseID NVARCHAR(15) ,
        DateLicense DATETIME,
        Latitude INT,
        Longitude INT,
        Override BIT DEFAULT 0 NOT NULL,
        Capacity INT,
        Vacancies INT,
        Waiting INT,
        TimeSun1 DATETIME,
        TimeSun2 DATETIME,
        TimeMon1 DATETIME,
        TimeMon2 DATETIME,
        TimeTue1 DATETIME,
        TimeTue2 DATETIME,
        TimeWed1 DATETIME,
        TimeWed2 DATETIME,
        TimeThu1 DATETIME,
        TimeThu2 DATETIME,
        TimeFri1 DATETIME,
        TimeFri2 DATETIME,
        TimeSat1 DATETIME,
        TimeSat2 DATETIME,
        Sun24 BIT DEFAULT 0 NOT NULL,
        Mon24 BIT DEFAULT 0 NOT NULL,
        Tue24 BIT DEFAULT 0 NOT NULL,
        Wed24 BIT DEFAULT 0 NOT NULL,
        Thu24 BIT DEFAULT 0 NOT NULL,
        Fri24 BIT DEFAULT 0 NOT NULL,
        Sat24 BIT DEFAULT 0 NOT NULL,
        Cfg7 NVARCHAR(35) ,
        Cfg8 NVARCHAR(35) ,
        Cfg9 NVARCHAR(35) ,
        Cfg10 NVARCHAR(35) ,
        Comments TEXT ,
        LocalComments TEXT ,
        CostComments TEXT ,
        Xid INT,
        Checked BIT DEFAULT 0 NOT NULL,
        ServiceRefID NVARCHAR(20) ,
        County NVARCHAR(35) ,
        PRIMARY KEY (ServiceID)
    );
CREATE TABLE
    tServiceCfg
    (
        InfoID INT NOT NULL,
        ServiceID INT,
        CfgNum NVARCHAR(2) ,
        Item NVARCHAR(75) ,
        PRIMARY KEY (InfoID)
    );
CREATE TABLE
    tServiceCost
    (
        CostID INT NOT NULL,
        ServiceID INT,
        CostType NVARCHAR(35) ,
        Amount DECIMAL(9,2),
        CostUnit NVARCHAR(15) ,
        PRIMARY KEY (CostID)
    );
CREATE TABLE
    tServiceGrid
    (
        InfoID INT NOT NULL,
        ServiceID INT,
        Grp NVARCHAR(15) ,
        Item NVARCHAR(35) ,
        PRIMARY KEY (InfoID)
    );
ALTER TABLE
    tProviderGrid ADD FOREIGN KEY (ProviderID) REFERENCES tProvider (ProviderID)
ON
DELETE
    CASCADE
ON
UPDATE
    CASCADE;
ALTER TABLE
    tService ADD FOREIGN KEY (ProviderID) REFERENCES tProvider (ProviderID);
ALTER TABLE
    tServiceCfg ADD FOREIGN KEY (ServiceID) REFERENCES tService (ServiceID)
ON
DELETE
    CASCADE;
ALTER TABLE
    tServiceCost ADD FOREIGN KEY (ServiceID) REFERENCES tService (ServiceID)
ON
DELETE
    CASCADE;
ALTER TABLE
    tServiceGrid ADD FOREIGN KEY (ServiceID) REFERENCES tService (ServiceID)
ON
DELETE
    CASCADE;
