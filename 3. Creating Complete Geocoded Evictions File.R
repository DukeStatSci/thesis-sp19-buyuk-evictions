#Create Complete Geocoded Shape File 

evictions_2011_sf <- st_as_sf(geocoded_2000_2011, coords = c("x", "y"), crs = 2264)
evictions_2011_sf <- evictions_2011_sf[,c(2,1,5,6,7,4,3,8,9,10)]
evictions_2011_sf <- evictions_2011_sf %>% select(-c("type2"))
evictions_2011_sf$Statusdate <- as.Date(evictions_2011_sf$Statusdate, format = "%m/%d/%Y")
evictions_2011_sf$Dateissued <- as.Date(evictions_2011_sf$Dateissued, format = "%m/%d/%Y")

evictions_2012_2018_sf <- sf::st_transform(evictions_2012_2018, crs = 2264)
names(evictions_2012_2018_sf) <- c("docketno","address","civilstatus","involvement","type1","Statusdate","Dateissued","year","geometry")

evictions_2012_2018_sf$Statusdate = as.character(evictions_2012_2018_sf$Statusdate)
evictions_2012_2018_sf$Statusdate <- as.Date(evictions_2012_2018_sf$Statusdate, format = "%Y-%m-%d")

evictions_2012_2018_sf$Dateissued = as.character(evictions_2012_2018_sf$Dateissued)
evictions_2012_2018_sf$Dateissued <- as.Date(evictions_2012_2018_sf$Dateissued, format = "%Y-%m-%d")

evictions <- rbind(evictions_2011_sf,evictions_2012_2018_sf)

census_sf <- sf::st_transform(census_parcels_filtered, crs = 2264)
census_evic <- st_join(evictions, census_sf, join = st_intersects)
