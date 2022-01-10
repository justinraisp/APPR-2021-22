# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(bigchess)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")


#SLOVAR ZA OTVORITVE

otvoritve <- read_csv(file = "podatki/odprtja.csv", locale = locale(encoding = "Windows-1250")) %>% as.data.frame()

#Pobrisemo nepotrebne stolpce
otvoritve[3:4] <- list(NULL)

#Preimenujemo stolpce
colnames(otvoritve) <- c("Otvoritev_eco", "Otvoritev","Tip_otvoritve")


#IGRE POVPRECNIH IGRALCEV NA LICHESS

lichess_igre <- read_csv(file = 'podatki/igre_lichess.csv',  locale = locale(encoding = "Windows-1250")) %>% as.data.frame()

#Pobrisemo nepotrebne stolpce
lichess_igre[1] <- NULL
lichess_igre[2:3] <- list(NULL)
lichess_igre[6] <- NULL
lichess_igre[7] <- NULL
lichess_igre[8:9] <- list(NULL)

#Preimenujemo stolpce
colnames(lichess_igre) <- c("Rated", "St_potez", "Tip_zmage", "Zmagovalec", "Casovna_omejitev", "Rating_belega", "Rating_crnega", "Otvoritev", "St_potez_v_odprtju")


#IGRE MAGNUSA CARLSENA NA LICHESS

headers = read.csv(file = 'podatki/carlsen_igre_lichess.csv',header = F, nrows = 1, as.is = T, encoding = "Windows-1250")
igre_magnus = read.csv(file = 'podatki/carlsen_igre_lichess.csv', skip = 77, header = F, encoding = "Windows-1250") %>% as.data.frame()
colnames(igre_magnus)= headers

#Pobrisemo nepotrebne stolpce
igre_magnus[1:2] <- list(NULL)
igre_magnus[2] <- NULL
igre_magnus[3] <- NULL
igre_magnus[20:27] <- list(NULL)

#Preimenujemo stolpce
colnames(igre_magnus) <- c("Tip_igre", "Datum", "Beli", "Crni", "Rezultat","Rating_belega", "Sprememba_ratinga_belega",
                           "Rating_crnega", "Sprememba_ratinga_crnega", "Naziv_belega", "Naziv_crnega" , "Zmagovalec",
                           "Rating_zmagovalca", "Porazenec", "Rating_porazenca", "Razlika_v_ratingu", "Otvoritev_eco", 
                           "Tip_konca", "Casovna_omejitev")

#Dodamo otvoritve glede na oznako
igre_magnus <- left_join(igre_magnus, otvoritve, by="Otvoritev_eco")


#IGRE VELEMOJSTROV

igre_mojstrov <- read_csv(file = 'podatki/igre_mojstrov.csv',  locale = locale(encoding = "Windows-1250")) %>% as.data.frame()

#Pobrisemo nepotrebne stolpce
igre_mojstrov[4] <- NULL
igre_mojstrov[9] <- NULL
igre_mojstrov[10] <- NULL

#Preimenujemo stolpce
colnames(igre_mojstrov) <- c("Sahovski_mojster", "Barva", "Nasprotnik", "Rating_nasprotnika", "Rezultat",
                             "Dogodek", "Lokacija", "Datum", "St_potez")


#NEPOZABNE IGRE

nepozabne_igre <- read.pgn('podatki/2724_immortal_games.pgn') %>% as.data.frame()
