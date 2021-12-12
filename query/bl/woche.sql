SELECT
    *,
    (tote100k / baseline) -1 AS excess
FROM
    (
        SELECT
            a.jahr,
            a.bundesland,
            sum(a.tote100k) AS tote100k,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortality a
            JOIN deutschland.baseline2021 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2021
            AND a.woche >= 40
            AND a.woche <= 44
        GROUP BY
            a.jahr,
            a.bundesland
    ) a;