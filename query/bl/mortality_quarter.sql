SELECT
    bundesland,
    jahr_quartal,
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortality a -- WHERE
    --     woche <= (
    --         SELECT
    --             max(cast(woche AS INTEGER))
    --         FROM
    --             deutschland.mortality a
    --         WHERE
    --             jahr = 2022
    --             AND tote > 0
    --     )
WHERE
    right(jahr_quartal, 1) < 5
    AND tote100kWeighted > 0
GROUP BY
    a.bundesland,
    a.jahr_quartal;