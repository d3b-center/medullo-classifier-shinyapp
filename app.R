library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyIncubator)
library(DT)
library(medulloPackage)

library(BiocManager)
options(repos = BiocManager::repositories())
options(gsubfn.engine = "R")
options(shiny.sanitize.errors = TRUE)
options(shiny.maxRequestSize = 500*1024^2)
source('R/readandclassify.R')
source('R/viewDataTable.R')

ui <- dashboardPage(
  dashboardHeader(title = "Medullo Classifier"),
  dashboardSidebar(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"))
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(width = 12, background = "navy",
          column(5, fileInput(inputId = "exprinput",
                    label = "Input Expression Matrix",
                    multiple = F)),
          column(5, fileInput(inputId = "metainput",
                    label = "Input Metadata",
                    multiple = F)),
          column(2, radioButtons("ext", "Type",
                       choices = c("TAB Delimited" = "tab",
                                   "RData" = "RData",
                                   "RDS" = "RDS"), selected = "RData")),
          br(), br(),
          # tags$head(
          #   tags$style(HTML('#submit1{background-color:gray}'))
          # ),
          column(width = 3, actionButton(inputId = "submit1", label = "Run Classifier", icon = icon("paper-plane")),
                 offset = 0, style='padding-left:15px;'))
    ),
    tabsetPanel(type = "tabs",
                tabPanel("Prediction", dataTableOutput(outputId = "tab1")),
                tabPanel("Confusion Matrix", dataTableOutput(outputId = "tab2")),
                tabPanel("Overall Statistics", dataTableOutput(outputId = "tab3")),
                tabPanel("By Class", dataTableOutput(outputId = "tab4")))
  )
)

server <- function(input, output) {

  observe({
    if(is.null(input$exprinput) && is.null(input$metainput)) {
      shinyjs::disable("submit1")
    } else {
      shinyjs::enable("submit1")
    }
  })

  # fileInput
  path2file <- reactive({
    shinyjs::disable("submit1")
    infile <- input$exprinput
    metafile <- input$metainput
    extension <- input$ext
    if (is.null(infile) | is.null(metafile)){
      shinyjs::disable("submit1")
      return(NULL)
    }
    shinyjs::enable("submit1")
    c(infile$datapath, metafile$datapath, extension)
  })

  observe({
    if(input$submit1 == 0){
      return()
    }
    expr <- path2file()[1]
    meta <- path2file()[2]
    extension <- path2file()[3]
    withProgress(message = "Classifying subtypes...", detail = "Computing stats...", min = 1, value = 10, max = 10,{
    res <<- readandclassify(expr, meta, ext = extension)
    })
  })

  output$tab1 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      viewDataTable(res[[2]], pageLength = 4)
    })
  })

  output$tab2 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      viewDataTable(res[[1]][[1]], pageLength = 7)
    })
  })

  output$tab3 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      viewDataTable(res[[1]][[2]], pageLength = 4)
    })
  })

  output$tab4 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      viewDataTable(res[[1]][[3]], pageLength = 4)
    })
  })

}

shinyApp(ui, server)
