# Setup
```bash
brew install docker
docker run --name deutschland-db -e MYSQL_ALLOW_EMPTY_PASSWORD=true -d -p 3306:3306 mariadb:latest --secure-file-priv=""
```

# Data Import
Download data from:
1) https://docs.google.com/spreadsheets/d/1QbSEwWvk2CV9cd5l0c1GNZOmjUIYI67sA5qb1iUVPpI/edit#gid=1998881205
2) https://docs.google.com/spreadsheets/d/1lbGyvqjNbi5fepKrQQx6atQny-2i55ik0Jxhy7O_DVM/edit#gid=1998881205

```bash
cp ~/Downloads/2__Deutschland\ BL\ Destatis\ -\ Export.csv data/Tote.csv
cp ~/Downloads/2__Deutschland\ BL\ Destatis\ -\ Data.csv data/Tote.csv
```

# Export
Deutschland:
```bash
./import_csv.sh data/ToteD.csv deutschland
./import_csv.sh data/EinwohnerD.csv deutschland
./import_csv.sh data/EinwohnerStandardD.csv deutschland

mysql -h 127.0.0.1 -u root deutschland <query/d/query.sql
mysql -h 127.0.0.1 -u root deutschland <query/d/mortality_quarter.sql >./out/d/mortality_quarter.csv
mysql -h 127.0.0.1 -u root deutschland <query/d/mortality_yearly_current_week.sql >./out/d/mortality_yearly_current_week.csv
mysql -h 127.0.0.1 -u root deutschland <query/d/mortality_yearly.sql >./out/d/mortality_yearly.csv
```

Deutschland BL:
```bash
./import_csv.sh data/Tote.csv deutschland
./import_csv.sh data/Einwohner.csv deutschland
./import_csv.sh data/EinwohnerStandard.csv deutschland

mysql -h 127.0.0.1 -u root deutschland <query/bl/query.sql
mysql -h 127.0.0.1 -u root deutschland <query/bl/mortality_quarter.sql >./out/bl/mortality_quarter.csv
mysql -h 127.0.0.1 -u root deutschland <query/bl/mortality_yearly_current_week.sql >./out/bl/mortality_yearly_current_week.csv
mysql -h 127.0.0.1 -u root deutschland <query/bl/quartal.sql >./out/bl/quartal.csv
```

# Visualization
1) https://docs.google.com/spreadsheets/d/1wZOWthP6YXIG1B1WCVt6Ma-iNGhKaH9jsOUWh-VEtes/edit#gid=0
2) https://docs.google.com/spreadsheets/d/1308PYgjimTlRzNLsv2Jh9awI9npz0lKKTxClGtovCuk/edit#gid=0
3) https://docs.google.com/spreadsheets/d/1Ih7Lz_c6LKQWSqELBkY3vPuLq6QH8xuJx44F3DICB1w/edit#gid=855710002

# About
- https://www.usmortality.com/
- https://t.me/usmortality
