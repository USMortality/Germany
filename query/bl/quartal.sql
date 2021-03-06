SELECT
    *,
    (tote100kWeighted / baseline) -1 AS excess
FROM
    (
        SELECT
            a.jahr,
            a.bundesland,
            a.jahr_quartal,
            sum(a.tote100kWeighted) AS tote100kWeighted,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortality a
            JOIN deutschland.baseline2020 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2020
        GROUP BY
            a.jahr,
            a.bundesland,
            a.jahr_quartal
        UNION
        ALL -- 2021
        SELECT
            a.jahr,
            a.bundesland,
            a.jahr_quartal,
            sum(a.tote100kWeighted) AS tote100kWeighted,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortality a
            JOIN deutschland.baseline2021 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2021
        GROUP BY
            a.jahr,
            a.bundesland,
            a.jahr_quartal
        UNION
        ALL -- 2022
        SELECT
            a.jahr,
            a.bundesland,
            a.jahr_quartal,
            sum(a.tote100kWeighted) AS tote100kWeighted,
            sum(b.baseline) AS baseline
        FROM
            deutschland.mortality a
            JOIN deutschland.baseline2022 b ON a.altersgruppe = b.altersgruppe
            AND a.bundesland = b.bundesland
            AND a.woche = b.woche
        WHERE
            a.jahr = 2022
        GROUP BY
            a.jahr,
            a.bundesland,
            a.jahr_quartal
    ) a;