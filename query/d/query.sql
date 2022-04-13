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
    a.jahr,
    a.altersgruppe,
    a.woche,
    concat(a.jahr, "/", ceil(cast(woche AS integer) / 13)) AS jahr_quartal,
    tote,
    a.tote / (b.einwohner / 100000) AS "tote100k",
    (a.tote / (b.einwohner / 100000)) * c.weight AS "tote100kWeighted"
FROM
    toteD a
    JOIN populationD b ON a.jahr = b.jahr
    AND a.altersgruppe = b.altersgruppe
    JOIN imp_EinwohnerStandardD c ON a.altersgruppe = c.altersgruppe;