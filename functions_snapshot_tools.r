###Function to develop csv file for batch upload of deployments

wi_make_deployments<-
  function(deployment_id,
           placename,
           longitude,
           latitude,
           start_date,
           end_date,
           camera_id,
           quiet_period=0,
           camera_functioning="Camera Functioning",
           project_id="",
           project_name="",
           subproject_name="",
           subproject_design="",
           event_name="None",
           event_description="",
           event_type="",
           bait_type="None",
           bait_description="",
           feature_type="None",
           feature_type_methodology="",
           sensor_height="Knee height",
           height_other="",
           sensor_orientation="Parallel",
           orientation_other="",
           recorded_by="",
           plot_treatment="",
           plot_treatment_description="",
           detection_distance="",
           setting_json_path=""){
    
    #packages
    if(!require(jsonlite)){
      install.packages("jsonlite")
      require(jsonlite)
    }
    
    #read json
    if(!is.null(setting_json_path)){
      setting<-fromJSON(setting_json_path)
    }else{
      setting<-list()
    }
    nsetting<-length(setting)
    
    #update variables by json file
    if(nsetting!=0){
      for(i in 1:nsetting){
        assign(names(setting)[i],setting[[i]])
      }
    }
    
    #making deployment_id and placename unique
    deployment_id<-paste0(project_name,"_",subproject_name,"_",deployment_id)
    placename<-paste0(subproject_name,"_",placename)
    camera_id<-paste0(subproject_name,"_",camera_id)
    
    #converting significant digits of lat&long to 8 
    longitude<-format(longitude,digits=11)
    latitude<-format(latitude,digits=10)
    
    #make deployments
    out<-tibble(project_id=project_id,
           deployment_id=deployment_id,
           subproject_name=subproject_name,
           subproject_design=subproject_design,
           placename=placename,
           longitude=longitude,
           latitude=latitude,
           start_date=start_date,
           end_date=end_date,
           event_name=event_name,
           event_description=event_description,
           event_type=event_type,
           bait_type=bait_type,
           bait_description=bait_description,
           feature_type=feature_type,
           feature_type_methodology=feature_type_methodology,
           camera_id=camera_id,
           quiet_period=quiet_period,
           camera_functioning=camera_functioning,
           sensor_height=sensor_height,
           height_other=height_other,
           sensor_orientation=sensor_orientation,
           orientation_other=orientation_other,
           recorded_by=recorded_by,
           plot_treatment=plot_treatment,
           plot_treatment_description=plot_treatment_description,
           detection_distance=detection_distance
    )
    return(out)
  }