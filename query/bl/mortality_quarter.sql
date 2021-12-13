SELECT
    bundesland,
    jahr_quartal,
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
    a.jahr_quartal;