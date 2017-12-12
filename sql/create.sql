/*
 * Shared tables
 */
CREATE TABLE State (
    state VARCHAR(2) PRIMARY KEY,
    description VARCHAR(100)
);

/*
 * Election Tables
 */
CREATE TABLE County (
    fips INTEGER PRIMARY KEY,
    county VARCHAR(100),
    state VARCHAR(2) REFERENCES State(state)
);

CREATE TABLE Party (
    name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Candidate (
    name VARCHAR(100) PRIMARY KEY,
    party VARCHAR(100) REFERENCES Party(name)
);

CREATE TABLE Votes (
    candidate VARCHAR(100) REFERENCES Candidate(name),
    county INTEGER REFERENCES County(fips),
    votes INTEGER,
    PRIMARY KEY(candidate, county)
);


/*
 * BRFSS Tables
 */
CREATE TABLE Class (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400)
);

CREATE TABLE Topic (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400),
    classId VARCHAR(10) REFERENCES Class(id)
);

CREATE TABLE BreakOutCategory (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400)
);

CREATE TABLE BreakOut (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400),
    breakOutCategoryId VARCHAR(10) REFERENCES BreakOutCategory(id)
);

CREATE TABLE Response (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400)
);

CREATE TABLE Question (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400),
    topicId VARCHAR(10) REFERENCES Topic(id)
);

CREATE TABLE DataValueType (
    type VARCHAR(100) PRIMARY KEY,
    unit VARCHAR(10)
);

CREATE TABLE Footnote (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10),
    description VARCHAR(400)
);

CREATE TABLE Result (
    id SERIAL PRIMARY KEY,
    breakOutId VARCHAR(10) REFERENCES BreakOut(id),
    dataValueType VARCHAR(100) REFERENCES DataValueType(type),
    footnoteId INTEGER REFERENCES Footnote(id),
    sampleSize INTEGER,
    dataValue DECIMAL(1),
    confidenceLimitLow DECIMAL(1),
    confidenceLimitHigh DECIMAL(1)
);
