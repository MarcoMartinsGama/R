library(shiny)
library(DT)

function(input, output, session) {
  
  
  # Reactive value to store conditions and combinations
  rv <- reactiveValues(conditions = character(), combinations = data.frame(Combination = character()))
  
  # Read file and extract conditions
  observeEvent(input$file, {
    req(input$file)
    data <- read.table(input$file$datapath, header = TRUE, sep = "\t")
    unique_conditions <- unique(data$Condition)
    rv$conditions <- unique_conditions
    updateCheckboxGroupInput(session, "conditions", choices = rv$conditions)
  })
  
  # Add new condition
  observeEvent(input$add_condition, {
    new_condition <- input$new_condition
    if (new_condition != "" && !new_condition %in% rv$conditions) {
      rv$conditions <- c(rv$conditions, new_condition)
      updateCheckboxGroupInput(session, "conditions", choices = rv$conditions)
      updateTextInput(session, "new_condition", value = "")
    }
  })
  
  # Generate combinations
  observeEvent(input$generate, {
    selected_conditions <- input$conditions
    if (length(selected_conditions) > 1) {
      new_combinations <- combn(selected_conditions, 2, FUN = function(x) paste(x, collapse = "-"))
      new_combinations_df <- data.frame(Combination = new_combinations)
      rv$combinations <- rbind(rv$combinations, new_combinations_df)
      write.table(rv$combinations, "contrast.txt", row.names = FALSE, col.names = TRUE, sep = "\t", append = FALSE)
      output$output_text <- renderText({ "Combination(s) added to contrast.txt" })
    }
  })
  
  # Swap selected combinations
  observeEvent(input$swap, {
    selected_rows <- input$table_rows_selected
    if (!is.null(selected_rows) && length(selected_rows) > 0) {
      for (row in selected_rows) {
        combo <- unlist(strsplit(rv$combinations$Combination[row], "-"))
        swapped_combo <- paste(combo[2], combo[1], sep = "-")
        rv$combinations$Combination[row] <- swapped_combo
      }
      write.table(rv$combinations, "contrast.txt", row.names = FALSE, col.names = TRUE, sep = "\t", append = FALSE)
      output$output_text <- renderText({ "Selected combination(s) swapped in contrast.txt" })
    }
  })
  
  # Remove selected combinations
  observeEvent(input$remove, {
    selected_rows <- input$table_rows_selected
    if (!is.null(selected_rows) && length(selected_rows) > 0) {
      rv$combinations <- rv$combinations[-selected_rows, , drop = FALSE]
      write.table(rv$combinations, "contrast.txt", row.names = FALSE, col.names = TRUE, sep = "\t", append = FALSE)
      output$output_text <- renderText({ "Selected combination(s) removed from contrast.txt" })
    }
  })
  
  # Render DataTable
  output$table <- renderDT({
    rv$combinations
  }, selection = 'multiple')
  
  # Download button handler
  output$downloadData <- downloadHandler(
    filename = function() {
      "contrast.txt"
    },
    content = function(file) {
      write.table(rv$combinations, file, row.names = FALSE, col.names = FALSE, sep = "\t")
    }
  )
}