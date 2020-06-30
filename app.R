library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyIncubator)
library(DT)
library(medulloPackage)
library(shinyBS)
library(shinyhelper)
library(tidyverse)
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
                    multiple = F) %>% helper(colour = "red",
                                             fade = T, type = "markdown",
                                             content = "Expression", size = "l")),
          column(5, fileInput(inputId = "metainput",
                    label = "Subtype Info (Optional)",
                    multiple = F) %>% helper(colour = "red",
                                             fade = T, type = "markdown",
                                             content = "Subtype", size = "l")),
          column(2, selectInput("ext", "Type",
                       choices = c("TSV" = "tsv",
                                   "RData" = "RData",
                                   "RDS" = "RDS"), selected = "RData") %>% helper(colour = "red",
                                                                                  fade = T, type = "inline",
                                                                                  title = "Allowed File Types",
                                                                                  content = c("Input files are limited to these file types"),
                                                                                  size = "s")),
          br(),
          column(width = 3, actionButton(inputId = "submit1", label = "Run Classifier", icon = icon("paper-plane"))),
          bsTooltip(id = "submit1", title = "Please upload expression matrix and subtype info (optional) before running classifier", placement = "top", trigger = "hover", options = NULL)),
      box(width = 4, background = "navy",
          column(7, selectInput("dataset", "Download Example Data",
                                choices = c("TSV" = ".tsv",
                                            "RData" = ".RData",
                                            "RDS" = ".RDS"), selected = ".RData") %>%
                   helper(colour = "red",
                          fade = T, type = "inline",
                          title = "Download Example Data",
                          content = c("Download example data by selecting the file extension of choice and hitting the download button."),
                          size = "m")),
          br(),
          column(7, style="margin-top:20px", downloadButton("downloadExpr", "Expression Matrix")),
          br(),
          column(5, style="margin-top:20px", downloadButton("downloadMeta", "Subtype Info")),
          bsTooltip(id = "downloadExpr", title = "Download Expression Matrix", placement = "top", trigger = "hover", options = NULL),
          bsTooltip(id = "downloadMeta", title = "Download Subtype info", placement = "top", trigger = "hover", options = NULL))
    ),
    tags$head(tags$style(HTML('
     .nav-tabs-custom > .nav-tabs > li.header {
         font-size: 14px;
         font-weight: bold;
         color: navy; 
     }'))),
    tabBox(title = "",
           side = "left",
           tabPanel("Prediction",  helper("", colour = "red", content = "Table of predicted MB subtypes and p-values for each sample", fade = T, type = "inline", size = "s"), dataTableOutput(outputId = "tab1"))),
    tabBox(title = "Accuracy Testing",
           side = "right",
           selected = "Confusion Matrix",
           type = "tabs",
           tabPanel("Subtype Statistics", helper("", colour = "red", content = "Describes the % Sensitivity and % Specificity metrics per MB subtype", fade = T, type = "inline", size = "m"), dataTableOutput(outputId = "tab4")),
           tabPanel("Accuracy Statistics", helper("", colour = "red", content = "Describes the % Accuracy metric", fade = T, type = "inline", size = "m"), dataTableOutput(outputId = "tab3")),
           tabPanel("Confusion Matrix", helper("", colour = "red", content = "Confusion matrix to describe classifier performance", fade = T, type = "inline", size = "m"), dataTableOutput(outputId = "tab2"))
           )
  )
)

server <- function(input, output) {

  observe_helpers(withMathJax = TRUE)

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
      viewDataTable(create.res()$pred %>% remove_rownames(),  pageLength = 4)
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
