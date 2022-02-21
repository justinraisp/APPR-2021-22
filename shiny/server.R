library(shiny)

shinyServer(function(input, output) {
  
  output$graf <- renderPlot({
    narisi_graf(input$leto)
  })
})



narisi_graf <- function(leto){
  graf <- ggplot(igre_magnus_otb_turnirji_lokacije %>% filter(Year == leto))+
    aes(x = reorder(name, Stevilo_iger), y = Stevilo_iger) +
    geom_col(fill="#CC0000", colour="black") + 
    theme_classic() +
    labs(
      x = "Država",
      y = "Število iger",
      title = leto
    ) + theme(
      axis.text.x = element_text(angle = 45, vjust = 0.5),
      text = element_text(size = 17)
    )
  print(graf)
}