# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(bigchess)
library(reticulate)
library(tmap)
library(rvest)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

#KRATICE ZA DRZAVE
data("World")


#SLOVAR ZA OTVORITVE

otvoritve <- read_csv(file = "podatki/odprtja.csv", locale = locale(encoding = "Windows-1250")) %>% as.data.frame()




#Pobrisemo nepotrebne stolpce
otvoritve[3:4] <- list(NULL)

#Preimenujemo stolpce
colnames(otvoritve) <- c("Otvoritev_eco", "Otvoritev","Tip_otvoritve")




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






#VELEMOJSTRI PO DRZAVAH

url_gm <- read_html("https://en.wikipedia.org/wiki/List_of_chess_grandmasters") %>% html_table(fill = TRUE)
velemojstri <- url_gm[[2]]
velemojstri <- velemojstri[velemojstri$Died == "",]

#Potrebno zamenjat bivse drzave in popravit, da se imensko ujema s populacijo
velemojstri <- velemojstri[velemojstri$Federation != "Yugoslavia",]
velemojstri <- velemojstri[velemojstri$Federation != "Soviet Union",]
velemojstri <- velemojstri[velemojstri$Federation != "West Germany",]
velemojstri <- velemojstri[velemojstri$Federation != "Yugoslavia (S&M)",]
velemojstri <- velemojstri[velemojstri$Federation != "Czecho­slovakia",]
velemojstri <- velemojstri[velemojstri$Federation != "East Germany",]
velemojstri <- velemojstri[velemojstri$Federation != "Serbia and Montenegro",]
velemojstri <- velemojstri[velemojstri$Federation != "FIDE",]
spremembe2 <- c("Czech Republic (Czechia)" = "Czech Republic", "England" = "United Kingdom",
                "Scotland" = "United Kingdom", "Faroe Islands" = "Faeroe Islands", "Moldava" = "Moldova")
velemojstri$Federation <- velemojstri$Federation %>% str_replace_all(spremembe2)

velemojstri <- velemojstri %>% group_by(Federation) %>% summarise(Stevilo_velemojstrov = n()) %>% as.data.frame()



#Stevilo prebivalcev v posamezni drzavi 
url_populacija <- read_html("https://www.worldometers.info/world-population/population-by-country/") %>% html_table(fill = TRUE)
drzave_populacija <- url_populacija[[1]]
drzave_populacija <- drzave_populacija[c("Country (or dependency)", "Population (2020)")]
colnames(drzave_populacija) <- c("Drzava", "Populacija")
drzave_populacija$Drzava <- drzave_populacija$Drzava %>% str_replace_all("Czech Republic (Czechia)","Czech Republic")


velemojstri_populacija <- merge(velemojstri, drzave_populacija, by.x = "Federation", by.y = "Drzava")
velemojstri_populacija$Stevilo_velemojstrov <- as.numeric(velemojstri_populacija$Stevilo_velemojstrov)
velemojstri_populacija$Populacija <- gsub(",", "", velemojstri_populacija$Populacija)
velemojstri_populacija$Populacija <- as.numeric(velemojstri_populacija$Populacija)
velemojstri_per_capita <- (velemojstri_populacija$Stevilo_velemojstrov / velemojstri_populacija$Populacija) * 1000000

velemojstri_populacija["Velemojstri_per_capita"] <- velemojstri_per_capita
colnames(velemojstri_populacija)[1] <- "Drzava"




#BDP per capita 
url_bdp <- read_html("https://www.worldometers.info/gdp/gdp-per-capita/") %>% html_table(fill =TRUE)
drzave_bdp <- url_bdp[[1]]
drzave_bdp <- drzave_bdp[c("Country", "GDP (nominal) per capita (2017)")]
colnames(drzave_bdp) <- c("Drzava", "BDP_per_capita")
drzave_bdp <- drzave_bdp %>% mutate(BDP_per_capita = str_replace_all(BDP_per_capita, "[$]", ""))
drzave_bdp <- drzave_bdp %>% mutate(BDP_per_capita = str_replace_all(BDP_per_capita, "[,]", ""))
drzave_bdp$BDP_per_capita <- as.numeric(drzave_bdp$BDP_per_capita)

drzave_bdp$Drzava <- drzave_bdp$Drzava %>% str_replace_all("Czech Republic (Czechia)","Czech Republic")


velemojstri_drzave <- left_join(velemojstri_populacija, drzave_bdp, by="Drzava")




#Delez BDP-ja porabljenega za izobrazbo
url_izobrazba <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_spending_on_education_(%25_of_GDP)") %>% html_table(fill=TRUE)
drzave_izobrazba <- url_izobrazba[[1]]
drzave_izobrazba <- drzave_izobrazba[1:2]
colnames(drzave_izobrazba) <- c("Drzava", "Procent_BDP")
drzave_izobrazba$Procent_BDP <- as.numeric(drzave_izobrazba$Procent_BDP)


velemojstri_drzave <- left_join(velemojstri_drzave, drzave_izobrazba, by="Drzava")
