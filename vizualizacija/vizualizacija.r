# 3. faza: Vizualizacija podatkov
library(dplyr)
library(ggplot2)
library(ggmap) 

library(gtable)
library(patchwork)


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



#Otvoritve

otvoritve_magnusa <- igre_magnus %>% group_by(Rezultat_Magnusa, Barva_Magnusa, Otvoritev) %>% summarise(Stevilo_iger = n())
otvoritve_magnusa <- filter(otvoritve_magnusa, Rezultat_Magnusa == "won") %>% arrange(desc(Stevilo_iger))
otvoritve_magnusa_beli <- filter(otvoritve_magnusa, Barva_Magnusa == "white")
otvoritve_magnusa_crni <- filter(otvoritve_magnusa, Barva_Magnusa == "black")

ggplot(otvoritve_magnusa_beli[1:10,], aes(x = Stevilo_iger, y = Otvoritev))


graf_beli <- ggplot(otvoritve_magnusa_beli[1:10,]) + 
  aes(x=Stevilo_iger, y = reorder(Otvoritev, Stevilo_iger)) + geom_col()
graf_crni <- ggplot(otvoritve_magnusa_crni[1:10,]) + 
  aes(x=Stevilo_iger, y = reorder(Otvoritev, Stevilo_iger)) + geom_col()

graf_otvoritve <- graf_beli / graf_crni
