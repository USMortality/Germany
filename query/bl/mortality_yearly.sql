SELECT
    bundesland,
    jahr,
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortality a
WHERE
    jahr <= 2021
GROUP BY
    a.bundesland,
    a.jahr;