# Setup
```bash
brew install docker
docker run --name deutschland-db -e MYSQL_ALLOW_EMPTY_PASSWORD=true -d -p 3306:3306 mariadb:latest --secure-file-priv=""
```

# Data Import
Download data from:
1) Deaths D: https://docs.google.com/spreadsheets/d/1QbSEwWvk2CV9cd5l0c1GNZOmjUIYI67sA5qb1iUVPpI/edit#gid=1998881205
2) Deaths BL: https://docs.google.com/spreadsheets/d/1lbGyvqjNbi5fepKrQQx6atQny-2i55ik0Jxhy7O_DVM/edit#gid=1998881205
3) Population D: https://docs.google.com/spreadsheets/d/1aYKU725wu2EtH-zPjNufW_SGp2CTgxkeDe_dMI5SxQc/edit#gid=1721712158
4) Population BL: https://docs.google.com/spreadsheets/d/1gq5oN__hUMeG-i1SXLg-xW6q3ZNl4qq5WjyesOZkzfI/edit#gid=1038911700

```bash
cp ~/Downloads/2__Deutschland\ BL\ Destatis\ -\ Export.csv data/Tote.csv
cp ~/Downloads/2__Deutschland\ BL\ Destatis\ -\ Data.csv data/Tote.csv
```

# Export
```bash
./export.sh
```

# Visualization
1) Germany: https://docs.google.com/spreadsheets/d/1wZOWthP6YXIG1B1WCVt6Ma-iNGhKaH9jsOUWh-VEtes/edit#gid=0
2) Bundesländer: https://docs.google.com/spreadsheets/d/1308PYgjimTlRzNLsv2Jh9awI9npz0lKKTxClGtovCuk/edit#gid=0
3) Bundesländer/Matrix: https://docs.google.com/spreadsheets/d/1Ih7Lz_c6LKQWSqELBkY3vPuLq6QH8xuJx44F3DICB1w/edit#gid=855710002

# About
- https://www.usmortality.com/
- https://twitter.com/USMortality
- https://t.me/usmortality
