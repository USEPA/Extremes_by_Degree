
#' run_extreme_impact
#'
#' @param inputsList 
#'
#' @export
#'
run_extreme_impact <- function(
    inputsList = c(temp = NULL)
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
  

  temp_scaled_imp <- scaled_Imp |> 
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
  
  return(temp_scaled_imp)
  
}
  