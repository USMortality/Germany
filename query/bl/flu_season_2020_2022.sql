SELECT
    *,
    (tote100kWeighted / baseline) -1 AS excess
FROM
    (
        SELECT
            flu_season,
            bundesland,
            sum(tote100kWeighted) AS "tote100kWeighted",
            sum(baseline) AS "baseline"
        FROM
            (
                SELECT
                    CASE
                        WHEN a.jahr_quartal IN ("2020/4", "2021/1") THEN "2020/2021"
                        WHEN a.jahr_quartal IN ("2021/4", "2022/1") THEN "2021/2022"
                    END AS "flu_season",
                    a.bundesland,
                    sum(a.tote100kWeighted) AS tote100kWeighted,
                    sum(b.baseline) AS baseline
                FROM
                    deutschland.mortality a
                    JOIN deutschland.baseline2021 b ON a.altersgruppe = b.altersgruppe
                    AND a.bundesland = b.bundesland
                    AND a.woche = b.woche
                WHERE
                    (
                        (
                            a.jahr IN (2020, 2021)
                            AND a.woche >= 40
                            AND a.woche <= 52
                        )
                        OR (
                            a.jahr IN (2021, 2022)
                            AND a.woche >= 1
                            AND a.woche <= 12
                        )
                    )
                GROUP BY
                    a.jahr_quartal,
                    a.bundesland
            ) a
        GROUP BY
            flu_season,
            bundesland
    ) a;