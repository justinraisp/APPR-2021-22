ratingi_funkcija_otb <- function(df){
  x <- numeric(length(df[,1]))
  y <- numeric(length(df[,1]))
  for (i in 1:length(df[,1])) {
    if(df[i, "White"] == "Carlsen,M"){
      x[i] <- df[i, "WhiteElo"]
      y[i] <- "White"
    }else if(df[i, "Black"] == "Carlsen,M") {
      x[i] <- df[i, "BlackElo"]
      y[i] <- "Black"
    }else
      x[i] <- 0
  }
  return(c(x,y))
}



ratingi_funkcija_lichess <- function(df, ime){
  x <- numeric(length(df[,"Rezultat_Magnusa"]))
  for (i in 1:length(df[,"Rezultat_Magnusa"])) {
    if(df[i, "Barva_Magnusa"] == "white" && df[i, "Beli"] == ime){
      x[i] <- df[i, "Rating_belega"]
    }else if(df[i, "Barva_Magnusa"] == "black" && df[i, "Crni"] == ime) {
      x[i] <- df[i, "Rating_crnega"]
    }else
      x[i] <- 0
  }
  return(x)
}


znebimo_zaporednih_ponovitev_ratinga <- function(df){
   x <- numeric(length(df[,1]))
   y <- numeric(length(df[,1]))
   for (i in 2:length(df[,1])) {
     if(df[i, "Rating_Magnusa"] == df[i-1, "Rating_Magnusa"]){
       x[i] <- "FALSE"
     }else if(is.na(df[i, "Rating_Magnusa"] )){
       x[i] <- "FALSE"
     }else
       x[i] <- "TRUE"
   }
   return(as.logical(x))
}
