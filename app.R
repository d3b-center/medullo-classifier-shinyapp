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

# example data for download
load('data/GSE109401_exprs.RData')
load('data/GSE109401_meta.RData')

ui <- dashboardPage(
  dashboardHeader(title = "Medullo Classifier"),
  dashboardSidebar(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"))
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(width = 8, background = "navy",
          column(5, fileInput(inputId = "exprinput",
                    label = "Expression Matrix",
                    multiple = F)),
          column(5, fileInput(inputId = "metainput",
                    label = "Subtype Info (Optional)",
                    multiple = F)),
          column(2, selectInput("ext", "Type",
                       choices = c("TSV" = "tsv",
                                   "RData" = "RData",
                                   "RDS" = "RDS"), selected = "RData")),
          br(),
          column(width = 3, actionButton(inputId = "submit1", label = "Run Classifier", 
                                         icon = icon("paper-plane")))),
      box(width = 4, background = "navy",
          column(5, selectInput("dataset", "Download Example Data",
                                choices = c("TSV" = ".tsv",
                                            "RData" = ".RData",
                                            "RDS" = ".RDS"), selected = "RData"),
                 style='padding-top:15px;'),
          br(),
          column(4, downloadButton("downloadExpr", "Expression Matrix")),
          br(), br(),
          column(4, downloadButton("downloadMeta", "Subtype Info")))
    ),
    tabsetPanel(type = "tabs",
                tabPanel("Prediction", dataTableOutput(outputId = "tab1")),
                tabPanel("Confusion Matrix", dataTableOutput(outputId = "tab2")),
                tabPanel("Overall Statistics", dataTableOutput(outputId = "tab3")),
                tabPanel("By Class", dataTableOutput(outputId = "tab4")))
  )
)

server <- function(input, output) {

  # fileInput
  path2file <- reactive({
    infile <- input$exprinput
    metafile <- input$metainput
    extension <- input$ext
    c(infile$datapath, extension, metafile$datapath)
  })

  create.res <- reactive({
    validate(
      need(input$submit1, "Please hit submit!")
    )
    expr <- path2file()[1]
    extension <- path2file()[2]
    meta <- path2file()[3]
    print(meta)
    withProgress(message = "Classifying subtypes...", detail = "Computing stats...", min = 1, value = 10, max = 10,{
      res <<- readandclassify(expr, meta, ext = extension)
    })
  })

  output$tab1 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      viewDataTable(create.res()$pred,  pageLength = 4)
    })
  })

  output$tab2 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      if(!is.na(create.res()$accuracy)){
        viewDataTable(create.res()$accuracy[[1]], pageLength = 7)
      }
    })
  })

  output$tab3 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      if(!is.na(create.res()$accuracy)){
        viewDataTable(create.res()$accuracy[[2]], pageLength = 4)
      }
    })
  })

  output$tab4 <- DT::renderDataTable({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      if(!is.na(create.res()$accuracy)){
        viewDataTable(create.res()$accuracy[[3]], pageLength = 4)
      }
    })
  })
  
  # Download example expression matrix
  output$downloadExpr <- downloadHandler(
    filename = function() {
      paste0('GSE109401_exprs', input$dataset)
    },
    content = function(file) {
      if(input$dataset == ".tsv"){
        write.table(exprs_109401, file = file, quote = F, sep = "\t")
      } else if(input$dataset == ".RData"){
        save(exprs_109401, file = file)
      } else {
        saveRDS(exprs_109401, file = file)
      }
    }
  )
  output$downloadMeta <- downloadHandler(
    filename = function() {
      paste0('GSE109401_meta', input$dataset)
    },
    content = function(file) {
      if(input$dataset == ".tsv"){
        write.table(meta_109401, file = file, quote = F, sep = "\t", row.names = F, col.names = F)
      } else if(input$dataset == ".RData"){
        save(meta_109401, file = file)
      } else {
        saveRDS(meta_109401, file = file)
      }
    }
  )

}

shinyApp(ui, server)
