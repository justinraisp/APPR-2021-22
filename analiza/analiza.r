# 4. faza: Napredna analiza podatkov



#Metoda voditeljev
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


prileganje <- glm(data = igre_magnus_otb_ratingi, Rating_Magnusa ~ poly(Date,5))
