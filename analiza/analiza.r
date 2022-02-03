# 4. faza: Napredna analiza podatkov
library(ggplot2)
library(GGally)

#METODA VODITELJEV
set.seed(123)
runif(1)

velemojstri_drzave <- velemojstri_drzave[complete.cases(velemojstri_drzave),] #Odstranim drzave z na
velemojstri_drzave$Populacija <- list(NULL)
velemojstri_drzave_norm <- velemojstri_drzave %>% dplyr::select(-Drzava) %>% scale()
rownames(velemojstri_drzave_norm) <- velemojstri_drzave$Drzava
velemojstri_drzave_norm <- velemojstri_drzave_norm[complete.cases(velemojstri_drzave_norm),] #Odstranim drzave z na
k <- kmeans(velemojstri_drzave_norm, 5, nstart = 1000)
head(k$cluster)
table(k$cluster)
k$tot.withinss 

skupine <- data.frame(Drzava = velemojstri_drzave$Drzava, skupina = factor(k$cluster))


zemljevid.sveta.k(3)




#REGRESIJA, NAPOVEDOVANJE

# Datume dam v numericno obliko kot stevilo dnevov od 1/1/1970
igre_magnus_otb_ratingi$Date.numeric = as.numeric(igre_magnus_otb_ratingi$Date)

#4. stopnja, ker se najbolj prilega ratingu 1.2.2022
prileganje <- lm(Rating_Magnusa ~ poly(Date.numeric,4), data=igre_magnus_otb_ratingi) 
napovedni_datumi <- data.frame(Date.numeric = as.numeric(as.Date(c("2022-02-01","2022-08-01","2023-02-01", "2023-08-01"))))

prediction <- mutate(napovedni_datumi, Rating_Magnusa = predict(prileganje, napovedni_datumi,interval = "prediction"))
prediction["Date"] <- as.Date(prediction$Date.numeric, "1970-01-01")
prediction <- prediction[,c(2,3,1)]

graf_napovedi <- ggplot(igre_magnus_otb_ratingi, aes(x=Date, y=Rating_Magnusa)) + geom_point()
graf_napovedi

igre_magnus_otb_ratingi <- rbind(igre_magnus_otb_ratingi, prediction)

regresija <- igre_magnus_otb_ratingi %>%ggplot(aes(x=Date,y=Rating_Magnusa))+
  geom_smooth(method='lm', fullrange=TRUE, color='red', formula=y ~ poly(x,4,raw=TRUE)) +
  geom_point()


ggplot() +
  geom_point(aes(x = Date,y = Rating_Magnusa),data=head(igre_magnus_otb_ratingi,-4),colour = '#3399ff', size=2) +
  geom_point(aes(x = Date,y = Rating_Magnusa),data=tail(igre_magnus_otb_ratingi,4),colour = '#ff00ff', size=3) +
  geom_smooth(data=head(igre_magnus_otb_ratingi,-3), aes(x = Date, y= Rating_Magnusa),method='lm', fullrange=TRUE, color='red', formula=y ~ poly(x,4,raw=TRUE)) +
  xlab(label = 'Year') +
  ylab(label = 'Rating')



regresija

#ggpairs(igre_magnus_otb_ratingi)

#datumi <- as.data.frame(as.Date(prediction$Date.numeric, "1970-01-01"))
