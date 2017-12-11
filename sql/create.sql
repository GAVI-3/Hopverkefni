CREATE State (
    state VARCHAR(2) PRIMARY KEY,
    description VARCHAR(100)
);

CREATE County (
    fips INTEGER PRIMARY KEY,
    county VARCHAR(100),
    state VARCHAR(2) REFERENCES State(state)
);

CREATE Party (
    name VARCHAR(100) PRIMARY KEY
);

CREATE Candidate (
    name VARCHAR(100) PRIMARY KEY,
    party VARCHAR(100) REFERENCES Party(name)
);

CREATE Votes (
    candidate VARCHAR(100) REFERENCES Candidate(name),
    county INTEGER REFERENCES County(fips),
    votes INTEGER,
    PRIMARY KEY(candidate, county)
);
