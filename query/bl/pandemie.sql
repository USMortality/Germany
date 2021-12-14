SELECT
    bundesland,
    (sum(tote100kWeighted) / sum(baseline)) -1 AS excess
FROM
    (
        SELECT
            a.bundesland,
            a.woche,
            sum(a.tote100kWeighted) AS tote100kWeighted,
            sum(b.baseline) AS baseline
        FROM
            mortality a
            JOIN baseline2020 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2020
        GROUP BY
            a.bundesland,
            a.jahr,
            a.woche
        UNION
        ALL -- 2021
        SELECT
            a.bundesland,
            a.woche,
            sum(a.tote100kWeighted) AS tote100kWeighted,
            sum(b.baseline) AS baseline
        FROM
            mortality a
            JOIN baseline2021 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2021
        GROUP BY
            a.bundesland,
            a.jahr,
            a.woche
    ) a
GROUP BY
    bundesland;