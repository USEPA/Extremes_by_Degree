# Extremes by Degree

This package estimates the annual frequency of storm events, per year, given a change in CONUS temperature, 81-2010, relative to 95 mean

## Installation

To install `ExtremesbyDegree` for the first time:

```
`library("devtools")`

 withr::with_libpaths(  
 
    new = .libPaths()[1],  
    
    devtools::install_github(  
        repo = "USEPA/Extremes_by_Degree",  
         type = "source",  
          force = TRUE  
          #ref = "branch" # this will install a particular branch of interest
        ))
        
```

``

## Using ExtremesbyDegree

Load the package 
```
library("ExtremesbyDegree")
```
### Prepare Inputs

The main function `run_extreme_impact` expects one input in the form of a list containing one dataframe. The dataframe should contain only two columns: `year`,`temp_C`. `year` should start 2010 at minimum and represents a change in CONUS temperature, °C, relative to base period(1985-2014). A default example temperature trajectory is provided.
```
# To use the default input assign NULL to temp
inputsList = c(temp = NULL)
```

### Execute function
Now you can execute the function 
```
result <- run_extreme_impact(inputsList)
```
Results include the following columns: state,postal,sector,variant,impactType,impactYear,year

* state - The region name, inludes "National", "Puerto Rico", "US Virgin Islands"
* postal - Short character code for the state
* sector - Meta name of storm types
* variant - NA for now 
* impactType - Shortname for storm category
* impactYear - NA for now
* year - Year of impact
* annual_impact - Impact in terms of Change in frequency sotrm relative to base period (1985-2014)

(Note - Some columns are NA to stay consistent with columns in other FrEDI packages)


----------------------------------------------------------------------------------
For more information read "FrEDI Extremes Documentation" located in the `documentation` folder of this repository.

