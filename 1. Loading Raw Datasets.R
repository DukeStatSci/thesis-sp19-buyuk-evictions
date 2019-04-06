#Loading Relevant Libraries and Data Sets 

if (!require("readxl")) install.packages("readxl")
library(readxl)
if (!require("MASS")) install.packages("MASS")
library(MASS)
if (!require("sf")) install.packages("sf")
library(sf)
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
if (!require("stringr")) install.packages("stringr")
library(stringr)
if (!require("tidyr")) install.packages("tidyr")
library(tidyr)
if (!require("mapview")) install.packages("mapview")
library(mapview)
if (!require("purrr")) install.packages("purrr")
library(purrr)
if (!require("xgboost")) install.packages("xgboost")
library(xgboost)
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
if (!require("FedData")) install.packages("FedData")
library(FedData)
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
if (!require("tidycensus")) install.packages("tidycensus")
library(tidycensus)
if (!require("fuzzyjoin")) install.packages("fuzzjoin")
library(fuzzyjoin)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)
if (!require("lme4")) install.packages("lme4")
library(lme4)
if (!require("glmm")) install.packages("glmm")
library(glmm)
if (!require("spdep")) install.packages("spdep")
library(spdep)
if (!require("xlsx")) install.packages("xlsx")
library(xlsx)
if (!require("fuzzyjoin")) install.packages("fuzzyjoin")
library(fuzzyjoin)

#Apartment Sales File
durham_tax_sales <- read_xlsx("Durham_Sales_Transaction_History.xlsx")
colnames(durham_tax_sales)[2] <- "PARCEL_ID"

#Evictions Files
geocoded_2000_2011 <- read_csv("geocoded_2000_2011.csv")
evictions_2012_2018 = sf::st_read("evictions_2012_2018", stringsAsFactors = FALSE)

#Census Parcel File 
parcel_file = sf::st_read("Census_Parcels_Sf", quiet = TRUE, stringsAsFactors = FALSE)

#Census Parcel File With Dwelling Unit Counts
parcel_file_du = sf::st_read("Census_Parcels_Dwelling_Counts_Sf", quiet = TRUE, stringsAsFactors = FALSE)
colnames(parcel_file_du)[3] <- "PARCEL_ID"
parcel_file_du <- parcel_file_du %>%
  select(PARCEL_ID,sum_du)

#Census Tract File 
durham_tract_file = sf::st_read("census_2010_nc_tract", quiet = TRUE, stringsAsFactors = FALSE) %>% filter(CNTY_FIPS == "063")

#Census Block Group File 
durham_blockgroup_file = sf::st_read("census_2017_37_block_group", quiet = TRUE, stringsAsFactors = FALSE) %>% filter(COUNTYFP == "063")
census_bg_sf <- sf::st_transform(durham_blockgroup_file, crs = 2264)

#CoreLogic Tax File
CoreLogicTax <- read_excel("Core_Logic_Tax_File.xlsx",quiet= TRUE)

