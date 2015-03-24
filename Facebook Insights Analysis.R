library(xlsx)
library(googleVis)

Facebook_OFR_Post <-   read.xlsx(file = "Facebook Insights Data Export (Post Level) - Orange - 2015-02-17.xlsx", sheetIndex = 1)
Facebook_OFR_Post$Tx.d.engagement_Total <- Facebook_OFR_Post$Lifetime.Engaged.Users / Facebook_OFR_Post$Lifetime.Post.Total.Reach
Facebook_OFR_Post$Tx.d.engagement_Orga  <- Facebook_OFR_Post$Lifetime.Engaged.Users / Facebook_OFR_Post$Lifetime.Post.organic.reach
Facebook_OFR_Post$Post.Message    <- paste(substring(Facebook_OFR_Post$Post.Message, first = 1, last = 30), "...")

Facebook_Sosh_Post <- read.xlsx(file = "Facebook Insights Data Export (Post Level) - Sosh - 2015-02-17.xlsx",   sheetIndex = 1)
Facebook_Sosh_Post$Tx.d.engagement <- Facebook_Sosh_Post$Lifetime.Engaged.Users / Facebook_Sosh_Post$Lifetime.Post.Total.Reach
Facebook_Sosh_Post$Post.Message    <- paste(substring(Facebook_Sosh_Post$Post.Message, first = 1, last = 30), "...")

BubbleOFR <- gvisBubbleChart(
    Facebook_OFR_Post, 
    idvar = "Post.Message", 
    xvar = "Lifetime.Post.organic.reach", 
    yvar = "Tx.d.engagement_Total",
    colorvar="Type",
    sizevar="Lifetime.Engaged.Users",
    
    options=list(
        title = "Orange France : Performance des posts facebook",
        hAxis = "{title: 'Reach organique'}",
        vAxis = "{title: 'Taux d engagement : Engaged Users / Reach Total', format:'#,###%'}",
        width=1000, height=600, 
        explorer="{actions: [
            'dragToZoom',
            'rightClickToReset'],
        maxZoomIn:0.05}", 
        animation = "{
            duration: 1000,
            easing: 'out',
            startup: 'TRUE'
        }",
        
        bubble="{textStyle:{color: 'none'}}"
        )
    )

plot(BubbleOFR)


BubbleOFR_Orga <- gvisBubbleChart(
    Facebook_OFR_Post, 
    idvar = "Post.Message", 
    xvar = "Lifetime.Post.organic.reach", 
    yvar = "Tx.d.engagement_Orga",
    colorvar="Type",
    sizevar="Lifetime.Engaged.Users",
    
    options=list(
        title = "Orange France : Performance des posts facebook",
        hAxis = "{title: 'Organic Reach'}",
        vAxis = "{title: 'Taux d engagement : Engaged Users / Organic Reach', format:'#,###%'}",
        width=1000, height=600, 
        hAxis.gridlines.count = "{color: '#333', count: 2}",
        explorer="{actions: [
            'dragToZoom',
            'rightClickToReset'],
        maxZoomIn:0.05}", 
        animation = "{
            duration: 1000,
            easing: 'out',
            startup: 'TRUE'
        }",
        
        bubble="{textStyle:{color: 'none'}}"
    )
)
plot(BubbleOFR_Orga)

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
            startup: 'TRUE'
        }",
        
        bubble="{textStyle:{color: 'none'}}"
    )
)
plot(BubbleOFR_Total)




BubbleSosh <- gvisBubbleChart(
    Facebook_Sosh_Post, 
    idvar = "Post.Message", 
    yvar = "Lifetime.Post.organic.reach", 
    xvar = "Tx.d.engagement",
    colorvar="Type",
    sizevar="Lifetime.Engaged.Users",
    
    options=list(
        title = "Sosh : Performance des posts facebook",
        vAxis = "{title: 'Reach organique'}",
        hAxis = "{title: 'Taux d engagement : Engagés sur Reach Total', format:'#,###%'}",
        width=1000, height=600, 
        explorer="{actions: [
                    'dragToZoom',
                    'rightClickToReset'],
                maxZoomIn:0.05}", 
        bubble="{textStyle:{color: 'none'}}"
    )
)
plot(BubbleSosh)
