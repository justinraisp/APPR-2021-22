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

graf_beli <- ggplot(otvoritve_magnusa_beli[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col() + xlim(0,15)
graf_crni <- ggplot(otvoritve_magnusa_crni[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col() + xlim(0,15)
graf_crni
graf_otvoritve <- graf_beli / graf_crni
graf_otvoritve


#Rating lichess
graf_ratingi_lichess <- ggplot(NULL, aes(ID, Rating)) + geom_step(data= magnus_ratingi_Dr_Drunkenstein, color="red") +
  geom_step(data=magnus_ratingi_Dr_Nykerstein) + xlim(0,550) + ylim(2600,3250) + xlab("Število iger")
graf_ratingi_lichess


#Rating over the board
graf_ratingi_otb <- ggplot(igre_magnus_otb_ratingi, aes(x=Date, y=Rating_Magnusa, group=1)) +
  geom_line() + scale_x_date(date_labels = "%Y") + scale_y_continuous(limit=c(2000,3000))
graf_ratingi_otb
graf_ratingi_otb + geom_smooth(method = "glm", formula = y ~ poly(x,16))

#Svet
tmap_mode("view")

tm_shape(igre_magnus_otb_turnirji_lokacije) + 
  tm_polygons("Stevilo_iger", popup.vars = c("Število iger:" = "Stevilo_iger")) + 
  tm_legend(position = c("left", "bottom"), 
            frame = TRUE,
            bg.color="lightblue", title="Število iger v posamezni državi")
                                                                                                                                        

tm_shape(igre_magnus_otb_turnirji_lokacije) + tm_fill("Stevilo_iger", title = "Število iger", style = "fixed",
                                                      breaks = c(1, 100, 200, 300, 400, 500)) + tm_polygons("Stevilo_iger", popup.vars = c("Število iger:" = "Stevilo_iger"))
