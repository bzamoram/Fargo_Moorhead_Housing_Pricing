# Fargo-Moorhead Housing Price Intelligence Platform

[![Live Demo](https://img.shields.io/badge/Live%20Demo-shinyapps.io-blue)](https://h8vi33-bzamoram.shinyapps.io/Fargo-Housing-Predictor/)
[![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-Interactive-brightgreen)](https://shiny.rstudio.com/)

An end-to-end machine learning web application that predicts residential property sale prices in the Fargo-Moorhead metropolitan area using historical sales data from 2018-2022.

## 🚀 Live Demo

**Try it here:** [https://h8vi33-bzamoram.shinyapps.io/Fargo-Housing-Predictor/](https://h8vi33-bzamoram.shinyapps.io/Fargo-Housing-Predictor/)

Enter property characteristics (square footage, bedrooms, location, etc.) and get instant price predictions powered by machine learning.

---

## 📊 Project Overview

This project demonstrates the complete data science workflow from data ingestion to production deployment:

- **Data Engineering**: Built ETL pipeline using DuckDB for efficient data storage and querying
- **Machine Learning**: Trained linear regression model achieving **96.1% accuracy (R² = 0.9613)**
- **Model Deployment**: Created production-ready Shiny web application with interactive UI
- **Cloud Hosting**: Deployed on shinyapps.io for public access

### Key Features
- Real-time price predictions based on 7 property attributes
- Interactive sliders and input controls for user-friendly experience
- Displays both predicted price and input summary
- Trained on 12,600+ real estate transactions across Fargo-Moorhead area

---

## 🛠️ Technology Stack

| Category | Technologies |
|----------|-------------|
| **Language** | R (tidyverse ecosystem) |
| **ML Framework** | caret, tidymodels |
| **Database** | DuckDB (embedded analytics database) |
| **Web Framework** | Shiny (interactive web applications) |
| **Deployment** | shinyapps.io |
| **Version Control** | Git, GitHub |


---

## 🔧 Architecture

### Development Architecture (Original)
1. **Data Layer** (`data.R`): Loads housing data into DuckDB
2. **Model Layer** (`model.R`): Trains model and exposes as REST API via Plumber
3. **Application Layer** (`app.R`): Shiny app calls API for predictions

### Production Architecture (Deployed)
1. **Data Layer**: Pre-processed data used for model training
2. **Model Layer**: Pre-trained model loaded at app startup (`housing_price_model.rds`)
3. **Application Layer**: Shiny app makes predictions directly using loaded model

*Simplified for cloud deployment to eliminate API dependency and improve performance.*

---

## 📈 Model Performance

**Model Type**: Multiple Linear Regression

**Predictor Variables**:
- List Price
- Total Square Footage
- Year Built
- Total Bedrooms
- Total Bathrooms
- Garage Stalls
- High School District

**Performance Metrics**:
- **R² Score**: 0.9613 (96.13% variance explained)
- **Adjusted R²**: 0.9613
- **Training Set Size**: 12,614 properties (80% split)
- **Test Set Size**: 3,154 properties (20% split)

**Geographic Coverage**: Davies, Fargo North, Fargo South, Moorhead, West Fargo, West Fargo Sheyenne school districts

---

## 🚀 Local Installation & Setup

### Prerequisites
- R (version 4.0 or higher)
- RStudio (recommended)
- Git




