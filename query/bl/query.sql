-- Create indices for faster joins.
CREATE INDEX IF NOT EXISTS idx_all ON deutschland.imp_Tote (bundesland, jahr, altersgruppe);

CREATE INDEX IF NOT EXISTS idx_all ON deutschland.imp_Einwohner (bundesland, jahr, altersgruppe);

-- Sum up the population age groups.
DROP VIEW IF EXISTS population;

CREATE VIEW population AS
SELECT
    bundesland,
    jahr,
    altersgruppe,
    SUM(einwohner) AS "einwohner"
FROM
    deutschland.imp_Einwohner
GROUP BY
    jahr,
    altersgruppe,
    bundesland;

-- Calculate mortality per 100k.
DROP VIEW IF EXISTS mortality;

CREATE VIEW mortality AS
SELECT
    a.jahr,
    a.bundesland,
    a.altersgruppe,
    a.woche,
    concat(a.jahr, "/", ceil(cast(woche AS integer) / 13)) AS jahr_quartal,
    tote,
    a.tote / (b.einwohner / 100000) AS "tote100k",
    (a.tote / (b.einwohner / 100000)) * weight AS "tote100kWeighted"
FROM
    deutschland.imp_Tote a
    JOIN population b ON a.jahr = b.jahr
    AND a.bundesland = b.bundesland
    AND a.altersgruppe = b.altersgruppe
    JOIN imp_EinwohnerStandard c ON a.altersgruppe = c.altersgruppe;

-- Baseline 2020
DROP VIEW IF EXISTS baseline2020;

CREATE VIEW baseline2020 AS
SELECT
    bundesland,
    altersgruppe,
    woche,
    AVG(tote100kWeighted) AS baseline -- Adjust for 53 weeks
FROM
    mortality a
WHERE
    a.jahr IN (2015, 2016, 2017, 2018, 2019)
GROUP BY
    altersgruppe,
    bundesland,
    woche;

-- Baseline 2021
DROP VIEW IF EXISTS baseline2021;

CREATE VIEW baseline2021 AS
SELECT
    bundesland,
    altersgruppe,
    woche,
    AVG(tote100kWeighted) AS baseline
FROM
    mortality a
WHERE
    a.jahr IN (2015, 2016, 2017, 2018, 2019)
GROUP BY
    altersgruppe,
    bundesland,
    woche;

-- Baseline 2022
DROP VIEW IF EXISTS baseline2022;

CREATE VIEW baseline2022 AS
SELECT
    bundesland,
    altersgruppe,
    woche,
    AVG(tote100kWeighted) AS baseline
FROM
    mortality a
WHERE
    a.jahr IN (2015, 2016, 2017, 2018, 2019)
    AND woche <= (
        -- Limit to last data week
        SELECT
            max(cast(woche AS integer))
        FROM
            mortality
        WHERE
            jahr IN (
                SELECT
                    max(cast(jahr AS integer))
                FROM
                    mortality
            )
            AND tote100k > 0
    )
GROUP BY
    altersgruppe,
    bundesland,
    woche;