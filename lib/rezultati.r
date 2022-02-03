rezultati_funkcija_otb <- function(df){
  x <- numeric(length(df[,1]))
  y <- numeric(length(df[,1]))
  for (i in 1:length(df[,1])) {
    if(df[i, "White"] == "Carlsen,M" & df[i, "Result"] == "1-0"){
      x[i] <- "Won"
      y[i] <- "White"
    }else if(df[i, "White"] == "Carlsen,M" & df[i, "Result"] == "0-1"){
      x[i] <- "Lost"
      y[i] <- "White"
    }else if(df[i, "Black"] == "Carlsen,M" & df[i, "Result"] == "1-0") {
      x[i] <- "Lost"
      y[i] <- "Black"
    }else if(df[i, "Black"] == "Carlsen,M" & df[i, "Result"] == "0-1") {
      x[i] <- "Won"
      y[i] <- "Black"
    }else
      x[i] <- "Draw"
  }
  tabela <- as.data.frame(x, col.names="Rezultat")
  tabela["Barva"] <- as.data.frame(y)
  return(tabela)
}

