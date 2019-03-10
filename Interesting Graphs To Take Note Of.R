#Interesting Ownership Changes Graphs

#Ownership Rates Across Years of Select Types of Businesses 
owner_by_year_subset_plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))

#Ownership Rates Across Years of Corporate v. Not Corporate
ownership_rates_across_years + theme(axis.text.x = element_text(angle = 90, hjust = 1))

#What about large properties?
large_landlords_year_plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))

i#What about medium properties?
med_landlords_year_plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))

#What about small proprties?
small_landlords_year_plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))

#What about tiny properties?
tiny_landlords_year_plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#Still remain minority but increasing!!!!

#Add eviction rate????
test = rbind(as.data.frame(owner_by_year_corp),as.data.frame(evic_by_year))
ggplot(data = test, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  ggtitle("Ownership Rates Across Years")

#What is going on in certain tracts???

#Tract: 1807
tract_1807 <- parcels_in_tract %>% filter(TRACT == "001807") %>% select("PARCEL_","sum_du")
tract_1807
#The other 3 have 0 evictions. Then... 
owner_data %>% filter(PARCEL_ID == 158464) %>% select(Start_Date, End_Date, Umbrella.Name, total_evictions)

#Boxplots
boxplot(data = tiny_landlords, weekly_evic_rate~RHFS.Classifications)
boxplot(data = medium_landlords, weekly_evic_rate~RHFS.Classifications)
boxplot(data = small_landlords, weekly_evic_rate~RHFS.Classifications)
boxplot(data = large_landlords, weekly_evic_rate~RHFS.Classifications)

#Checking Out if Corporate Eviction Rates Higher 
corp_v_not = corporate_v_not %>% filter(ownership_time > 12) %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")
t.test(data = corp_v_not, weekly_evic_rate~RHFS.Classifications)
#Individuals have higher eviction rates than corporates do.

tt_test = tiny_landlords %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")
t.test(data = tt_test, weekly_evic_rate~RHFS.Classifications)

ss_ttest = small_landlords %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")
t.test(data = ss_ttest, weekly_evic_rate~RHFS.Classifications)

mm_ttest = medium_landlords %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")
t.test(data = mm_ttest, weekly_evic_rate~RHFS.Classifications)

ll_ttest = large_landlords %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")
t.test(data = ll_ttest, weekly_evic_rate~RHFS.Classifications)

ggplot(corp_v_not, aes(x=RHFS.Classifications, y=weekly_evic_rate)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4) + 
  scale_y_log10()

ggplot(mm_ttest, aes(x=RHFS.Classifications, y=weekly_evic_rate)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4) + 
  scale_y_log10()

ggplot(tt_test, aes(x=RHFS.Classifications, y=weekly_evic_rate)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4) #+ 
  #scale_y_log10()

ggplot(ss_ttest, aes(x=RHFS.Classifications, y=weekly_evic_rate)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4) + 
  scale_y_log10()

test <- head(ss_ttest[order(-ss_ttest$weekly_evic_rate),],10)
test <- test %>% 
  select(c("PARCEL_ID","Start_Date","End_Date","total_evictions","dwelling_count","unit_sizes",
           "ownership_time","weekly_evic_rate","RHFS.Classifications", "Mailing.Office.State","Umbrella.Indic",
           "Umbrella.Name","Individual.Family.Names","More.Notes","Private.Public","Dissolved",
           "Latitude","Longitude"))
  
#Local Linear Regression? Regression discontinuity?

#How do we do a paired t-test?
transactions <- ss_ttest %>% 
  count(PARCEL_ID) %>% filter(n > 1)

pair_wise_ss_data <- ss_ttest[ss_ttest$PARCEL_ID %in% transactions$PARCEL_ID,]

t.test(data = ss_ttest, weekly_evic_rate~RHFS.Classifications, paired = TRUE, alternative = "two.sided")


#What about REITs v individuals? LOL Individuals evict significantly higher than REITs. Yikes. 

reit_or_indiv <- owner_data %>% filter(RHFS.Classifications == "Individual" | RHFS.Classifications == "REIT") %>% filter(ownership_time > 12) 

t.test(data = reit_or_indiv, weekly_evic_rate~RHFS.Classifications)

ggplot(reit_or_indiv, aes(x=RHFS.Classifications, y=weekly_evic_rate)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4) + 
  scale_y_log10()

small_owner_time <- head(apt_evictions_eda[order(apt_evictions_eda$ownership_time),],150)

small_owner_time <- small_owner_time %>% 
  select(c("PARCEL_ID","Start_Date","End_Date","total_evictions","dwelling_count","unit_sizes",
           "ownership_time","weekly_evic_rate","RHFS.Classifications", "Mailing.Office.State","Umbrella.Indic",
           "Umbrella.Name","Individual.Family.Names","More.Notes","Private.Public","Dissolved",
           "Explanation","Latitude","Longitude","Deeded.Owner.Address.1","Deeded.Owner.Address.2"))

highest_evictors <- head(apt_evictions_eda[order(-apt_evictions_eda$total_evictions),],150)
highest_evictors <- highest_evictors %>% 
  select(c("PARCEL_ID","Start_Date","End_Date","total_evictions","dwelling_count","unit_sizes",
           "ownership_time","weekly_evic_rate","RHFS.Classifications", "Mailing.Office.State","Umbrella.Indic",
           "Umbrella.Name","Individual.Family.Names","More.Notes","Private.Public","Dissolved",
           "Explanation","Latitude","Longitude","Deeded.Owner.Address.1","Deeded.Owner.Address.2"))
write.csv(highest_evictors,"highest_evictors_by_number.csv")

apt_evictions_eda_1 <- apt_evictions_eda %>% filter(ownership_time >= 12)
  
highest_evictors_rate <- head(apt_evictions_eda_1[order(-apt_evictions_eda_1$weekly_evic_rate),],150)
highest_evictors_rate <- highest_evictors_rate %>% 
  select(c("PARCEL_ID","Start_Date","End_Date","total_evictions","dwelling_count","unit_sizes",
           "ownership_time","weekly_evic_rate","RHFS.Classifications", "Mailing.Office.State","Umbrella.Indic",
           "Umbrella.Name","Individual.Family.Names","More.Notes","Private.Public","Dissolved",
           "Explanation","Latitude","Longitude","Deeded.Owner.Address.1","Deeded.Owner.Address.2"))

write.csv(highest_evictors_rate,"highest_evictors_by_rate.csv")

