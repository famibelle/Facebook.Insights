source("chooser.R")
library(dygraphs)
library(shinydashboard)

shinyUI(
    fluidPage(
        titlePanel("Service d'analyse des Insights des Posts Facebook (beta)"),
        
        verticalLayout(
            mainPanel(
                tabsetPanel(
                    tabPanel("Graphique à Bulles", htmlOutput("grafics")),
                    tabPanel("Analyse dynamique des posts", htmlOutput("motion")),
                    tabPanel("Analyse des statistiques des vidéos", dygraphOutput("dygraph")),
                    tabPanel("Insights", htmlOutput("contents")),
#                     tabPanel("More detailled insights", renderDygraph("selection")),
                    tabPanel("Readme", htmlOutput("readme"))
                )
            ),
            sidebarPanel(
                fileInput('file1', 'Choisissez un fichier à uploader',
                          accept = c(
                              'text/csv',
                              'text/comma-separated-values',
                              'text/tab-separated-values',
                              '.xlsx',
                              '.xls'
                          )
                )
#                 chooserInput("mychooser", "Available frobs", "Selected frobs",
#                              names(facebook.insight)[8:33], c(), size = 10, multiple = TRUE
#                 )
            )
        )   
    )
)