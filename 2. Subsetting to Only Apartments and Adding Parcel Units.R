#Add Dwelling units to Census Parcels that Map to Multi-Dwelling Family Units

#Filter census parcels to multi-dwelling units
durham_apt_sales <- subset(durham_tax_sales, `Land Use Description` == "COM/ APARTMENT-DWG CONV" | `Land Use Description` == "COM/ APARTMENT-GARDEN" | `Land Use Description` == "COM/ APARTMENT-HIGH RISE" | `Land Use Description` == "RES/ MULTIPLE DWG'S" | `Land Use Description` == "COM/ APARTMENT-GARDEN S42" | `Land Use Description` == "COM/ LIVING ACCOMM" | `Land Use Description` == "COM/ LIVING ACCOMN S42")

census_parcels_filtered <- parcel_file[parcel_file$PARCEL_ID %in% durham_apt_sales$PARCEL_ID, ]

#Match census parcels to dwelling units
census_parcels_filtered = fuzzy_left_join(
  census_parcels_filtered,parcel_file_du,
  by = c("PARCEL_ID" = "PARCEL_ID"
  ),
  match_fun = list(`==`)
)


#Add Dwelling Counts for Multi-Dwelling Units with Missing Information If Found
#missing_sum_du <- census_parcels_filtered %>% 
#  filter(is.na(sum_du) == TRUE | sum_du == 0 | sum_du == 1) %>% 
#  select(PARCEL_ID.x,OWNAM1,sum_du)

#write_excel_csv(missing_sum_du, "missing_sum_du.csv")

missing_sum_du <- read_csv("missing_sum_du.csv")

#Input in new sum_du for those that were missing, 0 or 1 originally and delete those that are still missing:
for (i in 1:length(census_parcels_filtered$PARCEL_ID.x)) {
  if (census_parcels_filtered$PARCEL_ID.x[i] %in% missing_sum_du$PARCEL_ID.x == TRUE) {
    location <- which(missing_sum_du$PARCEL_ID.x == census_parcels_filtered$PARCEL_ID.x[i])
    census_parcels_filtered$sum_du[i] = missing_sum_du$new_sum_du[location]
  }
}

census_parcels_filtered <- census_parcels_filtered %>% 
  filter(is.na(sum_du) == FALSE & sum_du != 0 & sum_du != 1) %>% 
  select(PARCEL_ID.x,PIN,sum_du)

st_write(census_parcels_filtered, "census_parcels_filtered.shp")
  
#Write only the Apartment Sales Transactions that we care about so that we can classify them:
#write.csv(durham_apt_sales,"durham_apt_sales.csv")
