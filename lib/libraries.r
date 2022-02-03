library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(readr)
library(dplyr)
library(tibble)
library(stringr)
library(bigchess)
library(reticulate)
library(GGally)
library(ggplot2)
library(ggmap) 
library(gtable)
library(patchwork)
library(reshape2)
library(grid)


options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
