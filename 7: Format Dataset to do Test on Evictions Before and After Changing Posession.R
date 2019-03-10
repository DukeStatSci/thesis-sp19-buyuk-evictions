# Format Dataset to do Test on Evictions Before and After Changing Posession 

pair_wise_data <- apt_evictions_eda %>% select(c("PARCEL_ID","Start_Date","End_Date",
                                                 "total_evictions","dwelling_count","unit_sizes",
                                                 "ownership_time","RHFS.Classifications",
                                                 "Mailing.Office.State","Umbrella.Indic",
                                                 "Umbrella.Name","Individual.Family.Names",
                                                 "More.Notes","Private.Public","Dissolved",
                                                 "Latitude","Longitude"))

#Weekly Rate of Evictions
pair_wise_data$weekly_evic_rate <- NA
pair_wise_data$weekly_evic_rate <- pair_wise_data$total_evictions/(as.numeric(pair_wise_data$dwelling_count)*as.numeric(pair_wise_data$ownership_time))
pair_wise_data$weekly_evic_rate[is.na(pair_wise_data$weekly_evic_rate)] <- 0

#Ownerships that Changed Hands

transactions <- pair_wise_data %>% 
  count(PARCEL_ID) %>% filter(n > 1)

pair_wise_data <- pair_wise_data[pair_wise_data$PARCEL_ID %in% transactions$PARCEL_ID,]

pair_wise_data$Umbrella.Indic = as.character(pair_wise_data$Umbrella.Indic)

for (i in 1:length(pair_wise_data$Umbrella.Indic)) {
  if(pair_wise_data$Umbrella.Indic[i] == "") {
    pair_wise_data$Umbrella.Indic[i] = "N"
  }
}

#Excluding non-profits, GSEs, funds, anything missing, unclear and Other

pair_wise_data$RHFS.Classifications = as.character(pair_wise_data$RHFS.Classifications)
pair_wise_data <- pair_wise_data %>% filter(RHFS.Classifications == "Individual" | 
                          RHFS.Classifications == "LLP, LP, or LLC" |
                          RHFS.Classifications == "Business Corp" |
                          RHFS.Classifications == "REIT" |
                          RHFS.Classifications == "Private Equity" |
                          RHFS.Classifications == "Investment Firm" |
                          RHFS.Classifications == "Hedgefund sponser")


#Much higher eviction rate in Yes! In fact, signficantly higher...
t.test(weekly_evic_rate~Umbrella.Indic,data=pair_wise_data)

boxplot(data = pair_wise_data, weekly_evic_rate~RHFS.Classifications)

anova_on_class <- aov(data = pair_wise_data, weekly_evic_rate~RHFS.Classifications)

summary(anova_on_class)

#Things look a little strange so let's create some restriction on outliers.
#1) Seems valid to assume we only look at owners who have owned the property longer than 3 months
#so we restrict ownership time to greater than 12 since it is weekly ownership.

tiny_landlords <- pair_wise_data %>% filter(unit_sizes == "tiny") %>% filter(ownership_time > 12)
small_landlords <- pair_wise_data %>% filter(unit_sizes == "small") %>% filter(ownership_time > 12)
medium_landlords <- pair_wise_data %>% filter(unit_sizes == "medium") %>% filter(ownership_time > 12)
large_landlords <- pair_wise_data %>% filter(unit_sizes == "large") %>% filter(ownership_time > 12)

#Checking Out Tiny Landlords
t.test(weekly_evic_rate~Umbrella.Indic,data=tiny_landlords)
boxplot(data = tiny_landlords, weekly_evic_rate~Umbrella.Indic)
anova_on_class <- aov(data = tiny_landlords, weekly_evic_rate~RHFS.Classifications)
summary(anova_on_class)
boxplot(data = large_landlords, weekly_evic_rate~RHFS.Classifications)

#Checking Out Large Landlords
t.test(weekly_evic_rate~Umbrella.Indic,data=large_landlords)
boxplot(data = large_landlords, weekly_evic_rate~Umbrella.Indic)
anova_on_class <- aov(data = large_landlords, weekly_evic_rate~RHFS.Classifications)
summary(anova_on_class)
boxplot(data = large_landlords, weekly_evic_rate~RHFS.Classifications)

#Checking Out Medium Landlords
t.test(weekly_evic_rate~Umbrella.Indic,data=medium_landlords)
boxplot(data = medium_landlords, weekly_evic_rate~Umbrella.Indic)
anova_on_class <- aov(data = medium_landlords, weekly_evic_rate~RHFS.Classifications)
summary(anova_on_class)
boxplot(data = medium_landlords, weekly_evic_rate~RHFS.Classifications)

#Nothing really popping out here, nothing super significant in terms of eviction rates of different classifications...

#Let's check out only those parcels that have changed from indiv to something else. 

indiv_owners <- pair_wise_data %>% filter(RHFS.Classifications == "Individual")

pair_wise_data <- pair_wise_data[pair_wise_data$PARCEL_ID %in% indiv_owners$PARCEL_ID,]

sample  = pair_wise_data[3:6,]

test = pair_wise_data %>% 
  filter(ownership_time > 12) %>%
  group_by(PARCEL_ID) %>%
  arrange(Start_Date) %>%
  mutate(
    owner_prev = lag(Umbrella.Name),
    type_prev = lag(RHFS.Classifications),
    evic_rate_prev = lag(weekly_evic_rate)
  )

test$owner_curr = test$Umbrella.Name
test$type_curr = test$RHFS.Classifications
test$evic_rate_curr = test$weekly_evic_rate

test = test[,c(19:24)]

test = test[!is.na(test$owner_prev),]

indiv_to_bus_corp = test %>% 
  filter(type_prev == "Individual" & type_curr == "Business Corp")
  
t.test(indiv_to_bus_corp$evic_rate_prev, 
       indiv_to_bus_corp$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)
  
bus_to_indiv_corp = test %>% 
  filter(type_prev == "Business Corp" & type_curr == "Individual")
  
t.test(bus_to_indiv_corp$evic_rate_prev, 
       bus_to_indiv_corp$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

test = pair_wise_data %>% 
  filter(ownership_time > 12) %>%
  group_by(PARCEL_ID) %>%
  arrange(Start_Date) %>%
  mutate(
    owner_prev = lag(Umbrella.Name),
    type_prev = lag(RHFS.Classifications),
    evic_rate_prev = lag(weekly_evic_rate)
  )
