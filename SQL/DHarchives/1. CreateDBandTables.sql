-- Table: Institutions (Must be created first for FK reference)
CREATE TABLE Institutions (
    InstitutionID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255),
    Type VARCHAR(100)
);

-- Table: Collections (Must be created before referencing in Artifacts and Historical_Texts)
CREATE TABLE Collections (
    CollectionID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Theme VARCHAR(255)
);

-- Table: Artifacts
CREATE TABLE Artifacts (
    ArtifactID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Period VARCHAR(100),
    Origin VARCHAR(255),
    InstitutionID INT,
    CollectionID INT,
    FOREIGN KEY (InstitutionID) REFERENCES Institutions(InstitutionID) ON DELETE CASCADE,
    FOREIGN KEY (CollectionID) REFERENCES Collections(CollectionID) ON DELETE SET NULL
);

-- Table: Historical_Texts
CREATE TABLE Historical_Texts (
    TextID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    Year INT,
    Language VARCHAR(100),
    InstitutionID INT,
    CollectionID INT,
    FOREIGN KEY (InstitutionID) REFERENCES Institutions(InstitutionID) ON DELETE CASCADE,
    FOREIGN KEY (CollectionID) REFERENCES Collections(CollectionID) ON DELETE SET NULL
);

-- Table: Researchers
CREATE TABLE Researchers (
    ResearcherID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Affiliation VARCHAR(255),
    Email VARCHAR(255) UNIQUE
);

-- Table: Exhibitions (Must be created before Public_Engagements and Exhibition_Artifacts)
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    InstitutionID INT,
    FOREIGN KEY (InstitutionID) REFERENCES Institutions(InstitutionID) ON DELETE CASCADE
);

-- Table: Public_Engagements
CREATE TABLE Public_Engagements (
    EngagementID INT PRIMARY KEY AUTO_INCREMENT,
    ExhibitionID INT,
    VisitorCount INT,
    Feedback TEXT,
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions(ExhibitionID) ON DELETE CASCADE
);

-- Junction Table: Researcher_Artifacts
CREATE TABLE Researcher_Artifacts (
    ResearcherID INT,
    ArtifactID INT,
    PRIMARY KEY (ResearcherID, ArtifactID),
    FOREIGN KEY (ResearcherID) REFERENCES Researchers(ResearcherID) ON DELETE CASCADE,
    FOREIGN KEY (ArtifactID) REFERENCES Artifacts(ArtifactID) ON DELETE CASCADE
);

-- Junction Table: Researcher_Texts
CREATE TABLE Researcher_Texts (
    ResearcherID INT,
    TextID INT,
    PRIMARY KEY (ResearcherID, TextID),
    FOREIGN KEY (ResearcherID) REFERENCES Researchers(ResearcherID) ON DELETE CASCADE,
    FOREIGN KEY (TextID) REFERENCES Historical_Texts(TextID) ON DELETE CASCADE
);

-- Junction Table: Exhibition_Artifacts
CREATE TABLE Exhibition_Artifacts (
    ExhibitionID INT,
    ArtifactID INT,
    PRIMARY KEY (ExhibitionID, ArtifactID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions(ExhibitionID) ON DELETE CASCADE,
    FOREIGN KEY (ArtifactID) REFERENCES Artifacts(ArtifactID) ON DELETE CASCADE
);

-- Junction Table: Researcher_Exhibitions
CREATE TABLE Researcher_Exhibitions (
    ResearcherID INT,
    ExhibitionID INT,
    PRIMARY KEY (ResearcherID, ExhibitionID),
    FOREIGN KEY (ResearcherID) REFERENCES Researchers(ResearcherID) ON DELETE CASCADE,
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions(ExhibitionID) ON DELETE CASCADE
);
