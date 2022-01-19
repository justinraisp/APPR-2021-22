# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(bigchess)
library(reticulate)
library(tmap)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

#KRATICE ZA DRZAVE
data("World")


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
igre_magnus = read.csv(file = 'podatki/carlsen_igre_lichess.csv', skip = 187, header = F, encoding = "Windows-1250") %>% as.data.frame()
colnames(igre_magnus)= headers

#Pobrisemo nepotrebne stolpce
igre_magnus[1:2] <- list(NULL)
igre_magnus[2] <- NULL
igre_magnus[3] <- NULL
igre_magnus[20:25] <- list(NULL)

#Preimenujemo stolpce
colnames(igre_magnus) <- c("Tip_igre", "Datum", "Beli", "Crni", "Rezultat","Rating_belega", "Sprememba_ratinga_belega",
                           "Rating_crnega", "Sprememba_ratinga_crnega", "Naziv_belega", "Naziv_crnega" , "Zmagovalec",
                           "Rating_zmagovalca", "Porazenec", "Rating_porazenca", "Razlika_v_ratingu", "Otvoritev_eco", 
                           "Tip_konca", "Casovna_omejitev", "Barva_Magnusa", "Rezultat_Magnusa")


#Dodamo otvoritve glede na oznako
igre_magnus <- left_join(igre_magnus, otvoritve, by="Otvoritev_eco")

#Uredimo datume
igre_magnus <- igre_magnus %>% mutate(Datum = as.Date(Datum, tryFormats = c("%Y.%m.%d")))

#igre_magnus <- igre_magnus[order(igre_magnus$Datum),]

#Popravimo neznane otvoritve
igre_magnus <- igre_magnus %>% replace_na(list(Tip_otvoritve = "Neznano", Otvoritev = "Neznano"))

#Dodamo ratinge od Magnusa, ki jih zelimo prikazat
ratingi_funkcija_lichess <- function(df, ime){
  x <- numeric(length(df[,"Rezultat_Magnusa"]))
  for (i in 1:length(df[,"Rezultat_Magnusa"])) {
    if(df[i, "Barva_Magnusa"] == "white" && df[i, "Beli"] == ime){
      x[i] <- df[i, "Rating_belega"]
    }else if(df[i, "Barva_Magnusa"] == "black" && df[i, "Crni"] == ime) {
      x[i] <- df[i, "Rating_crnega"]
    }else
      x[i] <- 0
  }
  return(x)
}

#Najvec je igral na dveh acc, tako da je treba dobit ven ratinge v zaporedju

igre_magnus <- igre_magnus[igre_magnus$Tip_igre == "Rated Bullet game",]

igre_magnus["Rating_Magnusa_Ny"] <- ratingi_funkcija_lichess(igre_magnus, "DrNykterstein")
magnus_ratingi_Dr_Nykerstein <- igre_magnus[igre_magnus$Rating_Magnusa_Ny != "0",]["Rating_Magnusa_Ny"]
magnus_ratingi_Dr_Nykerstein <- as.data.frame(apply(magnus_ratingi_Dr_Nykerstein, 2,rev))
magnus_ratingi_Dr_Nykerstein <- tibble::rowid_to_column(magnus_ratingi_Dr_Nykerstein, "ID")
colnames(magnus_ratingi_Dr_Nykerstein) <- c("ID", "Rating")
magnus_ratingi_Dr_Nykerstein <- magnus_ratingi_Dr_Nykerstein[magnus_ratingi_Dr_Nykerstein$Rating > 1500,]

igre_magnus["Rating_Magnusa_Dr"] <- ratingi_funkcija_lichess(igre_magnus, "DrDrunkenstein")
magnus_ratingi_Dr_Drunkenstein <-igre_magnus[igre_magnus$Rating_Magnusa_Dr != "0",]["Rating_Magnusa_Dr"]
magnus_ratingi_Dr_Drunkenstein <- as.data.frame(apply(magnus_ratingi_Dr_Drunkenstein, 2,rev))
magnus_ratingi_Dr_Drunkenstein <- tibble::rowid_to_column(magnus_ratingi_Dr_Drunkenstein, "ID")
colnames(magnus_ratingi_Dr_Drunkenstein) <- c("ID", "Rating")

#Turnirske igre
ratingi_funkcija_otb <- function(df){
  x <- numeric(length(df[,1]))
  for (i in 1:length(df[,1])) {
    if(df[i, "White"] == "Carlsen,M"){
      x[i] <- df[i, "WhiteElo"]
    }else if(df[i, "Black"] == "Carlsen,M") {
    x[i] <- df[i, "BlackElo"]
    }else
    x[i] <- 0
  }
  return(x)
}
igre_magnus_otb <- read.pgn('podatki/Carlsen.pgn', add.tags = c("WhiteElo", "BlackElo")) %>% as.data.frame()
igre_magnus_otb[10:51] <- list(NULL)
igre_magnus_otb["Rating_Magnusa"] <- ratingi_funkcija_otb(igre_magnus_otb)
igre_magnus_otb$Site <- str_sub(igre_magnus_otb$Site, -3)

spremembe <- c("BUL" = "BGR", "CRO" = "HRV", "DEN"="DNK", "ENG"="GBR", "GER"="DEU", "GRE"="GRC",
               "KSA"="SAU", "LBA"="LBY", "NED"="NLD", "SCO"="GBR", "SUI"="CHE", "UAE"="ARE")
igre_magnus_otb$Site <- igre_magnus_otb$Site %>% str_replace_all(spremembe)

#Ratingi over the board
igre_magnus_otb_ratingi <- igre_magnus_otb %>% group_by(Rating_Magnusa, Date) %>% summarise()
igre_magnus_otb_ratingi <- igre_magnus_otb_ratingi[order(as.Date(igre_magnus_otb_ratingi$Date, format="%Y.%m.%d")),]
igre_magnus_otb_ratingi$Date <- as.Date(igre_magnus_otb_ratingi$Date, format="%Y.%m.%d")
igre_magnus_otb_ratingi <- igre_magnus_otb_ratingi[-c(1:8),]
igre_magnus_otb_ratingi <- igre_magnus_otb_ratingi[-c(1887,1888),]
ponovitve_ratinga <- c(duplicated(igre_magnus_otb_ratingi$Rating_Magnusa))
igre_magnus_otb_ratingi <- igre_magnus_otb_ratingi[!ponovitve_ratinga,]



igre_magnus_otb_turnirji_lokacije <- igre_magnus_otb %>% group_by(Site) %>%
  summarise(Stevilo_iger = n()) %>% as.data.frame()
igre_magnus_otb_turnirji_lokacije <- merge(World, igre_magnus_otb_turnirji_lokacije, by.x = "iso_a3", by.y = "Site")
igre_magnus_otb_turnirji_lokacije <- igre_magnus_otb_turnirji_lokacije[c("name", "Stevilo_iger")]

#IGRE VELEMOJSTROV

igre_mojstrov <- read_csv(file = 'podatki/igre_mojstrov.csv',  locale = locale(encoding = "Windows-1250")) %>% as.data.frame()

#Pobrisemo nepotrebne stolpce
igre_mojstrov[4] <- NULL
igre_mojstrov[9] <- NULL
igre_mojstrov[10] <- NULL

#Preimenujemo stolpce
colnames(igre_mojstrov) <- c("Sahovski_mojster", "Barva", "Nasprotnik", "Rating_nasprotnika", "Rezultat",
                             "Dogodek", "Lokacija", "Leto", "St_potez")

#Uredimo datume
igre_mojstrov <- igre_mojstrov %>% mutate(Leto = str_replace_all(Leto, "[?]", "1")) %>% mutate(Leto = as.POSIXct(Leto, format="%Y.%m.%d")) %>%
  mutate(Leto = format(Leto, format="%Y"))


#NEPOZABNE IGRE

nepozabne_igre <- read.pgn('podatki/2724_immortal_games.pgn') %>% as.data.frame()
