library(shiny)

# Define UI for the main application
ui <- navbarPage(
  title = "Main App",
  
  tabPanel("Home",
           fluidPage(
             titlePanel("Welcome to the Main App"),
             sidebarLayout(
               sidebarPanel(
                 actionButton("open_contrast", "Open Contrast Generator")
               ),
               mainPanel(
                 textOutput("main_info")
               )
             )
           )
  ),
  
  tabPanel("Contrast Generator",
           fluidPage(
             tags$iframe(src = "https://github.com/MarcoMartinsGama/ContrastGenerator",
                         height = 800, width = "100%")
           )
  )
)

# Define server logic required for the main application
server <- function(input, output, session) {
  output$main_info <- renderText({
    "This is the main Shiny application."
  })
  
  observeEvent(input$open_contrast, {
    updateTabsetPanel(session, "tabs", selected = "Contrast Generator")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)