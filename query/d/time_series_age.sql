SELECT
    jahr,
    lpad(a.woche, 2, 0) AS "woche",
    a.altersgruppe,
    a.tote100kWeighted,
    baseline,
    a.tote100kWeighted / baseline -1 AS "excess"
FROM
    (
        SELECT
            jahr,
            woche,
            altersgruppe,
            sum(tote100kWeighted) AS tote100kWeighted
        FROM
            deutschland.mortalityD a
        WHERE
            jahr IN (2020, 2021)
        GROUP BY
            jahr,
            woche,
            altersgruppe
    ) a
    JOIN (
        SELECT
            woche,
            altersgruppe,
            avg(tote100kWeighted) AS baseline
        FROM
            deutschland.mortalityD a
        WHERE
            jahr IN (2015, 2016, 2017, 2018, 2019)
        GROUP BY
            jahr,
            woche,
            altersgruppe
    ) b ON a.woche = b.woche
    AND a.altersgruppe = b.altersgruppe
ORDER BY
    jahr,
    woche,
    altersgruppe;