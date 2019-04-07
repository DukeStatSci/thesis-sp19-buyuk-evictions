#Ownership Changes in Durham EDA 

owner_data <- read_csv("owner_data.csv", col_types = cols(X1 = col_skip()))
owner_data$RHFS.Classifications = as.character(owner_data$RHFS.Classifications)
owner_data$ownership_time <- NA
owner_data$ownership_time <- difftime(owner_data$End_Date,owner_data$Start_Date,units = "weeks")

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

owner_data_subset <- owner_data %>% filter(RHFS.Classifications == "LLP, LP, or LLC" |
                                                RHFS.Classifications == "REIT" |
                                                RHFS.Classifications == "Private Equity" |
                                                RHFS.Classifications == "Business Corp" |
                                                RHFS.Classifications == "Individual")

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

# Reclassify as Corp or Not Corp 
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Business Corp"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "LLP, LP, or LLC"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Private Equity"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "REIT"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Hedgefund Sponser"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Investment Firm"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Other"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Non-Profit Corp"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Trustee for estate"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Estate"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "GSE"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Other - DHA"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Unclear"] <- "Unclear"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Missing"] <- "Unclear"

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
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

corporate_v_not$Mailing.Office.State <- as.character(corporate_v_not$Mailing.Office.State)
corporate_v_not$Mailing.Office.State[is.na(corporate_v_not$Mailing.Office.State)==TRUE] <- "NC"
corporate_v_not$Mailing.Office.State[corporate_v_not$Mailing.Office.State!="NC"] <- "OutofState"

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
  geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")
large_landlords_year_plot

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
  #geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

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
  #geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

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
  #geom_smooth(se=FALSE) +
  ggtitle("Ownership Rates Across Years")

#Eviction Rate Formatting 
evic_by_year = complete_data %>% count(year)
evic_by_year$RHFS.Classifications <- NA
evic_by_year$RHFS.Classifications <- "Evictions"
evic_by_year <- evic_by_year %>% select("RHFS.Classifications","year","n")
evic_by_year <- setNames(evic_by_year, c("RHFS.Classifications","Year","Ownership Rate"))
evic_by_year$`Ownership Rate` <- evic_by_year$`Ownership Rate`/10000

#Combine Together 

tiny_landlords_year$Size <- NA
small_landlords_year$Size <- NA
med_landlords_year$Size <- NA
large_landlords_year$Size <- NA

tiny_landlords_year$Size <- "Tiny (2-4 Dwelling Units)"
small_landlords_year$Size <- "Small (5-24 Dwelling Units)"
med_landlords_year$Size <- "Medium (25-49 Dwelling Units"
large_landlords_year$Size <- "Large (50+ Dwelling Units)"

all_ownerships <- rbind(tiny_landlords_year,small_landlords_year)
all_ownerships <- rbind(all_ownerships, med_landlords_year)
all_ownerships <- rbind(all_ownerships,large_landlords_year)

all_ownerships$Year <- paste0("'",substr(all_ownerships$Year,3,4))

all_ownerships$`Ownership Type` <- all_ownerships$RHFS.Classifications

ggplot(data = all_ownerships %>% filter(`Ownership Type` == "Corporate"),aes(x = Year, y = `Ownership Rate`,colour = `Size`)) +
  geom_point(size = 4) + 
  geom_line(aes(group = `Size`)) +
  theme_bw() +
  theme(axis.text = element_text(size=12),
        axis.title=element_text(size=14),
        legend.title=element_text(size=14), 
        legend.text=element_text(size=12))

summary(glm(evic_rate ~ as.factor(period) + as.factor(owner_type) +
              as.factor(period)*as.factor(owner_type),
            family=binomial(),weights = dwelling_unit,data = indiv_to_OS))


  