#Match Evictions to Parcels and Owners At That Time

#Need to Deal with ".001"s in Parcel Evic join
for (i in 1:length(census_evic$PIN)) {
  if (identical(nchar(census_evic$PIN[i]),as.integer(15)) == FALSE) {
    census_evic$PIN[i] = NA
  }
}

#Focus on the Variables I care about and get rid of all NAs
parcel_evic_join_vars <- c("docketno","address","Statusdate","Dateissued","year","PARCEL_ID.x", "PIN","sum_du")
census_evic <- census_evic[parcel_evic_join_vars]
apart_evics <- census_evic[!is.na(census_evic$PIN),]

#Upload Durham Apartment Sales with All Owner Types Edited

durham_apts <- read.csv("new_durham_apts_edited_plus_nas_covered.csv")

#Filling in All Owner Names
durham_apts$Umbrella.Name = as.character(durham_apts$Umbrella.Name)

for (i in 1:length(durham_apts$Umbrella.Name)) {
  if(durham_apts$Umbrella.Name[i] == "") {
    durham_apts$Umbrella.Name[i] = as.character(durham_apts$Deed.Name[i])
  }
}

#Code in the cross over from old file to new file:
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 125295] <- 222781
durham_apts <- durham_apts[-c(2429),] #delete duplicated row after crossover
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 118375] <- 215190
durham_apts <- durham_apts[-c(2421),] #delete duplicated row after crossover
durham_apts <- durham_apts[-c(2235),] #delete duplicated row, same deed page, same owner with different last name 
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 149677] <- 206962
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 107191] <- 203905
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 108453] <- 210287
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 113715] <- 202918
durham_apts$PARCEL_ID[durham_apts$PARCEL_ID == 107191] <- 203904

apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 118375] <- 215190
apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 125295] <- 222781
apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 149677] <- 206962
apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 107191] <- 203905
apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 108453] <- 210287
apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 113715] <- 202918
apart_evics$PARCEL_ID.x[apart_evics$PARCEL_ID.x == 107191] <- 203904

#Remove those that do not have correct dwelling counts
census_parcels_filtered <- st_read("census_parcels_filtered.shp")
durham_apts <- durham_apts[durham_apts$PARCEL_ID %in% census_parcels_filtered$PARCEL_, ]

#Keep only the highest deed page.
durham_apts_sliced <- durham_apts %>%
  group_by(PARCEL_ID,`Date.Sold`) %>%
  arrange(desc(`Date.Sold`), .by_group = TRUE) %>%
  top_n(1, Deed.Page)

durham_apts_sliced$`Date.Sold`= ymd(durham_apts_sliced$`Date.Sold`)

durham_apts_sliced$Start_Date <- durham_apts_sliced$`Date.Sold`

durham_apts_sliced_owners <- durham_apts_sliced %>%
  group_by(PARCEL_ID) %>%
  arrange(desc(Start_Date), .by_group = TRUE) %>%
  mutate(End_Date = dplyr::lag(Start_Date, n = 1, default = NA))

for (i in 1:length(durham_apts_sliced_owners$End_Date)) {
  if (is.na(durham_apts_sliced_owners$End_Date[i]) == TRUE) {
    durham_apts_sliced_owners$End_Date[i] = as.Date("2018-31-01","%Y-%d-%m")
  }
}

for (i in 1:length(durham_apts_sliced_owners$End_Date)) {
  for (j in 1:length(durham_apts_sliced_owners$Start_Date)) {
    if (identical(durham_apts_sliced_owners$End_Date[i],durham_apts_sliced_owners$Start_Date[j]) == TRUE
        & identical(durham_apts_sliced_owners$PARCEL_ID[i],durham_apts_sliced_owners$PARCEL_ID[j]) == TRUE
        & identical(durham_apts_sliced_owners$Umbrella.Name[i],durham_apts_sliced_owners$Umbrella.Name[j]) == TRUE) {
      durham_apts_sliced_owners$Start_Date[j] = durham_apts_sliced_owners$Start_Date[i]
      durham_apts_sliced_owners$End_Date[i] = durham_apts_sliced_owners$End_Date[j]
    }
  }
}

durham_apts_sliced_owners <- durham_apts_sliced_owners[!duplicated(durham_apts_sliced_owners[,c("PARCEL_ID","Umbrella.Name",
                                                                        "Start_Date","End_Date")]),]

durham_apts_sliced_owners <- durham_apts_sliced_owners %>% ungroup() %>% mutate(id = seq_len(n()))

apart_evics = apart_evics %>%
  mutate(PARCEL_ID = as.numeric(PARCEL_ID.x))

#NOTE RESTRICTION:
apart_evics = apart_evics %>% filter(year >=2004)

merged_data = full_join(apart_evics, durham_apts_sliced_owners) %>%
  filter(Statusdate >= Start_Date, Statusdate <= End_Date)

#merged_data = fuzzy_left_join(
#  apart_evics, durham_apts_sliced_owners,
#  by = c("PARCEL_ID.x" = "PARCEL_ID",
#         "Statusdate" = "Start_Date",
#         "Statusdate" = "End_Date"
#  ),
#  match_fun = list(`==`, `>=`, `<=`)
#)

#deed_owners_2003 = sf::st_read("parcels_2003", quiet = TRUE, stringsAsFactors = FALSE)
#nas_covered <- deed_owners_2003[deed_owners_2003$AKPAR_ %in% nas_impute$PARCEL_ID.x, ]
#st_write(nas_covered,"nas_covered_2003.csv")
#nas_impute = merged_data[is.na(merged_data$PARCEL_ID), ] %>% count(PARCEL_ID.x)

evics_per_owner <- merged_data %>% count(id)

apt_evictions_eda = left_join(durham_apts_sliced_owners,evics_per_owner,by="id")
names(apt_evictions_eda)[names(apt_evictions_eda) == "n"] <- "total_evictions"

#complete_data <- merged_data[!is.na(merged_data$PARCEL_ID),]
#complete_data$Start_Date = as.character(complete_data$Start_Date)
#complete_data$End_Date = as.character(complete_data$End_Date)

#write.csv(complete_data,"complete_data.csv")

write.csv(apt_evictions_eda,"apt_evictions_eda.csv")
#st_write(complete_data,"complete_data.shp")
