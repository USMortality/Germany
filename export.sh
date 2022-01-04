#!/bin/bash

mysql -h 127.0.0.1 -u root -e \
    "SET GLOBAL collation_connection = 'utf8mb4_general_ci';"
mysql -h 127.0.0.1 -u root -e "SET GLOBAL sql_mode = '';"

# Deutschland
./import_csv.sh data/ToteD.csv deutschland
./import_csv.sh data/EinwohnerD.csv deutschland
./import_csv.sh data/EinwohnerStandardD.csv deutschland

# Bundesländer
./import_csv.sh data/Tote.csv deutschland
./import_csv.sh data/Einwohner.csv deutschland
./import_csv.sh data/EinwohnerStandard.csv deutschland

# Deutschland
mysql -h 127.0.0.1 -u root deutschland <query/d/query.sql
mysql -h 127.0.0.1 -u root deutschland <query/d/mortality_quarter.sql >./out/d/mortality_quarter.csv
mysql -h 127.0.0.1 -u root deutschland <query/d/mortality_yearly_current_week.sql >./out/d/mortality_yearly_current_week.csv
mysql -h 127.0.0.1 -u root deutschland <query/d/mortality_yearly.sql >./out/d/mortality_yearly.csv
mysql -h 127.0.0.1 -u root deutschland <query/d/time_series.sql >./out/d/time_series.csv
mysql -h 127.0.0.1 -u root deutschland <query/d/time_series_age.sql >./out/d/time_series_age.csv

# Bundesländer
mysql -h 127.0.0.1 -u root deutschland <query/bl/query.sql
mysql -h 127.0.0.1 -u root deutschland <query/bl/mortality_quarter.sql >./out/bl/mortality_quarter.csv
mysql -h 127.0.0.1 -u root deutschland <query/bl/mortality_yearly_current_week.sql >./out/bl/mortality_yearly_current_week.csv
mysql -h 127.0.0.1 -u root deutschland <query/bl/quartal.sql >./out/bl/quartal.csv
