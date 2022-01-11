SELECT
    jahr,
    lpad(a.woche, 2, 0) AS "woche",
    a.tote100kWeighted,
    baseline,
    a.tote100kWeighted / baseline -1 AS "excess",
    a.tote100kWeighted - baseline AS "excessAbs"
FROM
    (
        SELECT
            jahr,
            woche,
            sum(tote100kWeighted) AS tote100kWeighted
        FROM
            deutschland.mortalityD a
        WHERE
            jahr IN (2020, 2021)
        GROUP BY
            jahr,
            woche
    ) a
    JOIN (
        SELECT
            woche,
            sum(tote100kWeighted) / 5 AS baseline
        FROM
            deutschland.mortalityD a
        WHERE
            jahr IN (2015, 2016, 2017, 2018, 2019)
        GROUP BY
            woche
    ) b ON a.woche = b.woche
ORDER BY
    jahr,
    woche;