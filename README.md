# Analiza podatkov s programom R - 2021/22

## Analiza šahovsih partij

Pri projektni nalogi bom analiziral statistiko šahovskih partij. Opazoval bom partije povprečnih šahistov in partije Magnusa Carlsena, odigrane med 2017 in 2021 preko platforme [Lichess](https://lichess.org/). Analiziral bom tudi partije dvanajstih šahovskih mojstrov, ki se kot prvi pojavijo na največji spletni platformi [Chess.com](https://www.chess.com/) in 2724 tako imenovanih "Immortal games", ki veljajo za najbolj nepozabne partije v zgodovini šaha. Cilji:
- ugotoviti, katere šahovske otvoritve so statistično najboljše za določeno časovno omejitev in za različno dobre igralce,
- primerjati šahovske mojstre glede na njihov stil igre in njihov uspeh, 
- primerjati partije Magnusa Carlsena preko spleta in partije šahovskih mojstrov v živo,
- primerjati nepozabne partije s partijami šahovskih mojstrov

Tabele:

1.Partije igralcev na [Lichess](https://lichess.org/):
  - Stolpci: rating črnega, rating belega, razlika v ratingu, tip igre, časovna omejitev,     otvoritev, število potez v otvoritvi, zmagovalec, tip konca igre

2. Partije Magnusa Carlsena na [Lichess](https://lichess.org/):
  - Stolpci: rating nasprotnika, naziv nasprotnika, razlika v ratingu, tip igre, časovna omejitev, odprtje, rezultat

3. Šahovski mojstri:
  - Stolpci: ime mojstra, dogodek, lokacija, nasprotnik, rating nasprotnika, ekipi igralcev, odprtje, rezultat, vrednost žrtvovanih figur, figure ob koncu igre

4. Nepozabne igre:
  - Stolpci: ime črnega, ime belega, dogodek, lokacija, odprtje, rezultat, število potez

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
