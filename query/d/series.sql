SELECT
    concat(jahr, "/", woche) AS jahr_woche,
    tote100k,
    baseline
FROM
    (
        SELECT
            a.jahr,
            lpad(a.woche, 2, 0) AS 'woche',
            sum(a.tote100k) AS tote100k,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortalityD a
            JOIN deutschland.baselineD b ON a.altersgruppe = b.altersgruppe
            AND a.woche = b.woche
        WHERE
            a.jahr IN (2020, 2021)
            AND a.altersgruppe <> "Insgesamt"
        GROUP BY
            a.jahr,
            a.woche
    ) a
ORDER BY
    jahr,
    woche;