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
            JOIN deutschland.baselineD b ON
            AND a.woche = b.woche
        WHERE
            a.jahr IN (2020, 2021)
            AND a.woche >= 40
            AND a.woche <= 46
        GROUP BY
            a.jahr
    ) a;