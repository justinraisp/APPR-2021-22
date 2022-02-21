ucenje = function(podatki, formula, algoritem) {
  switch(
    algoritem,
    lin.reg = lm(formula, data = podatki),
    log.reg = glm(formula, data = podatki, family = "binomial"),
    ng = ranger(formula, data = podatki)
  )
}



napovedi = function(podatki, model, algoritem) {
  switch(
    algoritem,
    lin.reg = predict(model, podatki),
    log.reg = ifelse(
      predict(model, podatki, type = "response") >= 0.5,
      1, -1
    ),
    ng = predict(model, podatki)$predictions
  )
}


napaka_regresije = function(podatki, model, algoritem) {
  podatki %>%
    bind_cols(Rating_Magnusa.hat = napovedi(podatki, model, algoritem)) %>%
    mutate(
      izguba = (Rating_Magnusa - Rating_Magnusa.hat) ^ 2
    ) %>%
    select(izguba) %>%
    unlist() %>%
    mean()
}

izbira_modela <- function(formule, stevilo_polinomov) {
  for (i in 1:stevilo_polinomov){
    formula <- formule[[i]]
    
  }
}

napaka_regresije1 = function(podatki, model) {
  podatki %>%
    bind_cols(Rating_Magnusa.hat = predict(model, podatki)$predictions) %>%
    mutate(
      izguba = (Rating_Magnusa - Rating_Magnusa.hat) ^ 2
    ) %>%
    select(izguba) %>%
    unlist() %>%
    mean()
}
