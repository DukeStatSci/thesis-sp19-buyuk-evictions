#11: Exploring The Outliers 

#Point 1: The number of evictions associated with those that switched from Individual to Corprorate 
#v. not associated is drastic. 

#47,668 evictions associated with Corporate: LLC, Business Corp, Private Equity, Hedgefund Sponser, Investment Firm, REIT
length(binned_corp_owners$Statusdate)

#6,739 evictions associated with Individual
length(binned_indiv_owners$Statusdate)

#3,279 evictions associated with the corporates that turned over from individuals...
indiv_to_corp_corp_evics <- binned_corp_owners[binned_corp_owners$PARCEL_ID.x %in% indiv_to_corp$PARCEL_ID, ]
length(indiv_to_corp_corp_evics$Statusdate)

#4,401 evictions associated with the indidivuals that were then bought by corporates...
indiv_to_corp_indiv_evics <- binned_indiv_owners[binned_indiv_owners$PARCEL_ID.x %in% indiv_to_corp$PARCEL_ID, ]
length(indiv_to_corp_indiv_evics$Statusdate)

#So not the best story to show this particular switch if the eviction breakdowns look like this... 
#Maybe we need to look at the outliers some more... 

#Point 2: There are a handful of big eviction names- cutoff at 300 right now. 

#Outliers Table 
highest_evictors_count <- head(apt_evictions_eda[order(-apt_evictions_eda$total_evictions),],50)
highest_evictors_count <- highest_evictors_count %>% 
  select(c("PARCEL_ID","Start_Date","End_Date","total_evictions","dwelling_count","unit_sizes",
           "ownership_time","weekly_evic_rate","RHFS.Classifications", "Mailing.Office.State","Umbrella.Indic",
           "Umbrella.Name","Individual.Family.Names","More.Notes","Private.Public","Latitude","Longitude","Deeded.Owner.Address.1","Deeded.Owner.Address.2"))

groups_table <- highest_evictors_count %>% count(RHFS.Classifications)
groups_table <- groups_table[order(-groups_table$n),]

groups_table

#As we can see, the top evictors are classified as mainly Corporates here. Let's look into these evictors a little more...

#This is the highest evictor at a single parcel: EC Powell Durham Investments LLC
parcel_121586 <- complete_data %>% filter(PARCEL_ID == "121586") %>% count(Statusdate)

ggplot(parcel_121586, aes(Statusdate, n)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %y") +
  ylim(0,30) +
  geom_smooth(se=FALSE) +
  geom_vline(xintercept = as.Date("2014-12-30"),
             size = 2, colour = "red") +
  ggtitle("Evictions for Highest Total Evicting Parcel")

#Actually turns out they owned it the whole time...
apt_evictions_eda %>% filter(PARCEL_ID == "121586") %>% select(Start_Date,End_Date,Umbrella.Name)

#This is the second highest evictor at a single parcel: The Decurion Corporation
parcel_152986 <- complete_data %>% filter(PARCEL_ID == "152986") %>% count(Statusdate)

ggplot(parcel_152986, aes(Statusdate, n)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %y") +
  ylim(0,30) +
  geom_smooth(se=FALSE) +
  geom_vline(xintercept = as.Date("2015-10-07"),
             size = 2, colour = "red") +
  ggtitle("Evictions for The Decurion Corporation")

#Next owner = Somerset Apartment Management

#Nothing super interesting in these pictures....
#What if we look at the owners in aggregate though?

agg_evictors <- apt_evictions_eda %>% 
  group_by(Umbrella.Name) %>% 
  summarise(total_evics = sum(total_evictions,na.rm=TRUE),
            total_parcels = n())

agg_evictor_types <- apt_evictions_eda %>% 
  group_by(RHFS.Classifications) %>% 
  summarise(total_evics = sum(total_evictions,na.rm=TRUE),
            total_parcels = n(),
            total_dwellings = sum(dwelling_count))

#Ticon Properties LLC seems wholly problematic....

ticon <- complete_data %>% filter(Umbrella.Name == "TICON PROPERTIES LLC") %>% count(Statusdate)

ggplot(ticon, aes(Statusdate, n)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %y") +
  ylim(0,30) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Ticon LLC")

#Looks largely in line with the average breakdown over the years... 

ec_powell <- complete_data %>% filter(Umbrella.Name == "EC Powell Durham Investments LLC") %>% count(Statusdate)

ggplot(ec_powell, aes(Statusdate, n)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %y") +
  ylim(0,30) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_smooth(se=FALSE) +
  ggtitle("Evictions for EC Powell")

#A lot more dense...

highest_evictors_rate <- head(apt_evictions_eda[order(-apt_evictions_eda$weekly_evic_rate),],50)
highest_evictors_rate <- highest_evictors_rate %>% 
  select(c("PARCEL_ID","Start_Date","End_Date","total_evictions","dwelling_count","unit_sizes",
           "ownership_time","weekly_evic_rate","RHFS.Classifications", "Mailing.Office.State","Umbrella.Indic",
           "Umbrella.Name","Individual.Family.Names","More.Notes","Private.Public","Latitude","Longitude","Deeded.Owner.Address.1","Deeded.Owner.Address.2"))

parcel_118062 <- complete_data %>% filter(PARCEL_ID == "118062") %>% count(Statusdate)

ggplot(parcel_118062, aes(Statusdate, n)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %y") +
  ylim(0,30) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Roberti Samuel")

parcel_113341 <- complete_data %>% filter(PARCEL_ID == "113341") %>% count(Statusdate)

ggplot(parcel_113341, aes(Statusdate, n)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %y") +
  ylim(0,30) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Edgewood Properties LLC")

#Point 4: Let's Check Out Corporate Evictors:

evics_for_corps <- binned_corp_owners %>% count(eviction_time)

ggplot(evics_for_corps, aes(eviction_time,n)) +
  geom_line() +
  ylim(0,50) +
  geom_smooth(se=FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Corporates")

evics_for_indivs <- binned_indiv_owners %>% count(eviction_time)

ggplot(evics_for_indivs, aes(eviction_time,n)) +
  geom_line() +
  ylim(0,15) +
  geom_smooth(se=FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Individuals")

#Point 5: Let's check out for switches in ownership that we know of...

#Indiv to Corp Switch - not as clear here.

corps_switch <- binned_corp_owners[binned_corp_owners$PARCEL_ID.x %in% indiv_to_corp$PARCEL_ID, ]
indivs_switch <- binned_indiv_owners[binned_indiv_owners$PARCEL_ID.x %in% indiv_to_corp$PARCEL_ID, ]

corps <- corps_switch %>% count(eviction_time)

ggplot(corps_switch,aes(x=eviction_time)) +
  geom_density()
#one-sided density plot (density plot with a hard bound)

ggplot(indivs_switch,aes(x=eviction_time)) +
  geom_density()

ggplot(corps, aes(eviction_time,n)) +
  geom_line() +
  ylim(0,15) +
  geom_smooth(se=FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Corporates")

indivs <- indivs_switch %>% count(eviction_time)

ggplot(indivs, aes(eviction_time,n)) +
  geom_line() +
  ylim(0,15) +
  geom_smooth(se=FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Individuals")

#What if we split up further, for example, by REIT or P.E.? 

reits <- merged_data %>% filter(RHFS.Classifications == "REIT")
reits$eviction_time <- difftime(reits$Statusdate,reits$Start_Date, units = "weeks")
reits$eviction_time_before_end <- difftime(reits$End_Date, reits$Statusdate, units = "weeks")

reit_trend <- reits %>% count(eviction_time)

ggplot(reit_trend, aes(eviction_time,n)) +
  geom_line() +
  ylim(0,30) +
  geom_smooth(se=FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for REITs")

pequity <- merged_data %>% filter(RHFS.Classifications == "Private Equity")
pequity$eviction_time <- difftime(pequity$Statusdate,pequity$Start_Date, units = "weeks")
pequity$eviction_time_before_end <- difftime(pequity$End_Date, pequity$Statusdate, units = "weeks")

pequity_trend <- pequity %>% count(eviction_time)

ggplot(pequity_trend, aes(eviction_time,n)) +
  geom_line() +
  ylim(0,15) +
  geom_smooth(se=FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Evictions for Private Equity Firms")

#Does seem to be some sort of downward trend but hard to see in this manner...
#need to put into bins... 



