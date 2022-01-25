SELECT
    jahr,
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortalityD a
WHERE
    jahr <= 2022
    AND woche <= 52
GROUP BY
    a.jahr;