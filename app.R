# Load necessary libraries
library(shiny)
library(httr2)
library(vetiver)
library(DBI)
library(duckdb)
library(dplyr)

# Define UI
ui <- fluidPage(
  # Link to the CSS file
  includeCSS("www/styles.css"),
    titlePanel("Fargo-Moorhead Housing Price Predictor"),
  
  # User input
  sidebarLayout(
    sidebarPanel(
      sliderInput("list_price", "List Price", min = 50000, max = 500000, value = 250000, step = 1000),
      numericInput("sq_ft", "Total SqFt", value = 1500, min = 500, max = 5000),
      numericInput("year_built", "Year Built", value = 2000, min = 1900, max = 2023),
      numericInput("bedrooms", "Total Bedrooms", value = 3, min = 1, max = 10),
      numericInput("bathrooms", "Total Bathrooms", value = 2, min = 1, max = 10),
      numericInput("garage_stalls", "Garage Stalls", value = 2, min = 0, max = 5),
      selectInput("high_school", "High School", choices = unique(housing_data$High.School)),
      actionButton("predict", "Predict")
    ),
    
    mainPanel(
      h3("Predicted Sold Price"),
      p("Your selected attributes are shown down below for your convience:"),
      tableOutput("input_list"),
      tableOutput("predicted_price"),
      p("This predictive model was built by Bryan Zamora.")
    )
  )
)

# Define server logic
server <- function(input, output) {
  api_url <- "http://127.0.0.1:8080/predict"
  
  
  
  # Fetch prediction from API
  predicted_price <- eventReactive(input$predict, {
    req_body <- tibble::tibble(
      List.Price = input$list_price,
      Total.SqFt. = input$sq_ft,
      Year.Built = input$year_built,
      Total.Bedrooms = input$bedrooms,
      Total.Bathrooms = input$bathrooms,
      Garage.Stalls = input$garage_stalls,
      High.School = input$high_school
    )
    
    response <- httr2::request(api_url) |>
      httr2::req_body_json(req_body) |>
      httr2::req_perform() |>
      httr2::resp_body_json()
    
    df <- tibble::tibble(
      List.Price = input$list_price,
      Total.SqFt. = input$sq_ft,
      Year.Built = input$year_built,
      Total.Bedrooms = input$bedrooms,
      Total.Bathrooms = input$bathrooms,
      Garage.Stalls = input$garage_stalls,
      High.School = input$high_school,
      Predicted.Price = response$.pred[[1]])
    
    df <- df %>%
      mutate(across(everything(), as.character))
    
    df_long <- df |>
      pivot_longer (cols = everything(),
                    names_to = "Attributes",
                    values_to = "Value")
    
    df_long
    
  })
  
  # Render prediction
  output$predicted_price <- renderTable({
    predicted_price()
  })
}

# Run the application
shinyApp(ui = ui, server = server)


