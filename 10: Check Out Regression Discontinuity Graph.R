# 10: Check Out Regression Discontinuity Graph 
library(DescTools)
# Create bins on which to merge evictions data for each owner 
binned_evics <- merged_data
binned_evics$ownership_time <- NA
binned_evics$ownership_time = difftime(binned_evics$End_Date,binned_evics$Start_Date,units = "days")
binned_evics$eviction_time <- NA
# Give each eviction a number using difftime from beginning date and another column with end date
binned_evics$eviction_time <- difftime(binned_evics$Statusdate,binned_evics$Start_Date, units = "days")
binned_evics$eviction_time_before_end <- difftime(binned_evics$End_Date, binned_evics$Statusdate, units = "days")
                                 
#Delete owners that I put in 2001 as original start date because these owners had actually bought 
#the properties much earlier than that so not useful in this analysis. 

binned_evics <- binned_evics %>% filter(Start_Date != "2001-01-01")


# Determine the parcels that switched from individual to corporate ownership.
binned_evics$RHFS.Classifications = as.character(binned_evics$RHFS.Classifications)

binned_evics$RHFS.Classifications[binned_evics$RHFS.Classifications == "Business Corp"] <- "Corporate"
binned_evics$RHFS.Classifications[binned_evics$RHFS.Classifications == "LLP, LP, or LLC"] <- "Corporate"
binned_evics$RHFS.Classifications[binned_evics$RHFS.Classifications == "Private Equity"] <- "Corporate"
binned_evics$RHFS.Classifications[binned_evics$RHFS.Classifications == "REIT"] <- "Corporate"
binned_evics$RHFS.Classifications[binned_evics$RHFS.Classifications == "Investment Firm"] <- "Corporate"
binned_evics$RHFS.Classifications[binned_evics$RHFS.Classifications == "Hedgefund sponser"] <- "Corporate"

#binned_evics$eviction_time <- cut(as.numeric(binned_evics$eviction_time),breaks = c(0,30,60,90,120,150,180,210,240,270,300,330,360,Inf))

binned_indiv_owners <- binned_evics %>% filter(RHFS.Classifications == "Individual")
binned_indiv_owners<- binned_indiv_owners %>% filter(eviction_time != "(360,Inf]")
binned_corp_owners <- binned_evics %>% filter(RHFS.Classifications == "Corporate")
binned_corp_owners<- binned_corp_owners %>% filter(eviction_time != "(360,Inf]")


# Plot the individuals on one graph and then plot the corporates on another and check it out. 

ggplot(binned_corp_owners, aes(x=eviction_time)) + 
  geom_bar(col="red", 
                fill="blue") +
  labs(title="Histogram of Evictions Since Ownership Change") +
  labs(x="Time Since Transaction", y="Total Number of Evictions")

# nothing super nuanced here...

#Maybe let's try a smaller / bigger window?

binned_evics$eviction_time <- cut(as.numeric(binned_evics$eviction_time),breaks = c(seq(0, 1080, 60),Inf))
binned_corp_owners <- binned_evics %>% filter(RHFS.Classifications == "Corporate")
binned_corp_owners<- binned_corp_owners %>% filter(eviction_time != "(357,Inf]")

#that is when we are starting to see a shift downwards -- evicting people at a constant rate for 3 years....

binned_evics$eviction_time <- cut(as.numeric(binned_evics$eviction_time),breaks = c(seq(0, 360, 7),Inf))

#Okay so clearly no obvious trend, seems to suggest that maybe seasonal changes are impacting this distribution...

#What if we subset this group to only owners whose start date is in january?

#Let's just use the monthly eviction rate right before and after:

durham_apts_sliced_owners$one_month_post_sale <- NA
durham_apts_sliced_owners$one_month_pre_sale <- NA

durham_apts_sliced_owners$one_month_post_sale <- durham_apts_sliced_owners$Start_Date %m+% months(1)
durham_apts_sliced_owners$one_month_pre_sale <- durham_apts_sliced_owners$End_Date %m+% months(-1)

pair_wise_data_post_sale_evics <- full_join(apart_evics, durham_apts_sliced_owners) %>%
  filter(Statusdate >= Start_Date, Statusdate <= one_month_post_sale)

pair_wise_data_pre_sale_evics <- full_join(apart_evics, durham_apts_sliced_owners) %>%
  filter(Statusdate >= one_month_pre_sale, Statusdate <= End_Date)

evics_per_owner_post <- pair_wise_data_post_sale_evics %>% count(id)
evics_per_owner_pre <- pair_wise_data_pre_sale_evics %>% count(id)

apt_evictions_eda = left_join(durham_apts_sliced_owners,evics_per_owner_post,by="id")
names(apt_evictions_eda)[names(apt_evictions_eda) == "n"] <- "week_evictions_post"
apt_evictions_eda = left_join(apt_evictions_eda,evics_per_owner_pre,by="id")
names(apt_evictions_eda)[names(apt_evictions_eda) == "n"] <- "week_evictions_pre"

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
apt_evictions_eda$post_weekly_evic_rate <- apt_evictions_eda$week_evictions_post/(as.numeric(apt_evictions_eda$dwelling_count))
apt_evictions_eda$post_weekly_evic_rate[is.na(apt_evictions_eda$post_weekly_evic_rate)] <- 0

apt_evictions_eda$pre_weekly_evic_rate <- NA
apt_evictions_eda$pre_weekly_evic_rate <- apt_evictions_eda$week_evictions_pre/(as.numeric(apt_evictions_eda$dwelling_count))
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
  filter(ownership_time > 12) %>%
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


model_1 <- lm(evic_diff ~ `Corporate to Corporate` + `Corporate to Individual` + `Individual to Corporate`
                         + `Individual to Individual` + year, data = reg_data)
summary(model_1)

model_2 <- lm(evic_diff ~ `Corporate to Corporate` + `Corporate to Individual` + `Individual to Corporate`
   + `Individual to Individual`,data = reg_data)
summary(model_2)


indiv_to_corp_owner = pair_wise_data %>% 
  filter(type_prev == "Individual" & type_curr == "Corporate")

t.test(indiv_to_corp_owner$evic_rate_prev, 
       indiv_to_corp_owner$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

corp_to_indiv_owner = pair_wise_data %>% 
  filter(type_prev == "Corporate" & type_curr == "Individual")

t.test(corp_to_indiv_owner$evic_rate_prev, 
       corp_to_indiv_owner$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

corp_to_corp_owner = pair_wise_data %>% 
  filter(type_prev == "Corporate" & type_curr == "Corporate")

t.test(corp_to_corp_owner$evic_rate_prev, 
       corp_to_corp_owner$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

indiv_to_indiv_owner = pair_wise_data %>% 
  filter(type_prev == "Individual" & type_curr == "Individual")

t.test(indiv_to_indiv_owner$evic_rate_prev, 
       indiv_to_indiv_owner$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

