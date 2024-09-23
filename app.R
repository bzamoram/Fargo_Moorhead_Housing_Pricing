# Load necessary libraries
library(shiny)
library(httr2)
library(vetiver)
library(DBI)
library(duckdb)

# # Load the housing data
# url <- "https://github.com/gmtanner-cord/DATA470-2024/raw/main/fmhousing/FM_Housing_2018_2022_clean.csv"
# housing_data <- read.csv(url)
# 
# # Establish database connection
# con <- dbConnect(duckdb::duckdb(), dbdir = "my-housing-db.duckdb")
# 
# # Check if "housing_data" exists, then either overwrite or create new
# if ("housing_data" %in% dbListTables(con)) {
#   DBI::dbWriteTable(con, "housing_data", housing_data, overwrite = TRUE)
# } else {
#   DBI::dbWriteTable(con, "housing_data", housing_data)
# }
# 
# # Disconnect from the database
# dbDisconnect(con)

# Define UI
ui <- fluidPage(
  titlePanel("Housing Price Predictor"),
  
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
      h2("Predicted Sold Price"),
      tableOutput("input_list"),
      tableOutput("predicted_price")
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
    
    tibble::tibble(
      List.Price = input$list_price,
      Total.SqFt. = input$sq_ft,
      Year.Built = input$year_built,
      Total.Bedrooms = input$bedrooms,
      Total.Bathrooms = input$bathrooms,
      Garage.Stalls = input$garage_stalls,
      High.School = input$high_school,
      Predicted.Price = response$.pred[[1]])
  })
  
  # Render prediction
  output$predicted_price <- renderTable({
    predicted_price()
  })
}

# Run the application
shinyApp(ui = ui, server = server)




# # app.R
# library(shiny)
# library(vetiver)
# library(pins)
# library(plumber)
# 
# # Load the model and necessary libraries
# model_board <- board_temp()
# v <- vetiver_pin_read(model_board, "model_board")
# 
# # Define the UI for the Shiny app
# ui <- fluidPage(
#   titlePanel("Housing Price Predictor"),
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("list_price", "List Price:", value = 200000),
#       numericInput("total_sqft", "Total Square Feet:", value = 1500),
#       numericInput("year_built", "Year Built:", value = 2000),
#       numericInput("total_bedrooms", "Total Bedrooms:", value = 3),
#       numericInput("total_bathrooms", "Total Bathrooms:", value = 2),
#       numericInput("garage_stalls", "Garage Stalls:", value = 1),
#       textInput("high_school", "High School:", value = "Some High School"),
#       actionButton("predict", "Predict")
#     ),
#     mainPanel(
#       textOutput("prediction")
#     )
#   )
# )
# 
# # Define server logic
# server <- function(input, output) {
#   observeEvent(input$predict, {
#     new_data <- data.frame(
#       List.Price = input$list_price,
#       Total.SqFt. = input$total_sqft,
#       Year.Built = input$year_built,
#       Total.Bedrooms = input$total_bedrooms,
#       Total.Bathrooms = input$total_bathrooms,
#       Garage.Stalls = input$garage_stalls,
#       High.School = input$high_school
#     )
#     
#     # Make prediction
#     prediction <- vetiver_predict(v, new_data)
#     output$prediction <- renderText({
#       paste("Predicted Sold Price:", round(prediction$Sold.Price, 2))
#     })
#   })
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)
