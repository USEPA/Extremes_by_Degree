
#' Title
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
  
  #### Create scaled impact functions #######
  
  imp_model <- function(df) {
    approxfun(x = df$modelUnitValue, y = df$value)
  }
  
  imp_func_nest <- scaled_Imp |> 
    group_by(state,postal,impactType,model,sector) |>
    group_modify(~ add_row(.x, modelUnitValue = 0,value = 0)) |> 
    nest()
   
  imp_Data <- imp_func_nest |>
              mutate(func = map(data,imp_model))
  
    
  ##### 3. Evaluate 
  temp_scaled_imp <- imp_Data |>
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
  