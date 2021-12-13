SELECT
    bundesland,
    jahr,
    sum(tote100kWeighted)
FROM
    deutschland.mortality a
WHERE
    jahr <= 2020
GROUP BY
    a.bundesland,
    a.jahr;