# 3. faza: Vizualizacija podatkov
library(dplyr)
library(ggplot2)
library(ggmap) 

library(gtable)
library(patchwork)
library(httr)
library(XML)
library(tmap)


##MAGNUS
#Tortni diagram za rezultate

rezultati_magnus <- igre_magnus %>% count(Rezultat_Magnusa)
rezultati_magnus["Rezultat_Magnusa"] <- c("Remi", "Poraz", "Zmaga")
odstotki <- round(rezultati_magnus[, "n"] / sum(rezultati_magnus[, "n"]), digits = 2)
rezultati_magnus["Odstotki"] <- odstotki
oznake <- paste(odstotki * 100, "%", sep="")
rezultati_magnus["Oznake"] <- oznake

graf_rezultati <- ggplot(rezultati_magnus, aes(x = "", y = Odstotki, fill = Rezultat_Magnusa)) +
  geom_col(color = "black") +
  geom_label(aes(label = oznake), color = c("white", "white", "white"),
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  guides(fill = guide_legend(title = "Rezultat")) +
  scale_fill_viridis_d() +
  coord_polar(theta = "y") + 
  labs(title="Rezultati iger") +
  theme_void()
graf_rezultati


#Otvoritve

otvoritve_magnusa <- igre_magnus %>% group_by(Rezultat_Magnusa, Barva_Magnusa, Otvoritev) %>% summarise(Stevilo_iger = n())
otvoritve_magnusa <- filter(otvoritve_magnusa, Rezultat_Magnusa == "won") %>% arrange(desc(Stevilo_iger))
otvoritve_magnusa_beli <- filter(otvoritve_magnusa, Barva_Magnusa == "white")
odstotki_otvoritve_beli <- round(otvoritve_magnusa_beli[,"Stevilo_iger"] / sum(otvoritve_magnusa_beli[,"Stevilo_iger"]), digits=4)
otvoritve_magnusa_beli["Odstotki"] <- odstotki_otvoritve_beli * 100

igre_magnus["Barva_Magnusa"]

otvoritve_magnusa_crni <- filter(otvoritve_magnusa, Barva_Magnusa == "black")
odstotki_otvoritve_crni <- round(otvoritve_magnusa_crni[,"Stevilo_iger"] / sum(otvoritve_magnusa_crni[,"Stevilo_iger"]), digits=4)
otvoritve_magnusa_crni["Odstotki"] <- odstotki_otvoritve_crni * 100
ggplot(otvoritve_magnusa_beli[1:10,], aes(x = Stevilo_iger, y = Otvoritev))


graf_beli <- ggplot(otvoritve_magnusa_beli[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col() + xlim(0,13.5)
graf_crni <- ggplot(otvoritve_magnusa_crni[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col() + xlim(0,13.5)

graf_otvoritve <- graf_beli / graf_crni
graf_otvoritve


#Rating

graf_ratingi <- ggplot(magnus_ratingi) + aes(x=Datum, y=Rating_Magnusa) +geom_curve()
graf_ratingi

plot <- ggplot(NULL, aes(ID, Rating)) + geom_step(data= magnus_ratingi_Dr_Drunkenstein, color="red") +
  geom_step(data=magnus_ratingi_Dr_Nykerstein) + xlim(0,550) + ylim(2600,3250) + xlab("Število iger")
plot


#Svet
tmap_mode("view")

tm_shape(igre_magnus_otb_turnirji_lokacije) + 
  tm_polygons("Stevilo_iger", popup.vars = c("Število iger:" = "Stevilo_iger")) + 
  tm_layout("Število iger v posamezni državi")
                                                                                                                                        )

tm_shape(igre_magnus_otb_turnirji_lokacije) + tm_fill("Stevilo_iger", title = "Število iger", style = "fixed",
                                                      breaks = c(1, 100, 200, 300, 400, 500)) + tm_polygons("Stevilo_iger", popup.vars = c("Število iger:" = "Stevilo_iger"))
