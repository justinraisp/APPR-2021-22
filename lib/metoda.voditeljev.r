zemljevid.sveta.k<- function(n){
  k <- kmeans(velemojstri_drzave_norm, n, nstart = 1000)
  skupine <- data.frame(Drzava = velemojstri_drzave$Drzava, skupina=factor(k$cluster))
  print(skupine)
  data <- merge(World, skupine,by.x="sovereignt", by.y="Drzava")
  graf <- tm_shape(data) + tm_polygons("skupina")
  return(graf)
}

