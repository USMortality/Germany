DROP VIEW IF EXISTS deutschland.mortalityD_lreg;

CREATE VIEW deutschland.mortalityD_lreg AS
SELECT
    slope,
    y_bar_max - x_bar_max * slope AS intercept
FROM
    (
        SELECT
            sum((x - x_bar) * (y - y_bar)) / sum((x - x_bar) * (x - x_bar)) AS slope,
            max(x_bar) AS x_bar_max,
            max(y_bar) AS y_bar_max
        FROM
            (
                SELECT
                    x,
                    avg(x) over () AS x_bar,
                    y,
                    avg(y) over () AS y_bar
                FROM
                    (
                        SELECT
                            jahr AS x,
                            sum(tote100kWeighted) AS y
                        FROM
                            deutschland.mortalityD a
                        WHERE
                            jahr IN (2015, 2016, 2017, 2018, 2019)
                            AND woche <= 52
                        GROUP BY
                            jahr
                    ) a
            ) a
    ) a;

DROP VIEW IF EXISTS deutschland.mortalityD_baseline_correction;

CREATE VIEW deutschland.mortalityD_baseline_correction AS
SELECT
    jahr,
    b.baseline / a.baseline AS baseline_correction
FROM
    (
        SELECT
            avg(jahr * slope + intercept) AS baseline
        FROM
            (
                SELECT
                    2015 AS jahr
                UNION
                SELECT
                    2016 AS jahr
                UNION
                SELECT
                    2017 AS jahr
                UNION
                SELECT
                    2018 AS jahr
                UNION
                SELECT
                    2019 AS jahr
            ) a
            JOIN deutschland.mortalityD_lreg b
    ) a
    JOIN (
        SELECT
            jahr,
            jahr * slope + intercept AS baseline
        FROM
            (
                SELECT
                    2020 AS jahr
                UNION
                SELECT
                    2021 AS jahr
                UNION
                SELECT
                    2022 AS jahr
            ) a
            JOIN deutschland.mortalityD_lreg b
    ) b;

SELECT
    a.jahr,
    lpad(a.woche, 2, 0) AS "woche",
    a.tote100kWeighted,
    @bl := baseline * c.baseline_correction 'baseline',
    a.tote100kWeighted / @bl -1 AS "excess",
    a.tote100kWeighted - @bl AS "excessAbs"
FROM
    (
        SELECT
            jahr,
            woche,
            sum(tote100kWeighted) AS tote100kWeighted
        FROM
            deutschland.mortalityD a
        WHERE
            jahr IN (2020, 2021, 2022)
            AND woche <= 52
        GROUP BY
            jahr,
            woche
    ) a
    JOIN (
        SELECT
            woche,
            sum(tote100kWeighted) / 5 AS baseline
        FROM
            deutschland.mortalityD a
        WHERE
            jahr IN (2015, 2016, 2017, 2018, 2019)
            AND woche <= 52
        GROUP BY
            woche
    ) b ON a.woche = b.woche
    JOIN deutschland.mortalityD_baseline_correction c ON a.jahr = c.jahr
WHERE
    a.tote100kWeighted > 0
ORDER BY
    a.jahr,
    woche;