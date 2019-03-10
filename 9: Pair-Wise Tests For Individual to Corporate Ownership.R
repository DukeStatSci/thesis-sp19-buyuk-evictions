#9: Pair-Wise Tests For Individual to Corporate Ownership

corporate_v_not <- apt_evictions_eda

corporate_v_not$RHFS.Classifications = as.character(corporate_v_not$RHFS.Classifications)

corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Business Corp"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "LLP, LP, or LLC"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Private Equity"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "REIT"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Fund"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Hedgefund sponser"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Investment Firm"] <- "Corporate"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Other"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Non-Profit Corp"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Trustee for estate"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Estate"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "GSE"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Other - DHA"] <- "Other"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Unclear"] <- "Unclear"
corporate_v_not$RHFS.Classifications[corporate_v_not$RHFS.Classifications == "Missing"] <- "Unclear"

pair_wise_tests = corporate_v_not %>% 
  filter(ownership_time > 12) %>%
  filter(RHFS.Classifications == "Corporate" | RHFS.Classifications == "Individual") %>%
  group_by(PARCEL_ID) %>%
  arrange(Start_Date) %>%
  mutate(
    owner_prev = lag(Umbrella.Name),
    type_prev = lag(RHFS.Classifications),
    evic_rate_prev = lag(weekly_evic_rate)
  )

pair_wise_tests$owner_curr = pair_wise_tests$Umbrella.Name
pair_wise_tests$type_curr = pair_wise_tests$RHFS.Classifications
pair_wise_tests$evic_rate_curr = pair_wise_tests$weekly_evic_rate

pair_wise_tests = pair_wise_tests[!is.na(pair_wise_tests$owner_prev),]

indiv_to_corp = pair_wise_tests %>% 
  filter(type_prev == "Individual" & type_curr == "Corporate")

t.test(indiv_to_corp$evic_rate_prev, 
       indiv_to_corp$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

#significant, indicating individuals tend to evict more.

#Let's check out by size though...

big_landlords <- indiv_to_corp %>% filter(unit_sizes == "large")
t.test(big_landlords$evic_rate_prev, 
       big_landlords$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

#Not significant, negative t indicating corporate landlords evict more
#but not significantly higher eviction rates...

medium_landlords <- indiv_to_corp %>% filter(unit_sizes == "medium")
t.test(medium_landlords$evic_rate_prev, 
       medium_landlords$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

#Not significant, negative t indicating corporate landlords evict more
#but not significantly higher eviction rates...

small_landlords <- indiv_to_corp %>% filter(unit_sizes == "small")
t.test(small_landlords$evic_rate_prev, 
       small_landlords$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)

#Not significant, positive t indicating individual landlords evict more
#but not significantly higher eviction rates...

tiny_landlords <- indiv_to_corp %>% filter(unit_sizes == "tiny")
t.test(tiny_landlords$evic_rate_prev, 
       tiny_landlords$evic_rate_curr, 
       paired=TRUE, 
       conf.level=0.95)
#Significant!!! Tiny landlords --> p-value  = 0.0062. Individuals tend to evict more 
#than the corporates that buy these properties. 



