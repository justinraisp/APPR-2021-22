# 3. faza: Vizualizacija podatkov
library(dplyr)
library(ggplot2)
library(ggmap) 


##MAGNUS
#Tortni diagram za rezultate

rezultati_magnus <- igre_magnus %>% count(Rezultat_Magnusa)
rezultati_magnus["Rezultat_Magnusa"] <- c("Remi", "Poraz", "Zmaga")
odstotki <- round(rezultati_magnus[, "n"] / sum(rezultati_magnus[, "n"]), digits = 2)
rezultati_magnus["Odstotki"] <- odstotki
oznake <- paste(odstotki * 100, "%", sep="")
rezultati_magnus["Oznake"] <- oznake

ggplot(rezultati_magnus, aes(x = "", y = Odstotki, fill = Rezultat_Magnusa)) +
  geom_col(color = "black") +
  geom_label(aes(label = oznake), color = c("white", "white", "white"),
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  guides(fill = guide_legend(title = "Rezultat")) +
  scale_fill_viridis_d() +
  coord_polar(theta = "y") + 
  labs(title="Rezultati iger") +
  theme_void()

