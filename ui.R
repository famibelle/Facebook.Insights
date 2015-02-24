shinyUI(
    fluidPage(
        titlePanel("Service d'analyse des Insights des Posts Facebook (beta)"),
        verticalLayout(
            mainPanel(
                tabsetPanel(
                    tabPanel("Graphique à Bulles", htmlOutput("grafics")),
                    tabPanel("Insights", htmlOutput("contents")),
                    tabPanel("Analyse dynamique des posts", htmlOutput("motion")),
                    tabPanel("Readme", htmlOutput("readme"))
                )
            ),
            sidebarPanel(
                fileInput('file1', 'Choisissez un fichier à uploader',
                          accept = c(
                              'text/csv',
                              'text/comma-separated-values',
                              'text/tab-separated-values',
                              'text/plain',
                              '.csv',
                              '.tsv',
                              '.xlsx'
                          )
                )
        #         numericInput('sheetIndex', 'SheetIndex', 1)
                
                )
            
        )
    )
)