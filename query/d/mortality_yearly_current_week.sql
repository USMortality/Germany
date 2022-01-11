SELECT
    jahr,
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortalityD a
WHERE
    woche <= (
        SELECT
            max(cast(woche AS INTEGER))
        FROM
            deutschland.mortalityD a
        WHERE
            jahr = 2022
            AND tote > 0
    )
GROUP BY
    a.jahr;

-- Diff FOR 2020
-- SELECT
--     jahr,
--     sum(tote100kWeighted)
-- FROM
--     deutschland.mortalityD a
-- WHERE
--     jahr = 2020
--     AND woche >= 51
--     AND woche <= 52
-- GROUP BY
--     a.jahr;