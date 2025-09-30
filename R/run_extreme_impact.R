
#' run_extreme_impact
#'
#' @param inputsList=list(temp=NULL) A list with named elements (`temp`), containing data frame of a custom scenario of temperature changes (°C) relative to 2010. Dataframe for temp contains two columns: `year`,`temp_C`
#' @param agg_impacts Boolean (`T/F`) that determines whether or not to aggregate results as an average across GCM models
#' @export
#'
run_extreme_impact <- function(
    inputsList = c(temp = NULL), # List of inputs.
    agg_impacts = TRUE # Whether to take model average or not
){
  
  ##### 1. Setup #####
  # Load Libraries
  library(tidyverse)
  
  # Check if CH4 Inputs exists
  input_check <- inputsList |> is.null()
  
  # Define Paths. Assumes package is loaded
  extdat_path <- system.file("extdata", package = "ExtremesbyDegree")
  input_files <- list.files(extdat_path, full.names = TRUE)
  
  
  scaled_Imp_path <- input_files[grepl("scaledimpacts",input_files)]

  
  ##### 2. Read in and reshape input data #####
  
  scaled_Imp <- read_csv(scaled_Imp_path)
  
  
  if(input_check){
    temp_path <- input_files[grepl("temp",input_files)]
    temp_dat <- read_csv(temp_path)
  }else{
    temp_dat <- inputsList$temp
  }
  
  #### 3. Create scaled impact functions and evaluate #######
  

  result <- scaled_Imp |> 
    group_by(state,postal,sector,variant,impactType,impactYear,model) |>
    group_modify(~ add_row(.x, modelUnitValue = 0,value = 0)) |>
    group_modify(~ add_linear_row(.x)) |>
    nest() |>
    mutate(func = map(data,imp_model)) |>
    select(-data) |> 
    cross_join(temp_dat) |>
    ungroup() |>
    rowwise() |>
    mutate(
      annual_impact= func(temp_C)
    ) |> 
    select(-func)
  

  
  #### 4. Aggregation ###########
  
  if(agg_impacts){
  result <- result |> 
    group_by(state,postal,sector,variant,impactType,impactYear,year) |>
                      summarize(
                        annual_impact = mean(annual_impact)
                      )

  }
  
  return(result)
  
}
  