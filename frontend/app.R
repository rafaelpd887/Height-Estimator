library(shiny)
library(httr)

load("data/questionnaire_text_structure.RData")
questions <- as.character(questionnaire[1, 1:14])
API_URL <- Sys.getenv("API_URL")

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      body { background-color: #f5f6fa; }
      .card {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0px 4px 12px rgba(0,0,0,0.1);
        max-width: 600px;
        margin: auto;
        margin-top: 80px;
        text-align: center;
      }
      .btn-large {
        width: 120px;
        height: 50px;
        font-size: 18px;
        margin: 10px;
      }
    "))
  ),
  
  div(class = "card",
      h2("Height Estimator"),
      br(),
      uiOutput("progress_text"),
      br(),
      uiOutput("question_ui"),
      br(),
      uiOutput("buttons_ui"),
      br(),
      verbatimTextOutput("result"),
      br(),
      uiOutput("restart_ui")
  )
)

server <- function(input, output, session) {
  
  rv <- reactiveValues(
    index = 1,
    answers = numeric(0),          
    finished = FALSE
  )
  
  output$progress_text <- renderUI({
    if (!rv$finished) {
      h4(paste("Question", rv$index, "of", length(questions)))
    }
  })
  
  output$question_ui <- renderUI({
    if (!rv$finished) {
      h3(questions[rv$index])
    }
  })
  
  output$buttons_ui <- renderUI({
    if (!rv$finished) {
      tagList(
        actionButton("yes", "Yes", class = "btn btn-success btn-large"),
        actionButton("no", "No", class = "btn btn-danger btn-large")
      )
    }
  })
  
  # Helper function to handle the API response (used for buttons Yes and No)
  process_api_response <- function(response) {
    if (http_error(response)) {
      return("Erro na conexão com a API.")
    }
    
    result <- content(response, as = "parsed", type = "application/json")
    
    if (is.null(result) || is.null(result$height)) {
      return("Resposta da API inválida.")
    }
    
    # Robust handling
    height_raw <- result$height
    if (is.list(height_raw) && length(height_raw) == 1) {
      height_raw <- height_raw[[1]]
    }
    
    # Safely converts
    height_num <- suppressWarnings(as.numeric(as.character(height_raw)))
    
    if (is.na(height_num) || !is.finite(height_num)) {
      return("Não foi possível estimar a altura (valor inválido).")
    }
    
    paste("Estimated height:", round(height_num, 2), "meters")
  }
  
  observeEvent(input$yes, {
    rv$answers <- c(rv$answers, 1L)
    rv$index <- rv$index + 1
    
    if (rv$index > length(questions)) {
      rv$finished <- TRUE
      
      response <- POST(
        API_URL,
        body = list(answers = rv$answers),
        encode = "json"
      )
      
      output$result <- renderText({
        process_api_response(response)
      })
    }
  })
  
  observeEvent(input$no, {
    rv$answers <- c(rv$answers, 0L)
    rv$index <- rv$index + 1
    
    if (rv$index > length(questions)) {
      rv$finished <- TRUE
      
      response <- POST(
        API_URL,
        body = list(answers = rv$answers),
        encode = "json"
      )
      
      output$result <- renderText({
        process_api_response(response)
      })
    }
  })
  
  output$restart_ui <- renderUI({
    if (rv$finished) {
      actionButton("restart", "Restart", class = "btn btn-primary")
    }
  })
  
  observeEvent(input$restart, {
    rv$index <- 1
    rv$answers <- numeric(0)
    rv$finished <- FALSE
    output$result <- renderText("")
  })
}

shinyApp(ui, server)
