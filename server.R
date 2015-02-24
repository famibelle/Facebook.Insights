library(googleVis)
library(xlsx)
library(plyr)
library(lubridate)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
    reactive_Facebook <- reactive({
        validate(
            need(input$file1 != "", "Auncun fichier n'a été uploadé pour le moment")
        )
        
        
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.
        inFile <- input$file1
        if (is.null(inFile))
            return(NULL)

        facebook.insight <- read.xlsx(
            inFile$datapath, 
#             sheetIndex = input$sheetIndex,
            sheetIndex = 1,
            stringsAsFactors=FALSE
            )
        facebook.insight <- facebook.insight[-1,]
#         class(facebook.insight$Lifetime.Post.Total.Reach) <- "numeric"
#         class(facebook.insight$Lifetime.Post.organic.reach) <- "numeric"
#         class(facebook.insight$Lifetime.Engaged.Users) <- "numeric"
#         class(facebook.insight$Posted) <- "numeric"        
        cat("reactive_Facebook")
        cat(paste(sapply(Facebook_OFR_Post,class), sep="\n"))
        return(facebook.insight)
    })

############################ insigth table ############################
    output$contents <- renderGvis({
        withProgress(message = 'Extraction et analyse du fichier...',
                     detail = 'Patience...', value = 0, {
                         Facebook_OFR_Post <- reactive_Facebook()
                     })
        
        class(Facebook_OFR_Post$Posted) <- "numeric"
        Facebook_OFR_Post$Posted <- as.Date(Facebook_OFR_Post$Posted, origin = "1900-01-01")
        
        InsightTable <- gvisTable(
            Facebook_OFR_Post,
            formats=list(Lifetime.Post.Total.Reach="#,###"),
            options=list(page='enable')
        )
        return(InsightTable)
    })
    
############################ Motion Plot ############################    
    output$motion <- renderGvis({
        withProgress(message = 'Extraction et analyse du fichier en cours ',
                     detail = 'Patience...', value = 0, {
                         Facebook_OFR_Post <- reactive_Facebook()
                     })
        
        class(Facebook_OFR_Post$Lifetime.Post.organic.reach)  <- "numeric"
        class(Facebook_OFR_Post$Lifetime.Post.Total.Reach)  <- "numeric"
        class(Facebook_OFR_Post$Lifetime.Engaged.Users)  <- "numeric"
                
        #Coerce Posted to class Date
        class(Facebook_OFR_Post$Posted) <- "numeric"
        Facebook_OFR_Post$Posted <- as.Date(Facebook_OFR_Post$Posted, origin = "1900-01-01")-2 #In the Excel 1900 date system, the Excel serial date number 1 corresponds to January 1, 1900 A.D. In the Excel 1904 date system, date number 0 is January 1, 1904 A.D.
        Facebook_OFR_Post$Posted <- as.character(Facebook_OFR_Post$Posted)
        #Remove duplicate entries
        duplicate <- which(duplicated(Facebook_OFR_Post$Posted))
        Facebook_OFR_Post <- Facebook_OFR_Post[-duplicate,]
        
        Facebook_OFR_Post$Posted <- as.Date(Facebook_OFR_Post$Posted, origin = "1900-01-01") #In the Excel 1900 date system, the Excel serial date number 1 corresponds to January 1, 1900 A.D. In the Excel 1904 date system, date number 0 is January 1, 1904 A.D.

        ## Set initial state with a few regions selected and a log y-axes
        myState <- '
            {"showTrails":false,
            "colorOption":"_UNIQUE_COLOR",
            "playDuration":150000}
        '

        Motion <- gvisMotionChart(
            Facebook_OFR_Post, 
            idvar = "Type", 
            yvar = "Lifetime.Post.organic.reach", 
            xvar = "Lifetime.Post.Total.Reach",
            sizevar="Lifetime.Engaged.Users",
            timevar="Posted",
            options=list(
                width="640px", height="480px",
                state = myState
            )
        )
        return(Motion)
    })
    

############################ bubble Plot ############################
    output$grafics <- renderGvis({
        withProgress(message = 'Extraction et analyse du fichier',
                     detail = 'Patience...', value = 0, {
                         Facebook_OFR_Post <- reactive_Facebook()
                     })
#         class(Facebook_OFR_Post$Posted) <- "numeric"
#         Facebook_OFR_Post$Posted <- as.Date(Facebook_OFR_Post$Posted, origin = "1900-01-01")
        class(Facebook_OFR_Post$Lifetime.Post.Total.Reach) <- "numeric"
        class(Facebook_OFR_Post$Lifetime.Post.organic.reach) <- "numeric"
        class(Facebook_OFR_Post$Lifetime.Engaged.Users) <- "numeric"
        class(Facebook_OFR_Post$Posted) <- "numeric"
        Facebook_OFR_Post$Posted <- as.Date(Facebook_OFR_Post$Posted, origin = "1900-01-01")-2

        cat("Bubble Plot")
        cat("\n")
        cat(paste(sapply(Facebook_OFR_Post,class), sep="\n"))

        Facebook_OFR_Post$Tx.d.engagement_Total <- Facebook_OFR_Post$Lifetime.Engaged.Users / Facebook_OFR_Post$Lifetime.Post.Total.Reach
        Facebook_OFR_Post$Tx.d.engagement_Orga  <- Facebook_OFR_Post$Lifetime.Engaged.Users / Facebook_OFR_Post$Lifetime.Post.organic.reach
        Facebook_OFR_Post$Post.Message    <- paste(substring(Facebook_OFR_Post$Post.Message, first = 1, last = 30), "...")

#         titre = paste("Orange France : Performance des posts facebook")
        titre = paste("Orange France : Performance des posts facebook: du", 
                      min(Facebook_OFR_Post$Posted),
                      "au",
                      max(Facebook_OFR_Post$Posted)
        )
        
        BubbleOFR_Total <- gvisBubbleChart(
            Facebook_OFR_Post, 
            idvar = "Post.Message", 
            xvar = "Lifetime.Post.Total.Reach", 
            yvar = "Tx.d.engagement_Total",
            colorvar="Type",
            sizevar="Lifetime.Engaged.Users",
            
            options=list(
                title = titre,
                hAxis = "{title: 'Total Reach'}",
                vAxis = "{title: 'Taux d engagement : Engaged Users / Total Reach', format:'#,###%'}",
                width=1000, height=600, 
                hAxis.gridlines.count = "{color: '#333', count: 2}",
                explorer="{actions: [
                'dragToZoom',
                'rightClickToReset'],
                maxZoomIn:0.05}", 
                animation = "{
                    duration: 2000,
                    easing: 'out',
                startup: 'TRUE'}",
        
                bubble="{textStyle:{color: 'none'}}"
            )
        )
        return(BubbleOFR_Total)
    })
})
