library(shiny)
library(tidyverse)
source(here::here("R/functions.R"))

wss <- read_rds(here::here("data/wss_clean.rds"))

ui <- fluidPage(
  titlePanel("Western States Survey: Trump vote, 2020 vs 2024"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("state", "State", sort(unique(wss$state)), sort(unique(wss$state))),
      selectInput("by", "Compare by", c("latino", "race4", "auth_group", "age_group", "party3")),
      checkboxInput("wt", "Use survey weights", TRUE)
    ),
    mainPanel(plotOutput("plot"), tableOutput("tab"))
  )
)

server <- function(input, output, session) {
  est <- reactive({
    wss |>
      filter(state %in% input$state) |>
      trump_share(input$by, weighted = input$wt)
  })
  output$plot <- renderPlot(
    ggplot(est(), aes(year, trump, colour = .data[[input$by]], group = .data[[input$by]])) +
      geom_point(size = 3) + geom_line() +
      scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
      labs(x = NULL, y = "Two-party Trump share", colour = NULL) +
      theme_minimal(base_size = 15)
  )
  output$tab <- renderTable(est())
}

shinyApp(ui, server)
