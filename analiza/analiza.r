# 4. faza: Napredna analiza podatkov


prileganje <- glm(data = igre_magnus_otb_ratingi, Rating_Magnusa ~ poly(Date,5))
