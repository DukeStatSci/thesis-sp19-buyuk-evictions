#13: Predicting What Point Should Be Based on Time Series Regression Moving Averages Model 

#Dataset Predicting for Each Point What The Right Eviction Rate is right before and right after transaction

#For each Start_Date, we need to determine an eviction rate, based on prior eviction rates, for example, weekly or monthly,
#leading up to this date. 

#Maybe cut up each owner's ownership time period into weekly chunks... 

test <- merged_data %>% filter(PARCEL_ID.x == "158464", Umbrella.Name == "Real Estate Associates Inc")
test <- test %>% select("Statusdate","Start_Date","End_Date")

test2 <- seq(as.Date(test$Start_Date[1]), as.Date(test$End_Date[1]), by="days")
test2 <- as.data.frame(test2)

test2$evic_occur <- NA

for (i in 1:length(test2$test2)) {
  if(as.character(test2$test2[i]) %in% as.character(test$Statusdate) == TRUE) {
    test2$evic_occur[i] = 1
  }
}

test2$evic_occur[is.na(test2$evic_occur)] <- 0

install.packages("tidyquant")
library(tidyquant)
library(pracma)

weeks_counted <- test2 %>%
  tq_transmute(select     = evic_occur,
               mutate_fun = apply.monthly,
               FUN        = sum)
test2$dwelling_count <- 100
test2$evic_rate <- test2$evic_occur / test2$dwelling_count

plot(weeks_counted$test2,weeks_counted$evic_rate)

forecasted_point <- forecast(ma(weeks_counted$evic_rate, order =1, centre = TRUE))

totalweeks <- movavg(test2$evic_rate,30, type=c("e"))

moving_averages <- function(parcel,parcels_in_tract) {
  ownership_start <- parcel$Start_Date[1]
  ownership_end <- parcel$End_Date[1]
  parcel_ID <- parcel$PARCEL_ID[1]
  all_days_owned <- seq(as.Date(ownership_start), as.Date(ownership_end), by="days")
  all_days_owned = as.data.frame(all_days_owned)
  all_days_owned$evic_occur <- NA
  for (i in 1:length(all_days_owned$all_days_owned)) {
    if(as.character(all_days_owned$all_days_owned[i]) %in% as.character(parcel$Statusdate) == TRUE) {
      all_days_owned$evic_occur[i] = 1
    }
  }
  all_days_owned$evic_occur[is.na(all_days_owned$evic_occur)] <- 0
  monthly_count <- all_days_owned %>%
    tq_transmute(select     = evic_occur,
                 mutate_fun = apply.monthly,
                 FUN        = sum)
  monthly_count$dwelling_count <- NA
  monthly_count$dwelling_count <- parcels_in_tract$sum_du[match(as.character(parcel_ID),parcels_in_tract$PARCEL_)]
  monthly_count$evic_rate <- monthly_count$evic_occur / as.numeric(monthly_count$dwelling_count)
  parcel_mov_avg <- movavg(monthly_count$evic_rate,3, type=c("e"))
  return(parcel_mov_avg)
}
  
moving_averages(test,parcels_in_tract)

# Month Eviction Rate     # Month Predicted For     # Corp v. Not   # Pre v. Post
# Lined Up as Vector      # With Months Predicted for   # With Parcel ID  (this has classification and post or pre)


#Regression y axis is the most recent date, and then I need an ARMA model to move through dates before
#and predict what the eviction rate will be closest to the event. 

install.packages("smooth")
require(smooth)
#ma 

#How do we incorporate information from outside? When we put year here, this is only the eviction rates in
#this given info which doesn't really make sense?
