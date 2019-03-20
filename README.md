# dashHHC

## Background
The app was develope for "Improving Hand Hygiene Compliance through Dashboard" study implemented at Dhulikhel Hospital Kathmandu University hospital, Nepal. 

## How to Run the app 
First install the required packages: 
```
list.of.packages <- c("shiny", "shinydashboard", "sjPlot", "sjmisc", "tidyverse", "plotly", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)})
```

Now you can run shiny app by:
```
runGitHub("dashHHC", "prabinrs")
```

## ODK Data collection forms(app):


## Demo 
The demo of the app is avaliable at https://prabinrs.shinyapps.io/dashHHC/ , 
The user have to upload the datasets, 
1. ICU datasets and 
2. opportunity recorded data set.<br>
For more information please refer to ODK data collection app section above
