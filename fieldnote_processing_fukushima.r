library(tidyverse)
library(readxl)
library(lubridate)
library(hms)
library(sf)

fieldnote_path<-"C:/Users/fukasawa/OneDrive - 国立環境研究所/福島調査野帳/2023/野帳_snapshot_2308.xlsx"
location_path<-"S:/common/gis_data/research_unit/randomcamera/f_camera_r_230405_jgd2000.shp"

fieldnote<-read_xlsx(fieldnote_path,sheet=1,range="A2:N100")
fieldnote<-fieldnote%>%filter(!is.na(startDate))
fieldnote$startDate<-as_date(fieldnote$startDate)
tz(fieldnote$startDate)<-"Japan"
fieldnote$startTime<-as_hms(fieldnote$startTime)

fieldnote$startDT<-paste(fieldnote$startDate,fieldnote$startTime)

######
##要修正
######
fieldnote$endDT<-"2023-10-30 15:00:00"

location<-st_read(location_path)
location$long<-location%>%st_coordinates()%>%as_tibble%>%select(X)
location$lat<-location%>%st_coordinates()%>%as_tibble%>%select(Y)

fieldnote$long<-fieldnote%>%left_join(location,by="locationID")%>%select(long)%>%unlist%>%c
fieldnote$lat<-fieldnote%>%left_join(location,by="locationID")%>%select(lat)%>%unlist%>%c

fieldnote_out<-fieldnote%>%select(-startDate,-startTime)

write_csv(fieldnote_out,"fieldnote_snapshot_2023_nies.csv")
