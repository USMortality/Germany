USE deutschland;

-- Create indices for faster joins.
CREATE INDEX IF NOT EXISTS idx_all ON imp_ToteD (jahr, altersgruppe);

CREATE INDEX IF NOT EXISTS idx_all ON imp_EinwohnerD (jahr, altersgruppe);

-- Sum up the population age groups.
DROP VIEW IF EXISTS populationD;

CREATE VIEW populationD AS
SELECT
    jahr,
    altersgruppe,
    SUM(einwohner) einwohner
FROM
    imp_EinwohnerD
GROUP BY
    jahr,
    altersgruppe;

-- Combine 85+
DROP VIEW IF EXISTS toteD;

CREATE VIEW toteD AS
SELECT
    jahr,
    altersgruppe,
    woche,
    sum(tote) AS "tote"
FROM
    (
        SELECT
            jahr,
            CASE
                WHEN altersgruppe IN ("85-90", "90-95", "95") THEN "85"
                ELSE altersgruppe
            END AS "altersgruppe",
            woche,
            tote
        FROM
            imp_ToteD t
    ) a
GROUP BY
    jahr,
    altersgruppe,
    woche;

-- Calculate mortality per 100k.
DROP VIEW IF EXISTS mortalityD;

CREATE VIEW mortalityD AS
SELECT
    t.*,
    concat(t.jahr, "/", ceil(cast(woche AS integer) / 13)) AS jahr_quartal,
    t.tote / (e.einwohner / 100000) AS "tote100k"
FROM
    toteD t
    JOIN populationD e ON t.jahr = e.jahr
    AND t.altersgruppe = e.altersgruppe;

-- Baseline 2020
DROP VIEW IF EXISTS baselineD;

CREATE VIEW baselineD AS
SELECT
    altersgruppe,
    woche,
    AVG(tote100k) AS 'baseline'
FROM
    mortalityD a
WHERE
    a.jahr IN (2015, 2016, 2017, 2018, 2019)
GROUP BY
    altersgruppe,
    woche;