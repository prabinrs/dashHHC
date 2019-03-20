library(shinydashboard)
listDept<-c("aicu", "cicu", "hdu",  "nicu", "picu")
#page design 
dashboardPage(
  dashboardHeader(title = "Hand Hygine Compliance Surveillance"),
  dashboardSidebar(
    fileInput("HHCmainForm", "Select The main Form(not poortunity)",
              multiple = FALSE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    fileInput("HHCopp", "Select The files with opportunities",
              multiple = FALSE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    selectInput(inputId="slecDept",
                label= "Department",
                choices= listDept,
                multiple = TRUE),
    
    dateRangeInput('dateRange',
                   label = 'Select Date: yyyy-mm-dd',
                   start = Sys.Date() - 7, end = Sys.Date())
  ),
  dashboardBody(
    fluidRow(
      valueBoxOutput("Tobs"),
      valueBoxOutput("dept"),
      valueBoxOutput("disDate")
    ), 
    
    fluidRow(
      box(plotlyOutput("compliance")),
      box(plotlyOutput("Methods"))
    ),
    fluidRow(
      box(plotlyOutput("HHM", height= 400)),
      box(plotlyOutput("profession"))
      ),
    fluidRow(
      
    )
    
  )#body
 
)