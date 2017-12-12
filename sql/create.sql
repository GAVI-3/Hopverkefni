/*
 * Shared tables
 */
CREATE TABLE States (
    state VARCHAR(2) PRIMARY KEY,
    description VARCHAR(100)
);

/*
 * Election Tables
 */
CREATE TABLE Counties (
    fips INTEGER PRIMARY KEY,
    county VARCHAR(100),
    state VARCHAR(2) REFERENCES States(state)
);

CREATE TABLE Parties (
    name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Candidates (
    name VARCHAR(100) PRIMARY KEY,
    party VARCHAR(100) REFERENCES Parties(name)
);

CREATE TABLE Votes (
    candidate VARCHAR(100) REFERENCES Candidates(name),
    county INTEGER REFERENCES Counties(fips),
    votes INTEGER,
    PRIMARY KEY(candidate, county)
);


/*
 * BRFSS Tables
 */
CREATE TABLE Classes (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400)
);

CREATE TABLE Topics (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400),
    classId VARCHAR(10) REFERENCES Classes(id)
);

CREATE TABLE BreakOutCategories (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400)
);

CREATE TABLE BreakOuts (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400),
    breakOutCategoryId VARCHAR(10) REFERENCES BreakOutCategories(id)
);

CREATE TABLE Responses (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400)
);

CREATE TABLE Questions (
    id VARCHAR(10) PRIMARY KEY,
    description VARCHAR(400),
    topicId VARCHAR(10) REFERENCES Topics(id)
);

CREATE TABLE DataValueTypes (
    type VARCHAR(100) PRIMARY KEY,
    unit VARCHAR(10)
);

CREATE TABLE Results (
    id SERIAL PRIMARY KEY,
    breakOutId VARCHAR(10) REFERENCES BreakOuts(id),
    dataValueType VARCHAR(100) REFERENCES DataValueTypes(type),
    footnoteId INTEGER REFERENCES Footnotes(id),
    sampleSize INTEGER,
    dataValue DECIMAL(1),
    confidenceLimitLow DECIMAL(1),
    confidenceLimitHigh DECIMAL(1),
    symbol VARCHAR(10),
    description VARCHAR(400)
);
