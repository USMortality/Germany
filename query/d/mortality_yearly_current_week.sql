SELECT
    max(cast(woche AS INTEGER)) INTO @max_week
FROM
    deutschland.mortalityD a
WHERE
    jahr = 2022
    AND tote > 0;

SELECT
    jahr,
    @max_week AS "week_max",
    sum(tote100kWeighted) AS "tote100kWeighted"
FROM
    deutschland.mortalityD a
WHERE
    woche <= @max_week
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