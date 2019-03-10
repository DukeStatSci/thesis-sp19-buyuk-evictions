#Ownership Changes in Durham EDA 

owner_data <- read_csv("owner_data.csv", col_types = cols(X1 = col_skip()))
owner_data$RHFS.Classifications = as.character(owner_data$RHFS.Classifications)

owner_by_year <- owner_data %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

owner_by_year[,-1] = apply(owner_by_year[,-1],2,function(x){x/sum(x)})

owner_by_year= gather(owner_by_year,"Year","Ownership Rate",-RHFS.Classifications)
owner_by_year_plot <- ggplot(data = owner_by_year, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

write.csv(owner_by_year,"all_rhfs_classifications_information.csv")
owner_data_subset <- owner_data %>% filter(RHFS.Classifications == "LLP, LP, or LLC" |
                                             RHFS.Classifications == "REIT" |
                                             RHFS.Classifications == "Private Equity" |
                                             RHFS.Classifications == "Business Corp" |
                                             RHFS.Classifications == "Individual" |
                                             RHFS.Classifications == "Investment Firm")

owner_by_year_subset <- owner_data_subset %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

owner_by_year_subset[,-1] = apply(owner_by_year_subset[,-1],2,function(x){x/sum(x)})

owner_by_year_subset= gather(owner_by_year_subset,"Year","Ownership Rate",-RHFS.Classifications)

owner_by_year_subset_plot <- ggplot(data = owner_by_year_subset, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

corporate_v_not <- owner_data

# Reclassify as Owner or Not Owner 
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Business Corp"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "LLP, LP, or LLC"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Private Equity"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "REIT"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Hedgefund sponser"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Investment Firm"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Fund"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Other"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Non-Profit Corp"] <- "Non-Profits & DHA"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Trustee for estate"] <- "Individual"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Estate"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "GSE"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Other - DHA"] <- "Non-Profits & DHA"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Unclear"] <- "Unclear"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Missing"] <- "Unclear"

corporate_v_not$ownership_time = NA

corporate_v_not$ownership_time = difftime(corporate_v_not$End_Date,corporate_v_not$Start_Date,units = "weeks")

owner_by_year_corp <- corporate_v_not %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

owner_by_year_corp[,-1] = apply(owner_by_year_corp[,-1],2,function(x){x/sum(x)})

owner_by_year_corp= gather(owner_by_year_corp,"Year","Ownership Rate",-RHFS.Classifications)

ownership_rates_across_years <- ggplot(data = owner_by_year_corp, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

ownership_rates_across_years + theme_minimal()

write.csv(owner_by_year_corp,"plot1data.csv")
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Non-Profits & DHA"] <- "Other"

tiny_landlords <- corporate_v_not %>% filter(unit_sizes == "tiny") %>% filter(ownership_time > 12)
small_landlords <- corporate_v_not %>% filter(unit_sizes == "small") %>% filter(ownership_time > 12)
medium_landlords <- corporate_v_not %>% filter(unit_sizes == "medium") %>% filter(ownership_time > 12)
large_landlords <- corporate_v_not %>% filter(unit_sizes == "large") %>% filter(ownership_time > 12)

#Checking Out Landlord Eviction Rates 
boxplot(data = tiny_landlords, weekly_evic_rate~RHFS.Classifications)
boxplot(data = small_landlords, weekly_evic_rate~RHFS.Classifications)

mm_ttest = medium_landlords %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")

t.test(data = mm_ttest, weekly_evic_rate~RHFS.Classifications)
summary(anova_on_class)
boxplot(data = medium_landlords, weekly_evic_rate~RHFS.Classifications)

ll_ttest = large_landlords %>% filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual")

anova_on_class <- aov(data = test, weekly_evic_rate~RHFS.Classifications)
summary(anova_on_class)
boxplot(data = large_landlords, weekly_evic_rate~RHFS.Classifications)

large_landlords_year <- large_landlords %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

large_landlords_year[,-1] = apply(large_landlords_year[,-1],2,function(x){x/sum(x)})

large_landlords_year= gather(large_landlords_year,"Year","Ownership Rate",-RHFS.Classifications)

large_landlords_year_plot <- ggplot(data = large_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Large Landlords (50+ units)")
large_landlords_year_plot + theme_minimal()

write.csv(large_landlords_year,"plot6data.csv")
med_landlords_year <- medium_landlords %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

med_landlords_year[,-1] = apply(med_landlords_year[,-1],2,function(x){x/sum(x)})

med_landlords_year= gather(med_landlords_year,"Year","Ownership Rate",-RHFS.Classifications)

med_landlords_year_plot <- ggplot(data = med_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Medium Landlords (25-50 units)")
med_landlords_year_plot + theme_minimal()

write.csv(med_landlords_year,"plot7data.csv")
small_landlords_year <- small_landlords %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

small_landlords_year[,-1] = apply(small_landlords_year[,-1],2,function(x){x/sum(x)})

small_landlords_year= gather(small_landlords_year,"Year","Ownership Rate",-RHFS.Classifications)

small_landlords_year_plot <- ggplot(data = small_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Small Landlords (5-24 units)")
small_landlords_year_plot + theme_minimal()

write.csv(small_landlords_year,"plot8data.csv")
tiny_landlords_year <- tiny_landlords %>% group_by(RHFS.Classifications) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

tiny_landlords_year[,-1] = apply(tiny_landlords_year[,-1],2,function(x){x/sum(x)})

tiny_landlords_year= gather(tiny_landlords_year,"Year","Ownership Rate",-RHFS.Classifications)

tiny_landlords_year_plot <- ggplot(data = tiny_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=RHFS.Classifications)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Tiny Landlords (<5 units)")
tiny_landlords_year_plot + theme_minimal()

write.csv(tiny_landlords_year,"plot9data.csv")

#Eviction Rate Formatting 
evic_by_year = complete_data %>% count(year)
evic_by_year$RHFS.Classifications <- NA
evic_by_year$RHFS.Classifications <- "Evictions"
evic_by_year <- evic_by_year %>% select("RHFS.Classifications","year","n")
evic_by_year <- setNames(evic_by_year, c("RHFS.Classifications","Year","Ownership Rate"))
evic_by_year$`Ownership Rate` <- evic_by_year$`Ownership Rate`/10000
evic_by_year$`Eviction Rate` = evic_by_year$`Ownership Rate`
evic_by_year = evic_by_year %>% as.data.frame()
evic_by_year$Year

evic_plot <- ggplot(data = evic_by_year, aes(x=Year,y=`Eviction Rate`)) +
  geom_point() +
  ggtitle("Eviction Rate Over the Years")
evic_plot + theme_minimal()

#Ownership Changes by State

corporate_v_not$Mailing.Office.State[is.na(corporate_v_not$Mailing.Office.State)] <- "NC"
corporate_v_not$Mailing.Office.State[corporate_v_not$Mailing.Office.State != "NC"] <- "OutOfState"

owner_location <- corporate_v_not %>% group_by(Mailing.Office.State) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

owner_location[,-1] = apply(owner_location[,-1],2,function(x){x/sum(x)})

owner_location= gather(owner_location,"Year","Ownership Rate",-Mailing.Office.State)

owner_location_across_years <- ggplot(data = owner_location, aes(x=Year,y=`Ownership Rate`,colour=Mailing.Office.State)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

owner_location_across_years+ theme_minimal()
write.csv(owner_location,"plot11data.csv")

large_landlords_year <- large_landlords %>% group_by(Mailing.Office.State) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

large_landlords_year[,-1] = apply(large_landlords_year[,-1],2,function(x){x/sum(x)})

large_landlords_year= gather(large_landlords_year,"Year","Ownership Rate",-Mailing.Office.State)

large_landlords_year_plot <- ggplot(data = large_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=Mailing.Office.State)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Large Landlords (50+ units)")
large_landlords_year_plot + theme_minimal()

write.csv(large_landlords_year,"plot12data.csv")

med_landlords_year <- medium_landlords %>% group_by(Mailing.Office.State) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

med_landlords_year[,-1] = apply(med_landlords_year[,-1],2,function(x){x/sum(x)})

med_landlords_year= gather(med_landlords_year,"Year","Ownership Rate",-Mailing.Office.State)

med_landlords_year_plot <- ggplot(data = med_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=Mailing.Office.State)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Medium Landlords (25-50 units)")
med_landlords_year_plot + theme_minimal()

write.csv(med_landlords_year,"plot13data.csv")

small_landlords_year <- small_landlords %>% group_by(Mailing.Office.State) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

small_landlords_year[,-1] = apply(small_landlords_year[,-1],2,function(x){x/sum(x)})

small_landlords_year= gather(small_landlords_year,"Year","Ownership Rate",-Mailing.Office.State)

small_landlords_year_plot <- ggplot(data = small_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=Mailing.Office.State)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Small Landlords (5-24 units)")
small_landlords_year_plot + theme_minimal()

write.csv(small_landlords_year,"plot14data.csv")
tiny_landlords_year <- tiny_landlords %>% group_by(Mailing.Office.State) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

tiny_landlords_year[,-1] = apply(tiny_landlords_year[,-1],2,function(x){x/sum(x)})

tiny_landlords_year= gather(tiny_landlords_year,"Year","Ownership Rate",-Mailing.Office.State)

tiny_landlords_year_plot <- ggplot(data = tiny_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=Mailing.Office.State)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Tiny Landlords (<5 units)")
tiny_landlords_year_plot + theme_minimal()

write.csv(tiny_landlords_year,"plot15data.csv")

large_landlords_year <- large_landlords %>% group_by(Mailing.Office.State) %>% 
  summarise(`2000` = sum(`2000`),
            `2001` = sum(`2001`),
            `2002` = sum(`2002`),
            `2003` = sum(`2003`),
            `2004` = sum(`2004`),
            `2005` = sum(`2005`),
            `2006` = sum(`2006`),
            `2007` = sum(`2007`),
            `2008` = sum(`2008`),
            `2009` = sum(`2009`),
            `2010` = sum(`2010`),
            `2011` = sum(`2011`),
            `2012` = sum(`2012`),
            `2013` = sum(`2013`),
            `2014` = sum(`2014`),
            `2015` = sum(`2015`),
            `2016` = sum(`2016`),
            `2017` = sum(`2017`),
            `2018` = sum(`2018`))

large_landlords_year[,-1] = apply(large_landlords_year[,-1],2,function(x){x/sum(x)})

large_landlords_year= gather(large_landlords_year,"Year","Ownership Rate",-Mailing.Office.State)

large_landlords_year_plot <- ggplot(data = large_landlords_year, aes(x=Year,y=`Ownership Rate`,colour=Mailing.Office.State)) +
  geom_point() +
  labs(color='Ownership Types') +
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates For Large Landlords (50+ units)")
large_landlords_year_plot + theme_minimal()

write.csv(large_landlords_year,"large_landlords_ownership_changes_by_state.csv")
