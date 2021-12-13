SELECT
    jahr,
    sum(tote100kWeighted)
FROM
    deutschland.mortalityD a
WHERE
    woche <= (
        SELECT
            max(cast(woche AS INTEGER))
        FROM
            deutschland.mortalityD a
        WHERE
            jahr = 2021
            AND tote > 0
    )
GROUP BY
    a.jahr;