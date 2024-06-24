library(shiny)

ui <- fluidPage(
  titlePanel("Main Shiny App with Embedded Shiny App"),
  sidebarLayout(
    sidebarPanel(
      p("This is the main Shiny app.")
    ),
    mainPanel(
      h3("Embedded Shiny App"),
      tags$iframe(
        src = "QC/App/",  # Path to the subdirectory containing the first Shiny app
        width = "100%",
        height = "600px",
        frameborder = "0"
      )
    )
  )
)

server <- function(input, output) {
  # No server logic needed for this simple example
}

shinyApp(ui = ui, server = server)