-- Create the Digital Humanities Archive Database
CREATE DATABASE DigitalHumanitiesArchive;
USE DigitalHumanitiesArchive;

-- Table: Artifacts
CREATE TABLE Artifacts (
    ArtifactID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Period VARCHAR(100),
    Origin VARCHAR(255),
    InstitutionID INT,
    CollectionID INT
);

-- Table: Historical_Texts
CREATE TABLE Historical_Texts (
    TextID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    Year INT,
    Language VARCHAR(100),
    InstitutionID INT,
    CollectionID INT
);

-- Table: Researchers
CREATE TABLE Researchers (
    ResearcherID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Affiliation VARCHAR(255),
    Email VARCHAR(255) UNIQUE
);

-- Table: Institutions
CREATE TABLE Institutions (
    InstitutionID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255),
    Type VARCHAR(100)
);

-- Table: Exhibitions
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    InstitutionID INT
);

-- Table: Public_Engagements
CREATE TABLE Public_Engagements (
    EngagementID INT PRIMARY KEY AUTO_INCREMENT,
    ExhibitionID INT,
    VisitorCount INT,
    Feedback TEXT
);

-- Table: Collections
CREATE TABLE Collections (
    CollectionID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Theme VARCHAR(255)
);
