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

-- Calculate weights
DROP VIEW IF EXISTS populationWeights;

CREATE VIEW populationWeights AS
SELECT
    a.altersgruppe,
    a.einwohner / b.gesamt AS "weight"
FROM
    populationD a
    JOIN (
        SELECT
            jahr,
            altersgruppe,
            einwohner AS "gesamt"
        FROM
            populationD
        WHERE
            altersgruppe = "Insgesamt"
            AND jahr = 2021
    ) b ON a.jahr = b.jahr
WHERE
    a.altersgruppe <> "Insgesamt";

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
    a.jahr,
    a.altersgruppe,
    a.woche,
    concat(a.jahr, "/", ceil(cast(woche AS integer) / 13)) AS jahr_quartal,
    tote,
    a.tote / (b.einwohner / 100000) AS "tote100k",
    (a.tote / (b.einwohner / 100000)) * weight AS "tote100kWeighted"
FROM
    toteD a
    JOIN populationD b ON a.jahr = b.jahr
    AND a.altersgruppe = b.altersgruppe
    JOIN populationWeights c ON a.altersgruppe = c.altersgruppe;

-- Baseline 2020
DROP VIEW IF EXISTS baselineD;

CREATE VIEW baselineD AS
SELECT
    woche,
    baseline100kWeighted * (
        SELECT
            einwohner
        FROM
            populationD
        WHERE
            jahr = 2020
            AND altersgruppe = "Insgesamt"
    ) / 100000 AS baseline
FROM
    (
        SELECT
            woche,
            AVG(tote100kWeighted) AS 'baseline100kWeighted'
        FROM
            mortalityD a
        WHERE
            a.jahr IN (2015, 2016, 2017, 2018, 2019)
            AND altersgruppe <> "Insgesamt"
        GROUP BY
            woche
    ) a;