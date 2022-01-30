# Analiza podatkov s programom R - 2021/22

## Analiza šahovsih partij

Pri projektni nalogi bom analiziral statistiko šahovskih partij in povezavo med številom velemojstrov v posamezni državi in razvitostjo države. Analiziral bom partije Magnusa Carlsena, odigrane med 2017 in 2021 preko platforme [Lichess](https://lichess.org/) in njegove partije odigrane tekmovalno v živo. Primerjal bom njegov rating skozi čas na dveh različnih uporabniških računih preko spleta in njegov FIDE rating. Primerjal bom število partij Carlsena, odigranih v različnih državah in njihovem številu velemojstrov.

### Cilji:

- ugotoviti, katere šahovske otvoritve so statistično najboljše preko spleta in v živo,
- napovedati spremembo ratinga Carlsena v prihodnosti,
- primerjati število Carlsenovih odigranih turnirjev v državi glede na število velemojstrov,
- primerjati število velemojstrov v državi glede na njen BDP per capita,
- primerjati število velemojstrov v državi glede na njihov izdatek za izobrazbo.

### Tabele:

- Tabela 1: Partije igralcev na [Lichess](https://lichess.org/)
    - Stolpci: rating črnega, rating belega, razlika v ratingu, tip igre, časovna omejitev, otvoritev, število potez v otvoritvi, zmagovalec, tip konca igre

- Tabela 2: Partije Magnusa Carlsena na [Lichess](https://lichess.org/)
    - Stolpci: rating nasprotnika, naziv nasprotnika, razlika v ratingu, tip igre, časovna omejitev, otvoritev, rezultat

- Tabela 3: Šahovski mojstri
    - Stolpci: ime mojstra, dogodek, lokacija, nasprotnik, rating nasprotnika, ekipi igralcev, otvoritev, rezultat, vrednost žrtvovanih figur, figure ob koncu igre

- Tabela 4: Nepozabne igre
    - Stolpci: ime črnega, ime belega, dogodek, lokacija, otvoritev, rezultat, število potez


Viri: 
- https://www.kaggle.com/zq1200/magnus-carlsen-lichess-games-dataset
- https://www.kaggle.com/datasnaek/chess/version/1
- https://www.kaggle.com/liury123/chess-game-from-12-top-players
- http://www.chess-poster.com/english/pgn/pgn_files.htm#og

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
