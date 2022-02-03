# 3. faza: Vizualizacija podatkov


##MAGNUS
#Tortni diagram za rezultate

graf_rezultati_lichess <- ggplot(rezultati_magnus, aes(x = "", y = Odstotki, fill = Rezultat_Magnusa)) +
  geom_col(color = "black") +
  geom_label(aes(label = oznake), color = c("white", "white", "white"),
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  guides(fill = guide_legend(title = "Rezultat")) +
  coord_polar(theta = "y") + 
  labs(title="Rezultati iger preko spleta") +
  theme_void()
graf_rezultati_lichess

graf_rezultati_otb <- ggplot(igre_magnus_rezultati_otb, aes(x = "", y = Odstotki, fill = Rezultat_Magnusa)) +
  geom_col(color = "black") +
  geom_label(aes(label = Oznake), color = c("white", "white", "white"),
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  guides(fill = "none") +
  coord_polar(theta = "y") + 
  labs(title="Rezultati iger v živo") +
  theme_void()
graf_rezultati_otb

graf_rezultati <- graf_rezultati_otb + graf_rezultati_lichess
graf_rezultati 


#Otvoritve

graf_beli <- ggplot(otvoritve_magnusa_beli[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col(fill="#FF9999", colour="black") + xlim(0,14) +
  theme(axis.title.y = element_blank()) +
  ggtitle("Partije preko spleta") +
  theme(axis.title.x = element_blank())

graf_crni <- ggplot(otvoritve_magnusa_crni[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col(fill="#FF9999", colour="black") + xlim(0,14) +
  theme(axis.title.y = element_blank())

graf_beli_otb <- ggplot(otvoritve_magnusa_beli_otb[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col(fill="#CC0000", colour="black") + xlim(0,14) +
  labs(y = "Otvoritev kot beli") +
  ggtitle("Partije v živo") +
  theme(axis.title.x = element_blank())

graf_crni_otb <- ggplot(otvoritve_magnusa_crni_otb[1:10,]) + 
  aes(x=Odstotki, y = reorder(Otvoritev, Odstotki)) + geom_col(fill="#CC0000", colour="black") + xlim(0,14) +
  labs(y = "Otvoritev kot črni")


graf_otvoritve <- (graf_beli_otb + graf_beli) / (graf_crni_otb + graf_crni) + plot_annotation(
  title = 'Najpogostejše otvoritve zmag', theme = theme(plot.title = element_text(hjust = 0.5)))
graf_otvoritve


#Rating lichess
magnus_ratingi_lichess <- melt(magnus_ratingi_lichess, id.vars = "ID", variable.name = "Account")
graf_ratingi_lichess <- ggplot(magnus_ratingi_lichess, aes(ID, value)) + geom_line(aes(colour = Account)) +
  ylim(2600,3250) + xlab("Število iger") + ylab("Rating")
graf_ratingi_lichess

#Rating over the board
graf_ratingi_otb <- ggplot(igre_magnus_otb_ratingi, aes(x=Date, y=Rating_Magnusa, group=1)) +
  geom_line() + scale_x_date(date_labels = "%Y") + scale_y_continuous(limit=c(2000,3000)) +
  xlab("Leto") + ylab("Rating")
graf_ratingi_otb
graf_ratingi_otb + geom_smooth(method = "glm", formula = y ~ poly(x,4))


graf_ratingi <- graf_ratingi_lichess / graf_ratingi_otb


#Svet Carlsenove partije
tmap_mode("view")


zemljevid1 <- tm_shape(igre_magnus_otb_turnirji_lokacije) + 
  tm_fill("Stevilo_iger", title ="Število iger v državi", popup.vars = c("Število iger:" = "Stevilo_iger")) + 
  tm_borders() +
  tm_view(view.legend.position = c("right", "bottom")) +
  tm_layout(title="Število odigranih iger Magnusa v državi")


#SVet število velemojstrov

zemljevid2 <- tm_shape(velemojstri_drzave_zemljevid) +
  tm_fill("Stevilo_velemojstrov", title = "Število velemojstrov", popup.vars = c("Število velemojstrov:" = "Stevilo_velemojstrov"),
          breaks = c(0, 30, 60, 90, 120,Inf)) + 
  tm_borders() +
  tm_view(view.legend.position = c("right", "bottom"))


#Svet število velemojstrov per capita

zemljevid3 <- tm_shape(velemojstri_drzave_zemljevid) +
  tm_fill("Velemojstri_per_capita", title = "Velemojstri per capita", breaks = c(0,1,2,3,4,5,Inf),
          popup.vars = c("Število velemojstrov per capita:" = "Velemojstri_per_capita")) +
  tm_borders() +
  tm_view(view.legend.position = c("right", "bottom"))

zemljevida <- tmap_arrange(zemljevid2, zemljevid3, ncol = 2, widths = c(0.5,0.5))

