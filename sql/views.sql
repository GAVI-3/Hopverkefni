CREATE OR REPLACE VIEW votes_by_state
AS
SELECT
    s.description,
    v.candidate,
    ca.party,
    SUM(v.votes) as total_votes
FROM
    Votes v
    JOIN Counties c ON c.fips = v.county
    JOIN States s ON s.state = c.state
    JOIN Candidates ca ON ca.name = v.candidate
GROUP BY
    s.description,
    v.candidate,
    ca.party;

CREATE OR REPLACE VIEW total_votes
AS
SELECT
    c.name,
    c.party,
    t1.total_votes,
    t2.total_party_votes,
    round((t1.total_votes::decimal / t2.total_party_votes) * 100, 2) as percentage
FROM
    Candidates c
    JOIN (SELECT
              v.candidate,
              SUM(v.votes) as total_votes
          FROM
              Votes v
          GROUP BY
              v.candidate
          ORDER BY
              total_votes) t1 ON t1.candidate = c.name
    JOIN (SELECT
              c.party,
              SUM(v.votes) as total_party_votes
          FROM
              Votes v
              JOIN Candidates c ON c.name = v.candidate
          GROUP BY
              c.party) t2 ON t2.party = c.party;
