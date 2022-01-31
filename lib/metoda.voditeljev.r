zemljevid.sveta.k<- function(n){
  k <- kmeans(velemojstri_drzave_norm, n, nstart = 1000)
  skupine <- data.frame(Drzava = velemojstri_drzave$Drzava, skupina=factor(k$cluster))
  graf <- tm_shape(merge(World, skupine, by.x="name", by.y="Drzava", all.x=TRUE)) + tm_polygons("skupina")
  return(graf)
}
