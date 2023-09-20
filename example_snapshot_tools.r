library(tidyverse)
library(jsonlite)

source("functions_snapshot_tools.r")

###地点名、カメラ番号、位置、日時が入ったcsv
#日付は"yyyy-mm-dd hh:mm:ss"の形式で記述、日本標準時
#緯度経度は10進、JGD2000やWGS84など世界測地系
fieldnote_path<-"fieldnote_snapshot_2023_nies.csv"
fieldnote<-read_csv(fieldnote_path)
view(fieldnote)

###Snapshot Japanに共通の設定ファイル
setting_json_path<-"snapshot_japan_deployments.json"

###year
year<-2023

###projectID（年によって異なります。[Project]->[Details]から確認できます）
project_id<-2006510 #Snapshot Japan 2023の場合

###サブプロジェクト名
subproject_name<-"Fukushima_Forest_NIES"


out<-wi_make_deployments(deployment_id=fieldnote$locationID,
                         placename=fieldnote$locationID,
                         longitude=fieldnote$long,
                         latitude=fieldnote$lat,
                         start_date=fieldnote$startDT,
                         end_date=fieldnote$endDT,
                         camera_id=fieldnote$cameraID,
                         subproject_name=subproject_name,
                         project_id=project_id,
                         year=year,
                         quiet_period=1,
                         setting_json_path=setting_json_path)

view(out)
outfile<-paste0("bulk_upload_template_",subproject_name,".csv")
write_csv(out,outfile)
