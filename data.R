# First R script: load_data.R
library(tidyverse)
library(duckdb)

# Loading the data from the URL
url <- "https://github.com/gmtanner-cord/DATA470-2024/raw/main/fmhousing/FM_Housing_2018_2022_clean.csv"
housing_data <- read.csv(url)

# Establish connection to DuckDB, using a local database file
con <- dbConnect(duckdb::duckdb(), dbdir = "my-housing-db.duckdb")

# Write the loaded CSV data into a DuckDB table
dbWriteTable(con, "housing_data", housing_data, overwrite = TRUE)

# Verify the data was written successfully by querying it
# result <- dbGetQuery(con, "SELECT * FROM housing_data LIMIT 5")
# print(result)

# Disconnect from the database
dbDisconnect(con)


