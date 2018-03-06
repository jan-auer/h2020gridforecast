library(shiny)
library(shinydashboard)
library(tidyverse)
library(dygraphs)
library(h2020gridforecast)

train_all_summary_stats <- readRDS("/home/datascience/local_data/train_all_summary_stats.rds")
train_all_summary_stats <- train_all_summary_stats %>% mutate_if(is.numeric, round, digits = 4) 

# Number of identically zero series
n_zeros <- train_all_summary_stats %>% arrange(desc(perc_zeros)) %>% filter(perc_zeros == 100) %>% pull() %>% length()

# UI #### 

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Aggregates", 
             tabName = "aggregates"),
    menuItem("Time Series",
             tabName = "time_series")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "aggregates", 
            fluidRow(
              infoBox(title = "Number of trivial (identically zero) series",
                      value = n_zeros
              ),
            fluidRow(
              DT::dataTableOutput("table", width = "80%")
            )
            )    
    ),
    tabItem(tabName = "time_series",
            "Content for Time Series")
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "EDA for H2020 data"),
  sidebar,
  body
)

# Server ####

server <- function(input, output) {
  output$table <- DT::renderDataTable(
    train_all_summary_stats,
    extensions = 'Buttons', options = list(dom = 'Bflirtp', buttons = I('colvis'))
  )
  
  
  
}

shinyApp(ui, server)