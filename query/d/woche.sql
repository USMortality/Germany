SELECT
    *,
    (tote100k / baseline) -1 AS excess
FROM
    (
        SELECT
            a.jahr,
            sum(a.tote100k) AS tote100k,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortalityD a
            JOIN deutschland.baseline2020D b ON a.altersgruppe = b.altersgruppe
            AND a.woche = b.woche
        WHERE
            a.jahr = 2020
            AND a.woche >= 40
            AND a.woche <= 46
        GROUP BY
            a.jahr
    ) a;