library(googleVis)
library(xlsx)
library(plyr)
library(lubridate)
library(xts)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
    reactive_Facebook <- reactive({
        validate(
            need(input$file1 != "", "Aucun fichier n'a été uploadé pour le moment")
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
            sheetIndex = 1,
            startRow = 3, 
            header = FALSE
        )
    
        facebook.insight.colTitle <- read.xlsx2(
            inFile$datapath, 
            sheetIndex = 1,
            startRow = 1, 
            endRow = 2,
            stringsAsFactors = FALSE
        )
            
    colnames(facebook.insight) <- colnames(facebook.insight.colTitle)
<<<<<<< HEAD
    
    # erase uploaded file once all the data have been uploaded
    unlink(inFile$datapath)
    
=======
>>>>>>> ce7cf436e4817c68bf64f6c842b269fa3f364ae6
    return(facebook.insight)
    })


############################ Chooser ############################
    output$selection <- renderDygraph(
        withProgress(message = 'Extraction et analyse du fichier en cours ',
                     detail = 'Patience...', value = 0, {
                         facebook.insight <- reactive_Facebook()
                     })
        
#         facebook.insight.TimeSerie <- xts(facebook.insight[,-7], order.by = facebook.insight$Posted)
#         dygraph(facebook.insight.TimeSerie[,input$mychooser])
    )
    
############################ insigth table ############################
    output$contents <- renderGvis({
        withProgress(message = 'Extraction et analyse du fichier...',
                     detail = 'Patience...', value = 0, {
                         Facebook_OFR_Post <- reactive_Facebook()
                     })
        
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
        

        #Coerce Posted to class Date
        Facebook_OFR_Post$Posted <- as.Date(Facebook_OFR_Post$Posted)
        #Remove duplicate entries
        duplicate <- which(duplicated(Facebook_OFR_Post$Posted))
        Facebook_OFR_Post <- Facebook_OFR_Post[-duplicate,]
        
        ## Set initial state with a few regions selected and a log y-axes
        myState <- '
            {"showTrails":false,
            "colorOption":"_UNIQUE_COLOR",
            "playDuration":150000}
        '
        titre = paste("Performance des posts facebook: du", 
                      format(min(Facebook_OFR_Post$Posted), format="%d %B %Y"),
                      "au",
                      format(max(Facebook_OFR_Post$Posted), format="%d %B %Y")
        )
                
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
    
############################ Videos insights ############################
output$dygraph <- renderDygraph({
    withProgress(message = 'Extraction et analyse du fichier en cours ',
                 detail = 'Patience...', value = 0, {
                     facebook.insight <- reactive_Facebook()
                 })

    titre = paste("Performance des vidéos du ", 
                  format(min(Facebook_OFR_Post$Posted), format="%d %B %Y"),
                  "au",
                  format(max(Facebook_OFR_Post$Posted), format="%d %B %Y")
    )
    
    facebook.insight.TimeSerie <- xts(facebook.insight[,-7], order.by = facebook.insight$Posted)
    
    dygraph(facebook.insight.TimeSerie[,c(
        "Lifetime.Organic.Video.Views",                                      
        "Lifetime.Paid.Video.Views"
        )],
        main = titre) %>%
        dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
        dySeries(name = "Lifetime.Organic.Video.Views",   label = "Lifetime Organic Video Views") %>%
        dySeries(name = "Lifetime.Paid.Video.Views",      label = "Paid Video Views") %>%
<<<<<<< HEAD
        dyLegend(show = "always", hideOnMouseOut = TRUE) %>%
        dyRangeSelector(keepMouseZoom = TRUE) %>%
        dyOptions(animatedZooms = TRUE, labelsKMB = TRUE, logscale = TRUE)
=======
        dyOptions(animatedZooms = TRUE, labelsKMB = TRUE) %>%
        dyRangeSelector(keepMouseZoom = TRUE)
>>>>>>> ce7cf436e4817c68bf64f6c842b269fa3f364ae6
})


############################ Bubble Plot ############################
    output$grafics <- renderGvis({
        withProgress(message = 'Extraction et analyse du fichier',
                     detail = 'Patience...', value = 0, {
                         Facebook_OFR_Post <- reactive_Facebook()
                     })
<<<<<<< HEAD

        Facebook_OFR_Post$Tx.d.engagement_Total         <- Facebook_OFR_Post$Lifetime.Engaged.Users / Facebook_OFR_Post$Lifetime.Post.Total.Reach
        Facebook_OFR_Post$Tx.d.engagement_Orga          <- Facebook_OFR_Post$Lifetime.Engaged.Users / Facebook_OFR_Post$Lifetime.Post.organic.reach
        Facebook_OFR_Post$Post.Message                  <- paste(substring(Facebook_OFR_Post$Post.Message, first = 1, last = 30), "...")
        Facebook_OFR_Post$Lifetime.Post.Total.Reach.log <- log(Facebook_OFR_Post$Lifetime.Post.Total.Reach)
=======
>>>>>>> ce7cf436e4817c68bf64f6c842b269fa3f364ae6

        Facebook_OFR_Post[Facebook_OFR_Post$Lifetime.Post.Paid.Reach != 0, "Paid"] <- paste(Facebook_OFR_Post[Facebook_OFR_Post$Lifetime.Post.Paid.Reach != 0,"Type"], "Paid")
        Facebook_OFR_Post[is.na(Facebook_OFR_Post$Paid), "Paid"] <- as.character(Facebook_OFR_Post[is.na(Facebook_OFR_Post$Paid), "Type"])
        Facebook_OFR_Post$Type <- as.factor(Facebook_OFR_Post$Paid)

<<<<<<< HEAD
        Facebook_OFR_Post <- Facebook_OFR_Post[order(Facebook_OFR_Post$Type),]
        
=======
>>>>>>> ce7cf436e4817c68bf64f6c842b269fa3f364ae6
        titre = paste("Performance des posts facebook: du", 
                      format(min(Facebook_OFR_Post$Posted), format="%d %B %Y"),
                      "au",
                      format(max(Facebook_OFR_Post$Posted), format="%d %B %Y")
        )
        
        optionsList <- list(
            title = titre,
            hAxis = "{title: 'Total Reach', logScale: true}",
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
            bubble="{textStyle:{color: 'none'}}",
            series= "{'Link': {color: '#00CC00'},'Link Paid': {color: '#00FF00'},'Photo': {color: 'FFCC00'},'Photo Paid': {color: '#FFFF00'},'Video': {color: '#00CCFF'},'Video Paid': {color: '#00FFFF'}}",
            gvis.editor="Edit me!"
        )
        
        BubbleOFR_Total <- gvisBubbleChart(
            Facebook_OFR_Post, 
            idvar = "Post.Message", 
            xvar = "Lifetime.Post.Total.Reach", 
            yvar = "Tx.d.engagement_Total",
            colorvar="Type",
            sizevar="Lifetime.Engaged.Users",
            chartid = "FacebookBubblePlot",
            options = optionsList
        )
        return(BubbleOFR_Total)
    })
})