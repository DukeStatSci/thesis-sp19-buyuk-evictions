#Additions to Durham Sales Data With Important Information 

#census_tract_eda = sf::st_read("census_2010_nc_tract", quiet = TRUE, stringsAsFactors = FALSE) %>% filter(CNTY_FIPS == "063")
#census_tract_eda <- sf::st_transform(census_tract_eda, crs = 2264)
#census_sf_eda = sf::st_read("census_sf", quiet = TRUE, stringsAsFactors = FALSE)

#Match parcels to a tract
parcels_in_tract <- st_join(census_tract_eda,census_sf_eda, join = st_intersects)

#Match each parcel with a dwelling count
apt_evictions_eda$dwelling_count <- NA
for (i in 1:length(apt_evictions_eda$PARCEL_ID)) {
  for (j in 1:length(parcels_in_tract$PARCEL_)) {
    if (identical(as.character(apt_evictions_eda$PARCEL_ID[i]),as.character(parcels_in_tract$PARCEL_[j])) == TRUE) {
      apt_evictions_eda$dwelling_count[i] = parcels_in_tract$sum_du[j]
    }     
  }
}

#Create labels for different unit sizes under an owner
apt_evictions_eda$unit_sizes <- NA

for (i in 1:length(apt_evictions_eda$dwelling_count)) {
  if(identical(apt_evictions_eda$dwelling_count[i] <= 4, TRUE)) {
    apt_evictions_eda$unit_sizes[i] = "tiny"
  }
  if (identical(4 < apt_evictions_eda$dwelling_count[i] & apt_evictions_eda$dwelling_count[i] <= 24,TRUE)) {
    apt_evictions_eda$unit_sizes[i] = "small"
  }
  if (identical(24 < apt_evictions_eda$dwelling_count[i] & apt_evictions_eda$dwelling_count[i] <= 49,TRUE)) {
    apt_evictions_eda$unit_sizes[i] = "medium"
  }
  if (identical(49 < apt_evictions_eda$dwelling_count[i],TRUE)) {
    apt_evictions_eda$unit_sizes[i] = "large"
  }
} 

#Figuring Out Length of Ownership for Each owner
apt_evictions_eda$ownership_time = NA

apt_evictions_eda$ownership_time = difftime(apt_evictions_eda$End_Date,durham_apts_sliced_owners$Start_Date,units = "weeks")

#Figuring Out Eviction Rate given length of ownership
apt_evictions_eda$weekly_evic_rate <- NA
apt_evictions_eda$weekly_evic_rate <- apt_evictions_eda$total_evictions/(as.numeric(apt_evictions_eda$dwelling_count)*as.numeric(apt_evictions_eda$ownership_time))
apt_evictions_eda$weekly_evic_rate[is.na(apt_evictions_eda$weekly_evic_rate)] <- 0

#Creating Indicator Variables for Each Year an Owner was an Owner 

for (i in 2000:2018)  {
  apt_evictions_eda[ ,paste0(i)] <- NA
}

apt_evictions_eda$Start_year = substr(as.character(apt_evictions_eda$Start_Date),1,4)
apt_evictions_eda$End_year = substr(as.character(apt_evictions_eda$End_Date),1,4)

gathered_data <- gather(apt_evictions_eda[70:90], "Year", "Indicator",-Start_year,-End_year)
gathered_data$Start_year = as.numeric(gathered_data$Start_year)
gathered_data$End_year = as.numeric(gathered_data$End_year)
gathered_data$Year = as.numeric(gathered_data$Year)

gathered_data$Indicator <- NA
for (i in 1:length(gathered_data$Indicator)) {
  p = gathered_data$Year[i]
  j = gathered_data$Start_year[i]
  k = gathered_data$End_year[i]
  if(identical(p >= j,TRUE) == TRUE & identical(p <= k,TRUE) == TRUE) {
    gathered_data$Indicator[i] = 1
  }
  else { 
    gathered_data$Indicator[i] = 0
  }
}
gathered_data  <- gathered_data %>%
  group_by(Year) %>% 
  mutate(grouped_id = seq_len(n()))
  
gathered_data <- spread(gathered_data, "Year", "Indicator")

write.csv(gathered_data,"gathered_data.csv")
write.csv(apt_evictions_eda,"apt_evictions_eda.csv")

owner_data <- apt_evictions_eda[, -c(70:88)]
owner_data = owner_data[
  with(owner_data, order(Start_year, End_year)),
  ]
owner_data <- cbind(as.data.frame(owner_data),as.data.frame(gathered_data))
owner_data <- owner_data[, -c(70:71)]

st_write(owner_data,"owner_data.csv")

