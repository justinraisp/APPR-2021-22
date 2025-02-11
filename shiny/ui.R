library(shiny)

shinyUI(fluidPage(
  titlePanel(""),
  sidebarLayout(position = "right",
                sidebarPanel(
                  sliderInput(
                    "leto",
                    label = "Leto:",
                    min = 2001, max = 2021, step = 1,
                    round = FALSE, sep = "", ticks = FALSE,
                    value = 2010
                  ))
                ,
                mainPanel(plotOutput("graf"))),
  uiOutput("izborTabPanel")))