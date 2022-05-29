SELECT
  jahr,
  lpad(a.woche, 2, 0) AS "woche",
  a.tote100kWeighted,
  baseline,
  a.tote100kWeighted / baseline -1 AS "excess"
FROM
  (
    SELECT
      jahr,
      woche,
      avg(tote100kWeighted) AS tote100kWeighted
    FROM
      deutschland.mortalityD a
    WHERE
      jahr IN (2020, 2021, 2022)
      AND woche <= 52
      AND altersgruppe IN (
        "60-65",
        "65-70",
        "70-75",
        "75-80",
        "80-85",
        "85"
      )
    GROUP BY
      jahr,
      woche
  ) a
  JOIN (
    SELECT
      woche,
      avg(tote100kWeighted) AS baseline
    FROM
      deutschland.mortalityD a
    WHERE
      jahr IN (2015, 2016, 2017, 2018, 2019)
      AND woche <= 52
      AND altersgruppe IN (
        "60-65",
        "65-70",
        "70-75",
        "75-80",
        "80-85",
        "85"
      )
    GROUP BY
      woche
  ) b ON a.woche = b.woche
WHERE
  tote100kWeighted > 0
ORDER BY
  jahr,
  woche;