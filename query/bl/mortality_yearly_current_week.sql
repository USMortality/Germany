SELECT
    bundesland,
    jahr,
    sum(tote100kWeighted)
FROM
    deutschland.mortality a
WHERE
    woche <= (
        SELECT
            max(cast(woche AS INTEGER))
        FROM
            deutschland.mortality a
        WHERE
            jahr = 2021
            AND tote > 0
    )
GROUP BY
    a.bundesland,
    a.jahr;

-- Diff for 2020
SELECT
    bundesland,
    jahr,
    sum(tote100kWeighted)
FROM
    deutschland.mortality a
WHERE
    jahr = 2020
    AND woche >= 44
    AND woche <= 52
GROUP BY
    a.jahr;