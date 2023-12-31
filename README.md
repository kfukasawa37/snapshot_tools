# snapshot_tools
R Tools for easy implementation of Snapshot.

Snapshot Japanへの適用を念頭に、Wildlife Insightsにおける![Bulk deployment upload](https://www.wildlifeinsights.org/get-started/manage-metadata/deployments#bulk-deployment-uploads)に必要なtemplateを簡便に作成するR関数を作成しました。

**使い方**
example_snapshot_tools.rを参照。

**1. Rパッケージ読み込み**
```
library(tidyverse)
library(jsonlite)
library(devtools)
```
**2. 関数ソースコード読み込み**
```
source_url("https://raw.githubusercontent.com/kfukasawa37/snapshot_tools/main/functions_snapshot_tools.r")
```
**3. 地点名、位置、日時等を含むフィールドノートファイル読み込み**
```
fieldnote_path<-"fieldnote_snapshot_2023_nies.csv"  #ご自分のフィールドノートのファイル名を指定してください。
fieldnote<-read_csv(fieldnote_path)
```
**4. Snapshot Japanに共通の設定ファイル(json)のパスを指定(github上にある)**
```
setting_json_path<-"https://raw.githubusercontent.com/kfukasawa37/snapshot_tools/main/snapshot_japan_deployments.json"
```
**5. 年、projectID, サブプロジェクト名を指定**
```
year<-2023
project_id<-2006510 #Snapshot Japan 2023の場合（[Project]->[Details]から確認できます）
subproject_name<-"Fukushima_Forest_NIES"
```
**6. templateを作成**
```
out<-wi_make_deployments(deployment_id=fieldnote$locationID,  #deploymentID（地点名を入れれば、Project名とサブプロジェクト名を結合した固有名に変換）
                         placename=fieldnote$locationID,      #地点名(これもサブプロジェクト名を結合して固有名に変換)
                         longitude=fieldnote$long,            #経度(10進、世界測地系)
                         latitude=fieldnote$lat,              #緯度
                         start_date=fieldnote$startDT,        #開始日("yyyy-mm-dd hh:mm:ss"形式、日本時間)
                         end_date=fieldnote$endDT,            #終了日
                         camera_id=fieldnote$cameraID,        #カメラ番号(これも自動的にサブプロジェクト名を結合して固有名に変換)
                         quiet_period=quiet_period,           #撮影後停止時間
                         subproject_name=subproject_name,     #サブプロジェクト名
                         project_id=project_id,               #projectID
                         year=year,                           #年
                         setting_json_path=setting_json_path) #設定ファイルのパス
```
**7. csv書き出し＆Wildlife Insightsへの登録**
```
outfile<-paste0("bulk_upload_template_",subproject_name,".csv")
write_csv(out,outfile)
```
出力されたファイルをWildlife Insightsの[+ New deployments]->[Bulk deployments upload]からアップロードして登録してください。

**注意事項**
1. Wildlife Insightsでは、緯度経度の小数点以下桁数は8桁が上限になるため、出力の際はそれに合わせて値を丸めています。
2. すでにSubproject名がProjectに登録されている場合、Bulk uploadで登録したdeploymentのSubproject欄が空欄になることがあるようです。その場合、手動で選択するか、一度SubprojectとDeploymentsを消して再度やり直して下さい。
3. Bulk uploadで一度にdeploymentsを登録することはできても、それらを一度に削除することはできません。多数の地点を登録する場合は、事前に少ない地点数のテストデータをアップロードしてふるまいをチェックすることをお勧めします。
4. 撮影後休止時間quiet_periodは整数しか受け付けないため、round()で四捨五入した値を出力します。







