#12: Playing with Different Windows

durham_apts_sliced_owners$one_month_post_sale <- NA
durham_apts_sliced_owners$one_month_pre_sale <- NA

durham_apts_sliced_owners$one_month_post_sale <- durham_apts_sliced_owners$Start_Date %m+% months(6)
durham_apts_sliced_owners$one_month_pre_sale <- durham_apts_sliced_owners$End_Date %m+% months(-6)

pair_wise_data_post_sale_evics <- full_join(apart_evics, durham_apts_sliced_owners) %>%
  filter(Statusdate >= Start_Date, Statusdate <= one_month_post_sale)

pair_wise_data_pre_sale_evics <- full_join(apart_evics, durham_apts_sliced_owners) %>%
  filter(Statusdate >= one_month_pre_sale, Statusdate <= End_Date)

evics_per_owner_post <- pair_wise_data_post_sale_evics %>% count(id)
evics_per_owner_pre <- pair_wise_data_pre_sale_evics %>% count(id)

apt_evictions_eda = left_join(durham_apts_sliced_owners,evics_per_owner_post,by="id")
names(apt_evictions_eda)[names(apt_evictions_eda) == "n"] <- "evictions_post"
apt_evictions_eda = left_join(apt_evictions_eda,evics_per_owner_pre,by="id")
names(apt_evictions_eda)[names(apt_evictions_eda) == "n"] <- "evictions_pre"

apt_evictions_eda$dwelling_count <- NA
for (i in 1:length(apt_evictions_eda$PARCEL_ID)) {
  for (j in 1:length(parcels_in_tract$PARCEL_)) {
    if (identical(as.character(apt_evictions_eda$PARCEL_ID[i]),as.character(parcels_in_tract$PARCEL_[j])) == TRUE) {
      apt_evictions_eda$dwelling_count[i] = parcels_in_tract$sum_du[j]
    }     
  }
}

apt_evictions_eda$ownership_time = NA
apt_evictions_eda$ownership_time = difftime(apt_evictions_eda$End_Date,durham_apts_sliced_owners$Start_Date,units = "weeks")

apt_evictions_eda$post_weekly_evic_rate <- NA
apt_evictions_eda$post_weekly_evic_rate <- apt_evictions_eda$evictions_post/(as.numeric(apt_evictions_eda$dwelling_count))
apt_evictions_eda$post_weekly_evic_rate[is.na(apt_evictions_eda$post_weekly_evic_rate)] <- 0

apt_evictions_eda$pre_weekly_evic_rate <- NA
apt_evictions_eda$pre_weekly_evic_rate <- apt_evictions_eda$evictions_pre/(as.numeric(apt_evictions_eda$dwelling_count))
apt_evictions_eda$pre_weekly_evic_rate[is.na(apt_evictions_eda$pre_weekly_evic_rate)] <- 0

apt_evictions_eda$RHFS.Classifications = as.character(apt_evictions_eda$RHFS.Classifications)
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "Business Corp"] <- "Corporate"
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "LLP, LP, or LLC"] <- "Corporate"
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "Private Equity"] <- "Corporate"
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "REIT"] <- "Corporate"
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "Fund"] <- "Corporate"
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "Hedgefund sponser"] <- "Corporate"
apt_evictions_eda$RHFS.Classifications[apt_evictions_eda$RHFS.Classifications == "Investment Firm"] <- "Corporate"

pair_wise_data = apt_evictions_eda %>% 
  filter(ownership_time > 52) %>%
  group_by(PARCEL_ID) %>%
  arrange(Start_Date) %>%
  mutate(
    owner_prev = lag(Umbrella.Name),
    type_prev = lag(RHFS.Classifications),
    evic_rate_prev = lag(pre_weekly_evic_rate)
  )

pair_wise_data$owner_curr = pair_wise_data$Umbrella.Name
pair_wise_data$type_curr = pair_wise_data$RHFS.Classifications
pair_wise_data$evic_rate_curr = pair_wise_data$post_weekly_evic_rate

pair_wise_data <- pair_wise_data %>% select("owner_prev","type_prev","evic_rate_prev","evic_rate_curr",
                                            "owner_curr","type_curr","Start_Date","PARCEL_ID")
pair_wise_data <- pair_wise_data[!is.na(pair_wise_data$owner_prev),]

pair_wise_data <- pair_wise_data %>% filter(type_prev == "Individual" | type_prev == "Corporate")
pair_wise_data <- pair_wise_data %>% filter(type_curr == "Individual" | type_curr == "Corporate")

pair_wise_data$switch_type = paste0(pair_wise_data$type_prev, " to ",pair_wise_data$type_curr)
pair_wise_data$`Individual to Individual` <- NA
pair_wise_data$`Individual to Corporate` <- NA
pair_wise_data$`Corporate to Individual` <- NA
pair_wise_data$`Corporate to Corporate` <- NA
pair_wise_data  <- pair_wise_data %>%
  ungroup() %>% 
  mutate(id = seq_len(n()))

indicators = gather(pair_wise_data[9:13],"Switch","Indicator",-switch_type)

for (i in 1:length(indicators$switch_type)) {
  if(identical(indicators$switch_type[i],indicators$Switch[i]) == TRUE) {
    indicators$Indicator[i] =1 
  }
}

indicators <- indicators %>% group_by(Switch) %>% mutate(id = seq_len(n()))

indicators <- spread(indicators, "Switch", "Indicator")

pair_wise_data <- pair_wise_data[, -c(9:13)]

reg_data <- left_join(pair_wise_data,indicators,by="id")
reg_data$evic_diff <- reg_data$evic_rate_curr - reg_data$evic_rate_prev
reg_data <- reg_data %>% select("evic_diff","Corporate to Corporate","Corporate to Individual",
                                "Individual to Corporate","Individual to Individual","Start_Date")
reg_data$year = substr(as.character(reg_data$Start_Date),1,4)
reg_data <- reg_data %>% filter(as.numeric(year) >= 2004)

reg_data$`Individual to Individual`[is.na(reg_data$`Individual to Individual`)] <- 0
reg_data$`Individual to Corporate`[is.na(reg_data$`Individual to Corporate`)] <- 0
reg_data$`Corporate to Individual`[is.na(reg_data$`Corporate to Individual`)] <- 0
reg_data$`Corporate to Corporate`[is.na(reg_data$`Corporate to Corporate`)] <- 0

reg_data$`Individual to Individual` <- as.factor(reg_data$`Individual to Individual`)
reg_data$`Individual to Corporate` <- as.factor(reg_data$`Individual to Corporate`)
reg_data$`Corporate to Individual` <- as.factor(reg_data$`Corporate to Individual`)
reg_data$`Corporate to Corporate` <- as.factor(reg_data$`Corporate to Corporate`)

#Super skewed, not the best idea to do a linear model?

model_1 <- lm(evic_diff ~ `Corporate to Corporate` + `Corporate to Individual` + `Individual to Corporate`
              + `Individual to Individual` + year, data = reg_data)
summary(model_1)

model_2 <- lm(evic_diff ~ `Corporate to Corporate` + `Corporate to Individual` + `Individual to Corporate`
              + `Individual to Individual`,data = reg_data)
summary(model_2)


