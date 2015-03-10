source("chooser.R")
library(dygraphs)
<<<<<<< HEAD
library(shinydashboard)
=======
>>>>>>> ce7cf436e4817c68bf64f6c842b269fa3f364ae6

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
<<<<<<< HEAD
#                     tabPanel("More detailled insights", renderDygraph("selection")),
=======
                    tabPanel("More detailled insights", renderDygraph("selection")),
>>>>>>> ce7cf436e4817c68bf64f6c842b269fa3f364ae6
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