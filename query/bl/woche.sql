SELECT
    *,
    (tote100kWeighted / baseline) -1 AS excess
FROM
    (
        SELECT
            a.jahr,
            a.bundesland,
            sum(a.tote100kWeighted) AS tote100kWeighted,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortality a
            JOIN deutschland.baseline2021 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2021
            AND a.woche >= 40
            AND a.woche <= 45
        GROUP BY
            a.jahr,
            a.bundesland
    ) a;