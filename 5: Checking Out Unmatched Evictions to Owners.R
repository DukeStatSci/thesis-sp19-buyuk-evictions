#Checking Out Unmatched Eviction Records

nas_impute = merged_data[is.na(merged_data$PARCEL_ID), ] %>% count(PARCEL_ID.x)

#Loading and Checking Out Relevant Data Sets to Help Fill In Gaps 

#deed_owners_2001 = sf::st_read("Parcel_History_2001", quiet = TRUE, stringsAsFactors = FALSE)

#deed_apt_owners_2001 <- deed_owners_2001[deed_owners_2001$PIN %in% census_parcels_filtered$PIN, ] %>% select(c("PIN","OWNAM1","OWNAM2","OWADR1","OWADR2","OWCITY","OWSTA","OWZIPA"))

#deed_apt_owners_2001$PARCEL_ID <- NA

#for (i in 1:length(deed_apt_owners_2001$PIN)) {
#  for (j in 1:length(census_parcels_filtered$PIN)) {
#    if (identical(deed_apt_owners_2001$PIN[i],census_parcels_filtered$PIN[j]) == TRUE) {
#      deed_apt_owners_2001$PARCEL_ID[i] = census_parcels_filtered$PARCEL_ID.x[j]
#    }
#  }
#}
#nas_covered <- deed_apt_owners_2001[deed_apt_owners_2001$PARCEL_ID %in% nas_impute$PARCEL_ID.x, ]
#deed_owners_2002 = sf::st_read("parcel_history_2002", quiet = TRUE, stringsAsFactors = FALSE)
#deed_apt_owners_2002 <- census_parcels_filtered[census_parcels_filtered$PIN %in% deed_owners_2002$PIN, ]
#nas_covered_2002 <- deed_apt_owners_2002[deed_apt_owners_2002$PARCEL_ID.x %in% nas_impute$PARCEL_ID.x, ]
#o2_in_o1 <- deed_apt_owners_2002[deed_apt_owners_2002$PARCEL_ID.x %in% deed_apt_owners_2001$PARCEL_ID.x, ]

deed_owners_2003 = sf::st_read("parcels_2003", quiet = TRUE, stringsAsFactors = FALSE)
nas_covered <- deed_owners_2003[deed_owners_2003$AKPAR_ %in% nas_impute$PARCEL_ID.x, ]

#Merging the datasets to help:

#We see that the 2001 file can cover about 244 of the 569 parcels that have NAs in them. Well, let's see exactly how many rows that helps out with: 
#How can I get the total counts of all not in na.
sum(nas_impute$n)

nas_covered$total_occur <- NA

for (i in 1:length(nas_covered$AKPAR_)) {
  for (j in 1:length(nas_impute$PARCEL_ID.x)) {
    if (identical(nas_covered$AKPAR_[i],nas_impute$PARCEL_ID.x[j]) == TRUE) {
      nas_covered$total_occur[i] = nas_impute$n[j]
    }
  }
}
sum(nas_covered$total_occur)

not_covered <- merged_data[!(merged_data$PARCEL_ID.x %in% deed_owners_2003$AKPAR_), ]
not_covered <- not_covered[is.na(not_covered$PARCEL_ID),]

not_covered_count <- not_covered %>% group_by(PARCEL_ID.x) %>% count()
not_covered_count[order(-not_covered_count$n),]

crosswalk_dates = deed_owners_2003 %>% filter(AKPAR_ == "118375"| 
                          AKPAR_ == "149677"|
                                   AKPAR_ == "125295"|
                                   AKPAR_ == "107191"|
                                   AKPAR_ == "108453"|
                                   AKPAR_ == "113715"|
                                   AKPAR_ == "107191")
crosswalk_dates$total_occur <- NA
not_covered = rbind(nas_covered,crosswalk_dates)

st_write(crosswalk_dates,"crosswalk_dates.csv")
