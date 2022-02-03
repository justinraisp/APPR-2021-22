# 4. faza: Napredna analiza podatkov

#KORELACIJA MED BDP PER CAPITA IN ŠTEVILOM VELEMOJSTROV
velemojstri_drzave <- velemojstri_drzave[complete.cases(velemojstri_drzave),]
bdp_gm <- ggplot(velemojstri_drzave, aes(x=`BDP_per_capita`, y=`Stevilo_velemojstrov`)) + geom_point()

linearna1 <- lm(data = velemojstri_drzave, velemojstri_drzave$BDP_per_capita ~ velemojstri_drzave$Stevilo_velemojstrov)

premica1 <- bdp_gm + geom_smooth(method = "lm", formula = y ~ x) +
  labs(y = "Velemojstri") +
  labs(x = "BDP per capita") +
  ggtitle("Korelacija med BDP per capita in velemojstri") 


#KORELACIJA MED BDP PER CAPITA IN ŠTEVILOM VELEMOJSTROV PER CAPITA
bdp_gm_pc <- ggplot(velemojstri_drzave, aes(x=`BDP_per_capita`, y=`Velemojstri_per_capita`)) + geom_point()

linearna2 <- lm(data = velemojstri_drzave, velemojstri_drzave$BDP_per_capita ~ velemojstri_drzave$Velemojstri_per_capita)

premica2 <- bdp_gm_pc + geom_smooth(method = "lm", formula = y ~ x) +
  labs(y = "Velemojstri per capita") +
  labs(x = "BDP per capita") +
  ggtitle("Korelacija med BDP per capita in velemojstri per capita") 


#REGRESIJA, NAPOVEDOVANJE

# Datume dam v numericno obliko kot stevilo dnevov od 1/1/1970
igre_magnus_otb_ratingi$Date.numeric = as.numeric(igre_magnus_otb_ratingi$Date)

#4. stopnja, ker se najbolj prilega ratingu 1.2.2022
prileganje <- lm(Rating_Magnusa ~ poly(Date.numeric,4), data=igre_magnus_otb_ratingi) 
napovedni_datumi <- data.frame(Date.numeric = as.numeric(as.Date(c("2022-02-01","2022-08-01","2023-02-01", "2023-08-01"))))

prediction <- mutate(napovedni_datumi, Rating_Magnusa = predict(prileganje, napovedni_datumi,interval = "prediction"))
prediction["Date"] <- as.Date(as.numeric(prediction$Date.numeric), origin = "1970-01-01")
prediction <- prediction[,c(2,3,1)]

graf_napovedi <- ggplot(igre_magnus_otb_ratingi, aes(x=Date, y=Rating_Magnusa)) + geom_point()
graf_napovedi

igre_magnus_otb_ratingi <- rbind(igre_magnus_otb_ratingi, prediction)

regresija <- igre_magnus_otb_ratingi %>%ggplot(aes(x=Date,y=Rating_Magnusa))+
  geom_smooth(method='lm', fullrange=TRUE, color='red', formula=y ~ poly(x,4,raw=TRUE)) +
  geom_point()


graf_napoved <- ggplot() +
  geom_point(aes(x = Date,y = Rating_Magnusa),data=head(igre_magnus_otb_ratingi,-4),colour = '#3399ff', size=1) +
  geom_point(aes(x = Date,y = Rating_Magnusa),data=tail(igre_magnus_otb_ratingi,4),colour = '#ff00ff', size=2) +
  geom_smooth(data=head(igre_magnus_otb_ratingi,-3), aes(x = Date, y= Rating_Magnusa),method='lm', fullrange=TRUE, color='red', formula=y ~ poly(x,4,raw=TRUE)) +
  xlab(label = 'Leto') +
  ylab(label = 'Rating')



regresija

#ggpairs(igre_magnus_otb_ratingi)

#datumi <- as.data.frame(as.Date(prediction$Date.numeric, "1970-01-01"))
