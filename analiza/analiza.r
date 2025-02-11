# 4. faza: Napredna analiza podatkov
library(ranger)
library(randomForest)


set.seed(123)

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
#igre_magnus_otb_ratingi$ID <- seq.int(nrow(igre_magnus_otb_ratingi))

#4. stopnja, ker se najbolj prilega ratingu 1.2.2022
# prileganje <- lm(Rating_Magnusa ~ poly(Date.numeric,4), data=igre_magnus_otb_ratingi) 
#napovedni_datumi <- data.frame(Date.numeric = as.numeric(as.Date(c("2022-02-01","2022-08-01","2023-02-01", "2023-08-01"))))
# 
# prediction <- mutate(napovedni_datumi, Rating_Magnusa = predict(prileganje, napovedni_datumi,interval = "prediction"))
# prediction["Date"] <- as.Date(as.numeric(prediction$Date.numeric), origin = "1970-01-01")
# prediction <- prediction[,c(2,3,1)]
# 
# graf_napovedi <- ggplot(igre_magnus_otb_ratingi, aes(x=Date, y=Rating_Magnusa)) + geom_point()
# graf_napovedi
# 
# igre_magnus_otb_ratingi <- rbind(igre_magnus_otb_ratingi, prediction)
# 
# regresija <- igre_magnus_otb_ratingi %>%ggplot(aes(x=Date,y=Rating_Magnusa))+
#   geom_smooth(method='lm', fullrange=TRUE, color='red', formula=y ~ poly(x,4,raw=TRUE)) +
#   geom_point()
# 
# 
# graf_napoved <- ggplot() +
#   geom_point(aes(x = Date,y = Rating_Magnusa),data=head(igre_magnus_otb_ratingi,-4),colour = '#3399ff', size=1) +
#   geom_point(aes(x = Date,y = Rating_Magnusa),data=tail(igre_magnus_otb_ratingi,4),colour = '#ff00ff', size=2) +
#   geom_smooth(data=head(igre_magnus_otb_ratingi,-3), aes(x = Date, y= Rating_Magnusa),method='lm', fullrange=TRUE, color='red', formula=y ~ poly(x,4,raw=TRUE)) +
#   xlab(label = 'Leto') +
#   ylab(label = 'Rating')



#regresija

#Primerjal napake različnih modelov, na koncu se odločil za naključne gozdove

# formule <- c(Rating_Magnusa ~ poly(Date.numeric,1),
#              Rating_Magnusa ~ poly(Date.numeric,2),
#              Rating_Magnusa ~ poly(Date.numeric,3),
#              Rating_Magnusa ~ poly(Date.numeric,4),
#              Rating_Magnusa ~ poly(Date.numeric,5),
#              Rating_Magnusa ~ poly(Date.numeric,6),
#              Rating_Magnusa ~ poly(Date.numeric,7),
#              Rating_Magnusa ~ poly(Date.numeric,8),
#              Rating_Magnusa ~ poly(Date.numeric,9),
#              Rating_Magnusa ~ poly(Date.numeric,10))

# napake <- rep(0, 15)
# for (i in 1:15){
#   formula <- Rating_Magnusa ~ poly(Date.numeric,i)
#   model <- igre_magnus_otb_ratingi %>% ucenje(formula, "lin.reg")
#   napaka <- napaka_regresije(igre_magnus_otb_ratingi, model, "lin.reg") 
#   napake[i] <- napaka
# }
# which.min(napake)
# napake

#lin.model <- igre_magnus_otb_ratingi %>% ucenje(Rating_Magnusa ~ poly(Date.numeric,8), "lin.reg")
#lin.model
#print(igre_magnus_otb_ratingi %>% napaka_regresije(lin.model, "lin.reg"))
#pp.ratingi <- pp.razbitje(10, stratifikacija = igre_magnus_otb_ratingi)
#pp.ratingi <- razbitje(igre_magnus_otb_ratingi,10)

#print(precno.preverjanje(igre_magnus_otb_ratingi, pp.ratingi,Rating_Magnusa ~ poly(Date.numeric,11),"lin.reg", F))
#precno.preverjanje(igre_magnus_otb_ratingi, pp.ratingi,Rating_Magnusa ~ poly(Date.numeric,11),"lin.reg", F)

#ng.model <- igre_magnus_otb_ratingi %>% ucenje(Rating_Magnusa ~ Date.numeric, "ng")
#napaka.ng <- igre_magnus_otb_ratingi %>% napaka_regresije(ng.model, "ng")
#napaka.ng
#p1 = predict(ng.model, data = igre_magnus_otb_ratingi)
#head(p1)


#prediction <- mutate(napovedni_datumi, Rating_Magnusa = predict(ng.model, data=igre_magnus_otb_ratingi))

# 
# pp <- pp.razbitje(igre_magnus_otb_ratingi)
# razbitje1 <- razbitje(igre_magnus_otb_ratingi[-2], 3)
# pp
# razbitje1
#print(precno.preverjanje(igre_magnus_otb_ratingi[-2], razbitje1,Rating_Magnusa ~ Date.numeric , "ng", FALSE))


ratingi <- igre_magnus_otb_ratingi[,1]
ratingi

Lag <- function(x, n) {c(rep(NA, n), x)[1:length(x)]
}

naredi.df <- function(x){
  data.frame(ratingi = x, ratingi1 = Lag(x,1), ratingi2 = Lag(x,2))
}
df.ng <- naredi.df(c(ratingi))
df.ng
model1 <- ranger(formula = ratingi ~ ., data = df.ng %>% drop_na())
 
n <- nrow(df.ng)
for(i in 1:12) {
  df.ng <- naredi.df(c(df.ng$ratingi, NA))
  napoved <- predict(model1, data = df.ng[n+i,])$predictions
  df.ng[n+i,1] <- napoved
}

napovedi <- df.ng[(n+1):(n+12),1] %>% round()

napovedi
napovedni_meseci <- c(as.Date(c("2022-02-01","2022-04-01","2022-06-01", "2022-08-01",
                                "2022-10-01","2022-12-01","2023-02-01", "2023-04-01",
                                "2023-06-01","2023-08-01","2023-10-01", "2023-12-01")))
ratingi <- c(ratingi, napovedi)
napovedi.df <- data.frame(Rating_Magnusa = napovedi, Date = napovedni_meseci, Date.numeric = as.numeric(napovedni_meseci))
igre_magnus_otb_ratingi <- rbind(igre_magnus_otb_ratingi, napovedi.df)


graf_napoved <- ggplot() +
  geom_point(aes(x = Date,y = Rating_Magnusa),data=head(igre_magnus_otb_ratingi,-12),colour = '#3399ff', size=0.8) +
  geom_point(aes(x = Date,y = Rating_Magnusa),data=tail(igre_magnus_otb_ratingi,12),colour = '#ff00ff', size=0.8) +
  xlab(label = 'Leto') +
  ylab(label = 'Rating')

graf_napoved



ratingi



#Razvrščanje v skupine
set.seed(50)
velemojstri_drzave$Stevilo_velemojstrov <- as.numeric(velemojstri_drzave$Stevilo_velemojstrov)
velemojstri_drzave$Populacija <- as.numeric(velemojstri_drzave$Populacija)
velemojstri_drzave$Velemojstri_per_capita <- as.numeric(velemojstri_drzave$Velemojstri_per_capita)
velemojstri_drzave$BDP_per_capita <- as.numeric(velemojstri_drzave$BDP_per_capita)
velemojstri_drzave_skupine <- scale(velemojstri_drzave[,-1])
velemojstri_drzave[,-1] <- velemojstri_drzave_skupine
velemojstri_drzave <- na.omit(velemojstri_drzave)

skupine <- velemojstri_drzave[,-1] %>%
  kmeans(centers = 3) %>%
  getElement("cluster") %>%
  as.ordered()
#print(skupine)

velemojstri_drzave["Skupina"] <- skupine
#velemojstri_drzave[,2:5] <- NULL
velemojstri_drzave_zemljevid <- left_join(velemojstri_drzave_zemljevid, velemojstri_drzave, by="Drzava")


zemljevid4 <- tm_shape(velemojstri_drzave_zemljevid) +
  tm_fill("Skupina", title = "Razvrstitev glede na BDP, število velemojstrov in številu prebivalcev",
          popup.vars = c("Skupina" = "Skupina")) +
  tm_borders() +
  tm_view(view.legend.position = c("right", "bottom"))
zemljevid4



#Preveril optimalno število skupin
r.hc = velemojstri_drzave[, -1] %>% obrisi(hc = TRUE)
r.km = velemojstri_drzave[, -1] %>% obrisi(hc = FALSE)
diagram.obrisi(r.hc)
diagram.obrisi(r.km)
#Diagrama pokažeta, da sta optimalni števili 3 in 5, odločil sem se za 3, saj v primeru 5ih se pri prvem diagramu močno spustimo


#ggpairs(igre_magnus_otb_ratingi)

#datumi <- as.data.frame(as.Date(prediction$Date.numeric, "1970-01-01"))
