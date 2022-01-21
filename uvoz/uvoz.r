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

#Popravimo neznane otvoritve
igre_magnus <- igre_magnus %>% replace_na(list(Tip_otvoritve = "Neznano", Otvoritev = "Neznano"))

#Nardimo tabelo za otvoritve glede na barvo in zmago
otvoritve_magnusa <- igre_magnus %>% group_by(Rezultat_Magnusa, Barva_Magnusa, Otvoritev) %>% summarise(Stevilo_iger = n())
otvoritve_magnusa <- filter(otvoritve_magnusa, Rezultat_Magnusa == "won") %>% arrange(desc(Stevilo_iger))

otvoritve_magnusa_beli <- filter(otvoritve_magnusa, Barva_Magnusa == "white")
odstotki_otvoritve_beli <- round(otvoritve_magnusa_beli[,"Stevilo_iger"] / sum(otvoritve_magnusa_beli[,"Stevilo_iger"]), digits=4)
otvoritve_magnusa_beli["Odstotki"] <- odstotki_otvoritve_beli * 100

otvoritve_magnusa_crni <- filter(otvoritve_magnusa, Barva_Magnusa == "black")
odstotki_otvoritve_crni <- round(otvoritve_magnusa_crni[,"Stevilo_iger"] / sum(otvoritve_magnusa_crni[,"Stevilo_iger"]), digits=4)
otvoritve_magnusa_crni["Odstotki"] <- odstotki_otvoritve_crni * 100

#Uredimo datume
igre_magnus <- igre_magnus %>% mutate(Datum = as.Date(Datum, tryFormats = c("%Y.%m.%d")))

#Tabela njegovih rezultatov na lichess
rezultati_magnus <- igre_magnus %>% count(Rezultat_Magnusa)
rezultati_magnus["Rezultat_Magnusa"] <- c("Remi", "Poraz", "Zmaga")
odstotki <- round(rezultati_magnus[, "n"] / sum(rezultati_magnus[, "n"]), digits = 2)
rezultati_magnus["Odstotki"] <- odstotki
oznake <- paste(odstotki * 100, "%", sep="")
rezultati_magnus["Oznake"] <- oznake




#Najvec je igral na dveh acc, tako da je treba dobit ven ratinge v zaporedju
igre_magnus <- igre_magnus[igre_magnus$Tip_igre == "Rated Bullet game",] #Zanima nas samo bullet format

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
igre_magnus_otb <- read.pgn('podatki/Carlsen.pgn', add.tags = c("WhiteElo", "BlackElo", "ECO")) %>% as.data.frame()
igre_magnus_otb[11:52] <- list(NULL)

#Dodamo otvoritve
igre_magnus_otb <- left_join(igre_magnus_otb, otvoritve, by=c("ECO" = "Otvoritev_eco"))

#Dodamo rating in barvo
igre_magnus_otb[c("Rating_Magnusa", "Barva")] <- ratingi_funkcija_otb(igre_magnus_otb)

#Samo raitngi over the board in njihovi datumi
igre_magnus_otb_ratingi <- igre_magnus_otb %>% select(c("Rating_Magnusa", "Date"))

#Se znebimo ponovitev ratingov iz istih turnirjev
igre_magnus_otb_ratingi <- igre_magnus_otb_ratingi[znebimo_zaporednih_ponovitev_ratinga(igre_magnus_otb_ratingi),]
igre_magnus_otb_ratingi <- igre_magnus_otb_ratingi[order(as.Date(igre_magnus_otb_ratingi$Date, format="%Y.%m.%d")),]
igre_magnus_otb_ratingi$Date <- as.Date(igre_magnus_otb_ratingi$Date, format="%Y.%m.%d")
igre_magnus_otb_ratingi <- head(igre_magnus_otb_ratingi, -2)
igre_magnus_otb_ratingi$Rating_Magnusa <- as.numeric(igre_magnus_otb_ratingi$Rating_Magnusa)



#Pri lokaciji izluscimo samo drzavo in spremenimo napacne oznake
igre_magnus_otb$Site <- str_sub(igre_magnus_otb$Site, -3)
spremembe <- c("BUL" = "BGR", "CRO" = "HRV", "DEN"="DNK", "ENG"="GBR", "GER"="DEU", "GRE"="GRC",
               "KSA"="SAU", "LBA"="LBY", "NED"="NLD", "SCO"="GBR", "SUI"="CHE", "UAE"="ARE")
igre_magnus_otb$Site <- igre_magnus_otb$Site %>% str_replace_all(spremembe)

#Nardimo tabelo samo z drzavami in stevilom iger v posamezni drzavi
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
