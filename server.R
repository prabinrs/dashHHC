library(shiny)
library(shinydashboard)
library(sjPlot)
library(sjmisc)
library(jsonlite)
library(tidyverse)
library(plotly)


#source("pulldata.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  HHCdata<-reactive({
    HHCmainLink<-input$HHCmainForm
    HHCoppLink<-input$HHCopp
    if(is.null(HHCmainLink) || is.null(HHCoppLink)){
      return(NULL)
    } 
    HHCmainForm <- read.csv(input$HHCmainForm$datapath)
    HHCopp<-read.csv(input$HHCopp$datapath)
    HHCmerge<-left_join(HHCmainForm,HHCopp, by = c("ï..number"="number__0"))
    HHCmerge$Compliance<-ifelse (HHCmerge$handHygieneAction=="missed", "NO", "Yes")
    HHCmerge$Date<-as.Date(HHCmerge$Date,"%Y-%m-%d")
    HHCmerge$Departemnt<-as.factor(HHCmerge$Departemnt)
    HHCmerge$Compliance<-as.factor(HHCmerge$Compliance)
    HHCmerge$Indication<-recode(HHCmerge$Indication, "after_body_fluid_exposure_risk" = "After body fluid exposure risk",
           "after_patient_care" = "After patient care",
           "after_patient_surrounding" = "After patient surrounding",
           "before_aseptic_procedure" = "Before aseptic procedure",
           "before_patient_care" = "Before patient care")
    HHCmerge$Prof_Category<-recode(HHCmerge$Prof_Category, "doctor"="Doctor",
                                   "nurse"="Nurse",
                                   "others" = "Others",
                                   "physiotherapist"="Phsyiotherapist")
    HHCmerge$handHygieneAction<-recode(HHCmerge$handHygieneAction,
                                       "hand_rub" = "Hand Rub", 
                                       "hand_wash"="Hand Wash", 
                                       "missed"="Missed" )
    return(HHCmerge)
    })
 
  #infobox for general data 
   
  
  HHCdata2<-reactive({
    selected.data<-HHCdata()[HHCdata()$Date %in% seq(from=as.Date(input$dateRange[1]), to =as.Date(input$dateRange[2]), by="day"),]
    selected.data2<-selected.data[selected.data$Departemnt %in% input$slecDept,]
    if(is.null(input$slecDept))
       return(selected.data)else
       return(selected.data2) 
  })
  
  output$Tobs<-renderValueBox({
    valueBox(print(nrow(HHCdata2())), 
             subtitle="Observations",
             icon = icon("child"), 
             color = "purple") 
  })
  
  output$dept<-renderValueBox({
    valueBox(as.character(input$slecDept),
             subtitle = "Departments",
             icon = icon("bed"))
  })
  
  output$disDate<-renderValueBox({
    valueBox(paste(as.character(input$dateRange[1]), "to",as.character(input$dateRange[2])), 
             subtitle = "Starting Date",
             color ="red")
  })
  
  #Table of compliance 
  output$compliance<- renderPlotly({
    HHCdata2()%>%group_by(Compliance)%>%
      summarise(count=n())%>%
      plot_ly(labels=~Compliance, values=~count, type="pie", 
              textinfo = 'label+percent', textposition='inside',
              textfont = list(color = '#000000', size = 16))%>%
      layout(title = 'Hand Hygine Compliance',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })

  #Plots by Methods
  output$Methods<-renderPlotly({
    HHCdata2()%>%
        filter(handHygieneAction!="missed")%>%
      filter(handHygieneAction!="")%>%
      count(handHygieneAction)%>%
      plot_ly(x=~handHygieneAction, y=~n, text = ~n, textposition = 'auto')%>%
      layout(title = "Hand Hygine Methods Used")
    })
  #Plots by Five moments
    output$HHM<-renderPlotly({
      HHCdata2()%>%
        filter(Indication!="")%>%
      count(Indication, Compliance)%>%
        plot_ly(x=~n, y=~Indication, color = ~Compliance,text=~n, textposition = 'auto')%>%
        layout(title="Hand Hygine Compliance by Inbdications", barmode= 'stack',
               yaxis= list(title="",
                           zeroline = FALSE,
                           showline = FALSE,
                           showticklabels = TRUE,
                           showgrid = FALSE),
               xaxis = list(
                 title = "",
                 showline = FALSE,
                 showticklabels =FALSE,
                 showgrid = FALSE,
                 domain = list(0.3, 1)))%>%
        add_bars()
    })
  #Plots by Department 
    output$profession<-renderPlotly({
       HHCdata2()%>%
        filter(Prof_Category!="")%>%
        count(Prof_Category, Compliance)%>%
        plot_ly(y=~Prof_Category, x= ~n, color=~Compliance, text=~n, textposition = 'auto')%>%
        add_bars()%>%
        layout(barmode = 'stack', title = "Hand Hygine Compliance by Profession")
     })

})
