SELECT
    jahr,
    sum(tote) tote
FROM
    deutschland.mortalityD a
WHERE
    jahr <= 2022
    AND woche <= 52
    AND altersgruppe <= "0-30"
GROUP BY
    a.jahr;