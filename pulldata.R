#library 
library(RCurl)
library(jsonlite)

#Pull forms information 
getURL("https://kc.kobotoolbox.org/api/v1/data", userpwd="bedana:chocolate5505", httpauth = 1L)

HHCdata<- getURL("https://kc.kobotoolbox.org/api/v1/data/60472", userpwd="bedana:chocolate5505", httpauth = 1L)
HHCdata<-as.data.frame(fromJSON(HHCdata, flatten = TRUE ))

#Total Number of Observation 
nrow(HHCdata)
HHCdata$Compliance<-ifelse (HHCdata$methodHH=="missed", "Yes", "No")
HHCdata$date<-as.Date(HHCdata$date,"%Y-%m-%d")
HHCdata$department<-as.factor(HHCdata$department)
HHCdata$Compliance<-as.factor(HHCdata$Compliance)