# Interactive Dashboard
# Load necessary libraries
library(shiny)
library(tidyverse)
library(bslib)

# GLOBAL ENVIRONMENT
data_url <- "https://raw.githubusercontent.com/egarpor/handy/master/datasets/wine.csv"
bordeaux_clean <- read_csv(data_url, show_col_types = FALSE) |>
  drop_na(Price) |>
  mutate(
    Age = max(Year) - Year,
    DryHarvest = if_else(HarvestRain < 100, "Yes", "No")
  )

# Train the production model on the full dataset for the app
wine_model <- lm(Price ~ AGST + WinterRain + HarvestRain + Age + DryHarvest, data = bordeaux_clean)

# USER INTERFACE
ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"), 
  
  titlePanel("Bordeaux Wine Vintage Predictor"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Adjust the climate variables below to simulate a vintage and predict its market quality."),
      sliderInput("agst", "Avg Growing Season Temp (Celsius):", min = 14.0, max = 19.0, value = 16.5, step = 0.1),
      sliderInput("winter_rain", "Winter Rainfall (mm):", min = 300, max = 900, value = 600, step = 10),
      sliderInput("harvest_rain", "Harvest Rainfall (mm):", min = 30, max = 300, value = 150, step = 10),
      sliderInput("age", "Age of Wine (Years):", min = 0, max = 50, value = 20, step = 1)
    ),
    
    mainPanel(
      h3("Model Prediction"),
      h1(textOutput("predicted_price"), style = "color: #2c3e50; font-weight: bold;"),
      hr(),
      # The placeholder for a dynamic plot
      plotOutput("vintage_plot"),
      hr(),
      markdown("**Behind the Model:** This application uses a Multiple Linear Regression model trained on historical Bordeaux wine data. It isolates the impact of weather and time on the final quality of the wine.")
    )
  )
)

# SERVER 
server <- function(input, output) {
  
  # Reactive prediction logic
  get_prediction <- reactive({
    user_data <- tibble(
      AGST = input$agst,
      WinterRain = input$winter_rain,
      HarvestRain = input$harvest_rain,
      Age = input$age,
      DryHarvest = if_else(input$harvest_rain < 100, "Yes", "No")
    )
    predict(wine_model, newdata = user_data)
  })
  
  # Output the text prediction
  output$predicted_price <- renderText({
    paste("Log Price / Quality Score:", round(get_prediction(), 2))
  })
  
  # Output the dynamic graph
  output$vintage_plot <- renderPlot({
    pred_val <- get_prediction()
    
    ggplot(bordeaux_clean, aes(x = Price)) +
      geom_histogram(fill = "#bdc3c7", color = "white", bins = 15) +
      geom_vline(xintercept = pred_val, color = "#c0392b", linewidth = 2, linetype = "dashed") +
      annotate("text", x = pred_val, y = 5, label = "Your Simulated Vintage  ", 
               color = "#c0392b", angle = 90, vjust = -0.5, fontface = "bold") +
      labs(
        title = "How Does This Vintage Compare to History?",
        x = "Wine Quality / Price (Log Scale)",
        y = "Number of Historical Vintages"
      ) +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(face = "bold", color = "#2c3e50"))
  })
}

shinyApp(ui = ui, server = server)










