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

CREATE TABLE GeneralVotes (
    id SERIAL PRIMARY KEY,
    votes_dem INTEGER,
    votes_gop INTEGER,
    total_votes INTEGER,
    per_dem DECIMAL(13, 12),
    per_gop DECIMAL(13, 12),
    diff INTEGER,
    per_point_diff DECIMAL(4, 2),
    state VARCHAR(2) REFERENCES States(state),
    county INTEGER REFERENCES Counties(fips)
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
    year INTEGER,
    state VARCHAR(2) REFERENCES States(state),
    questionId VARCHAR(10) REFERENCES Questions(id),
    responseId VARCHAR(10) REFERENCES Responses(id),
    breakOutId VARCHAR(10) REFERENCES BreakOuts(id),
    dataValueType VARCHAR(100) REFERENCES DataValueTypes(type),
    sampleSize INTEGER,
    dataValue DECIMAL(5, 2),
    confidenceLimitLow DECIMAL(5, 2),
    confidenceLimitHigh DECIMAL(5, 2),
    footnoteSymbol VARCHAR(10),
    footnote VARCHAR(400)
);
