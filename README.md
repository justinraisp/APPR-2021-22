# Analiza podatkov s programom R - 2021/22

## Analiza šahovsih partij

Pri projektni nalogi bom analiziral statistiko šahovskih partij in povezavo med številom velemojstrov v posamezni državi in razvitostjo države. Analiziral bom partije Magnusa Carlsena, odigrane med 2017 in 2021 preko platforme [Lichess](https://lichess.org/) in njegove partije odigrane tekmovalno v živo. Primerjal bom njegov rating skozi čas na dveh različnih uporabniških računih preko spleta in njegov FIDE rating. Primerjal bom število partij Carlsena, odigranih v različnih državah in njihovem številu velemojstrov.


### Cilji:

- ugotoviti, katere šahovske otvoritve so statistično najboljše preko spleta in v živo,
- napovedati spremembo ratinga Carlsena v prihodnosti,
- primerjati število Carlsenovih odigranih turnirjev v državi glede na število velemojstrov,
- primerjati število velemojstrov v državi glede na njen BDP per capita,
- primerjati število velemojstrov per capita v državi glede na njen BDP per capita

### Tabele:

1. Dve tabeli za rezultate v živo in preko spleta
  - `Rezultat`
  - `Število iger`
  - `Odstotek`
  
2. Štiri tabele različnih velikosti za otvoritve glede na barvo in tip partije
  - `Rezultat`
  - `Barva`
  - `Otvoritev`
  - `Število iger`
  - `Odstotek`
  
3. FIDE ratingi
  - `Rating`
  - `Datum`
  
4. Ratingi preko spleta
  - `ID` 
  - `Account`
  - `Rating`
  
5. Lokacije Magnusovih partij
  - `Država`
  - `Število iger`

6. Države in število velemojstrov
  - `Država`
  - `Število velemojstrov`
  - `Prebivalstvo`
  - `Velemojstri per capita`
  - `BDP per capita`
  - `Delež BDP-ja za izobraževanje`


Viri: 
- https://www.kaggle.com/zq1200/magnus-carlsen-lichess-games-dataset
- http://www.chess-poster.com/english/pgn/pgn_files.htm#og
- https://en.wikipedia.org/wiki/List_of_chess_grandmasters
- https://www.worldometers.info/world-population/population-by-country/
- https://www.worldometers.info/gdp/gdp-per-capita/

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Potrebne knjižnice so v datoteki `lib/libraries.r`
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).
