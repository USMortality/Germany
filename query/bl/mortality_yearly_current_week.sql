SELECT
    max(cast(woche AS INTEGER)) INTO @max_week
FROM
    deutschland.mortality a
WHERE
    jahr = 2022
    AND tote > 0;

SELECT
    bundesland,
    jahr,
    @max_week AS "max_week",
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortality a
WHERE
    woche <= @max_week
GROUP BY
    a.bundesland,
    a.jahr;