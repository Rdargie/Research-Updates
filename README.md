# Predicting Bordeaux Wine Quality from Climate Data 🍷🌦️

**[👉 Click Here to Play with the Live Interactive Dashboard](https://hxvljq-dargie-berhe.shinyapps.io/BordeauxWineApp/)**

## The Project
This project applies statistical inference and machine learning to historical weather and viticulture data. The goal is to isolate the impact of growing season temperature and rainfall on the final market quality of Bordeaux vintages. 

## The Tech Stack
* **Language:** R
* **Data Wrangling:** `tidyverse`, `dplyr`
* **Modeling:** Multiple Linear Regression (`lm`), Data Splitting (`rsample`)
* **Deployment:** R Shiny, `ggplot2`

## Key Insights
1. **Heat is a Catalyst:** Average Growing Season Temperature (AGST) shares a strong positive correlation with final wine quality.
2. **Harvest Rain is Detrimental:** High rainfall during the harvest window actively degrades the predicted value of the vintage, mathematically confirming the dilution and rot pressures associated with late-season precipitation.

## Repository Files
* `bordeaux_analysis.Rmd`: The rigorous statistical validation and train/test split.
* `app.R`: The production-ready R Shiny application code.