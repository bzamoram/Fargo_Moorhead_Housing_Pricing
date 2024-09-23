# Load required libraries
library(DBI)
library(dplyr)
library(caret)
library(duckdb)
library(dbplyr)
library(ggplot2)
library(vetiver)
library(pins)
library(plumber)

# Connect to DuckDB database
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "my-housing-db.duckdb")

# Load the data from DuckDB
housing_data <- dplyr::tbl(con, "housing_data")

# Collect the data into an R data frame
housing_data <- housing_data %>% collect()

# View a preview of the data (optional)
head(housing_data)

# Splitting data into training & test sets
set.seed(42)
test_index <- createDataPartition(housing_data$Sold.Price, p = 0.20, list = FALSE)
test_set <- housing_data[test_index,]
train_set <- housing_data[-test_index,]

# Fitting the linear regression model
final_model <- lm(Sold.Price ~ List.Price + Total.SqFt. + Year.Built + 
                    Total.Bedrooms + Total.Bathrooms + Garage.Stalls + High.School,
                  data = train_set)

# Summary of the model (optional)
summary(final_model)

# Turning the model into a Vetiver API model
v <- vetiver_model(final_model, model_name = "housing_model")

# Saving the model to a board
library(vetiver)
library(pins)
library(plumber)
model_board <- board_temp(versioned = TRUE)
model_board %>% vetiver_pin_write(v)

# Exposing the model as an API using Plumber
pr() %>%
  vetiver_api(v) %>%
  pr_run(port = 8080)

# Disconnecting from the database
DBI::dbDisconnect(con)
