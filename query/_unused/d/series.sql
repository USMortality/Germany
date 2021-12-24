SELECT
    a.jahr,
    concat(a.jahr, "/", lpad(a.woche, 2, 0)) AS jahr_woche,
    @tote := sum(a.tote) AS tote,
    b.baseline
FROM
    deutschland.mortalityD a
    JOIN deutschland.baselineD b ON a.woche = b.woche
WHERE
    a.jahr IN (2020, 2021)
    AND a.altersgruppe <> "Insgesamt"
GROUP BY
    a.jahr,
    a.woche
ORDER BY
    jahr_woche;

SELECT
    *
FROM
    populationD c
WHERE
    altersgruppe = "Insgesamt"
    AND jahr IN (2020, 2021);