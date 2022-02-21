precno.preverjanje = function(podatki, razbitje, formula, algoritem, razvrscanje) {
  
  # pripravimo vektor za napovedi
  if (razvrscanje) {
    pp.napovedi = factor(rep(1, nrow(podatki)), levels = c(-1,1))
  } else {
    pp.napovedi = rep(0, nrow(podatki))
  }
  
  # gremo čez vse podmnožice Si razbitja S
  for (i in 1:length(razbitje)) {
    # naučimo se modela na množici S \ Si
    model = podatki[ -razbitje[[i]], ] %>% ucenje(formula, algoritem)
    
    # naučen model uporabimo za napovedi na Si
    pp.napovedi[ razbitje[[i]] ] = podatki[ razbitje[[i]], ] %>% napovedi(model, algoritem)
  }
  
  if (razvrscanje) {
    mean(pp.napovedi != podatki$yd)
  } else {
    mean((pp.napovedi - podatki$yn) ^ 2)
  }
}


# Razreži vektor x na k enako velikih kosov
razbitje = function(x, k) {
  
  # Razreži indekse vektorja na k intervalov
  razrez = cut(seq_along(x), k, labels = FALSE)
  
  # Razbij vektor na k seznamov
  # na osnovi razreza intervalov
  split(x, razrez)
}


pp.razbitje = function(n, k = 10, stratifikacija = NULL, seme = NULL) {
  
  # najprej nastavimo seme za naključna števila, če je podano
  if (!is.null(seme)) {
    set.seed(seme)
  }
  
  # če ne opravljamo stratifikacije, potem vrnemo navadno razbitje
  # funkcijo sample uporabimo zato, da naključno premešamo primere
  if (is.null(stratifikacija)) {
    return(razbitje(sample(1:length(n)), k))
  }
  
  # če pa opravljamo stratifikacijo, razbitje izvedemo za vsako
  # vrednost spremenljive stratifikacija posebej in nato
  # podmnožice združimo v skupno razbitje
  r = NULL
  for (v in levels(stratifikacija)) {
    
    # Če smo pri prvi vrednosti vzpostavimo razbitje
    if (is.null(r)) {
      # opravimo razbitje samo za primere z vrednostjo v
      r = razbitje(sample(which(stratifikacija == v)), k)
    } else {
      # opravimo razbitje za vrednost v
      # in podmnožice združimo s trenutnim razbitjem
      r.v = razbitje(sample(which(stratifikacija == v)), k)
      for (i in 1:k) {
        r[[i]] = c(r[[i]], r.v[[i]])
      }
    }
  }
  r
}


