# Load necessary libraries
library(shiny)
library(dplyr)
library(tidyr)

# Load the trained model at startup
housing_model <- readRDS("housing_price_model.rds")

# Define UI
ui <- fluidPage(
  # Link to the CSS file (if it exists, will be ignored if not)
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
      selectInput("high_school", "High School", 
                  choices = c("Davies", "Fargo North", "Fargo South", 
                              "Moorhead", "West Fargo", "West Fargo Sheyenne")),
      actionButton("predict", "Predict")
    ),
    
    mainPanel(
      h3("Predicted Sold Price"),
      p("Your selected attributes are shown down below for your convenience:"),
      tableOutput("predicted_price"),
      p("This predictive model was built by Bryan Zamora.")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Fetch prediction from loaded model
  predicted_price <- eventReactive(input$predict, {
    # Create input dataframe matching model training data
    req_body <- data.frame(
      List.Price = input$list_price,
      Total.SqFt. = input$sq_ft,
      Year.Built = input$year_built,
      Total.Bedrooms = input$bedrooms,
      Total.Bathrooms = input$bathrooms,
      Garage.Stalls = input$garage_stalls,
      High.School = input$high_school
    )
    
    # Make prediction using the loaded model
    prediction <- predict(housing_model, newdata = req_body)
    
    # Format output to match original structure
    df <- tibble::tibble(
      List.Price = input$list_price,
      Total.SqFt. = input$sq_ft,
      Year.Built = input$year_built,
      Total.Bedrooms = input$bedrooms,
      Total.Bathrooms = input$bathrooms,
      Garage.Stalls = input$garage_stalls,
      High.School = input$high_school,
      Predicted.Price = round(prediction, 0)
    )
    
    df <- df %>%
      mutate(across(everything(), as.character))
    
    df_long <- df %>%
      pivot_longer(cols = everything(),
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
