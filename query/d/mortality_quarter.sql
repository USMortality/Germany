SELECT
    *
FROM
    (
        SELECT
            jahr_quartal,
            sum(tote100kWeighted) AS "tote100kWeighted"
        FROM
            deutschland.mortalityD a
        GROUP BY
            a.jahr_quartal
    ) a
WHERE
    tote100kWeighted > 0;