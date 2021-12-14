SELECT
    jahr,
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortalityD a
WHERE
    jahr <= 2020
GROUP BY
    a.jahr;