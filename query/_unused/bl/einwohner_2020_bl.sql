SELECT
    bundesland,
    sum(einwohner) AS einwohner
FROM
    deutschland.imp_Einwohner
WHERE
    jahr = 2020
    AND altersgruppe = ""
GROUP BY
    bundesland;