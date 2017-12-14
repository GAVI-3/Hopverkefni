CREATE OR REPLACE VIEW primary_votes_by_state
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

CREATE OR REPLACE VIEW total_primary_votes
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


CREATE OR REPLACE VIEW general_votes_by_state
AS
SELECT
    s.state,
    s.description,
    SUM(gv.votes_dem) as total_votes_dem,
    SUM(gv.votes_gop) as total_votes_gop,
    SUM(gv.total_votes) as total_votes,
    round((SUM(gv.votes_dem)::decimal / SUM(gv.total_votes) * 100), 2) as percentage_dem,
    round((SUM(gv.votes_gop)::decimal / SUM(gv.total_votes) * 100), 2) as percentage_gop
FROM
    GeneralVotes gv
    JOIN States s ON s.state = gv.state
GROUP BY
    s.state,
    s.description;


CREATE OR REPLACE VIEW brfss_combined
AS
SELECT
    r.year,
    s.state,
    s.description as state_name,
    c.description as class,
    t.description as topic,
    q.description as question,
    re.description as response,
    b.description as break_out,
    bc.description as break_out_category,
    r.sampleSize,
    r.dataValue,
    r.confidenceLimitLow,
    r.confidenceLimitHigh,
    d.unit,
    d.type,
    r.footnoteSymbol,
    r.footnote,
    c.id as classId,
    t.id as topicId,
    b.id as breakOutId,
    bc.id as breakOutCategoryId,
    q.id as questionId,
    re.id as responseId
FROM
    Results r
    JOIN States s ON s.state = r.state
    JOIN Questions q ON q.id = r.questionId
    JOIN Topics t ON t.id = q.topicId
    JOIN Classes c ON c.id = t.classId
    JOIN Responses re ON re.id = r.responseId
    JOIN BreakOuts b ON b.id = r.breakOutId
    JOIN BreakOutCategories bc ON bc.id = b.breakOutCategoryId
    JOIN DataValueTypes d ON d.type = r.dataValueType;
