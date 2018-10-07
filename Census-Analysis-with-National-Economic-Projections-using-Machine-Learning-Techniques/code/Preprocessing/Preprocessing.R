d1 <- read.csv("PopulationEstimates.csv", stringsAsFactors = T)
d2 <- read.csv("Unemployment.csv", stringsAsFactors = T)

mm <- merge(d1,d2, by = "FIPS")
str(mm)
write.csv(mm, "merged.csv", row.names = F, col.names = T)

popdata <- read.csv("merged.csv", stringsAsFactors = T)

rm(d1,d2,mm)

popdata <- popdata[,-1:-2]
popdata <- popdata[,-2:-9]
popdata <- popdata[,-9:-65]
popdata <- popdata[,-16:-17]
popdata <- popdata[,-44:-57]
popdata <- popdata[,-51:-71]
popdata <- popdata[,-79:-80]
popdata <- popdata[,-9:-15]
popdata <- popdata[,-45]
popdata <- popdata[,-48]
popdata <- popdata[,-51]
popdata <- popdata[,-54]
popdata <- popdata[,-57]
popdata <- popdata[,-60]
popdata <- popdata[,-63]

#str(popdata)
#summary(popdata)
#mising values:
sapply(popdata,function(x) sum(is.na(x)))
popdata <- na.omit(popdata)
sapply(popdata,function(x) sum(is.na(x)))
#sapply(popdata,function(x) sum(is.na(x)))

popdata <- popdata[-1,]
popdata$POP_ESTIMATE_2011 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2011))
popdata$POP_ESTIMATE_2011 <-as.integer(popdata$POP_ESTIMATE_2011)


popdata$POP_ESTIMATE_2012 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2012))
popdata$POP_ESTIMATE_2013 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2013))
popdata$POP_ESTIMATE_2014 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2014))
popdata$POP_ESTIMATE_2015 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2015))
popdata$POP_ESTIMATE_2016 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2016))
popdata$POP_ESTIMATE_2017 <- as.numeric(gsub("," , "" , popdata$POP_ESTIMATE_2017))


popdata$GQ_ESTIMATES_2011 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2011))
popdata$GQ_ESTIMATES_2012 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2012))
popdata$GQ_ESTIMATES_2013 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2013))
popdata$GQ_ESTIMATES_2014 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2014))
popdata$GQ_ESTIMATES_2015 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2015))
popdata$GQ_ESTIMATES_2016 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2016))
popdata$GQ_ESTIMATES_2017 <- as.numeric(gsub("," , "" , popdata$GQ_ESTIMATES_2017))

popdata$Civilian_labor_force_2011 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2011))
popdata$Civilian_labor_force_2012 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2012))
popdata$Civilian_labor_force_2013 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2013))
popdata$Civilian_labor_force_2014 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2014))
popdata$Civilian_labor_force_2015 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2015))
popdata$Civilian_labor_force_2016 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2016))
popdata$Civilian_labor_force_2017 <-as.numeric(gsub("," , "" , popdata$Civilian_labor_force_2017))

popdata$Unemployed_2011 <- as.numeric(gsub("," , "" , popdata$Unemployed_2011))
popdata$Unemployed_2012 <- as.numeric(gsub("," , "" , popdata$Unemployed_2012))
popdata$Unemployed_2013 <- as.numeric(gsub("," , "" , popdata$Unemployed_2013))
popdata$Unemployed_2014 <- as.numeric(gsub("," , "" , popdata$Unemployed_2014))
popdata$Unemployed_2015 <- as.numeric(gsub("," , "" , popdata$Unemployed_2015))
popdata$Unemployed_2016 <- as.numeric(gsub("," , "" , popdata$Unemployed_2016))
popdata$Unemployed_2017 <- as.numeric(gsub("," , "" , popdata$Unemployed_2017))


popdata$Unemployment_rate_2011 <- as.numeric(popdata$Unemployment_rate_2011)
popdata$Unemployment_rate_2012 <- as.numeric(popdata$Unemployment_rate_2012)
popdata$Unemployment_rate_2013 <- as.numeric(popdata$Unemployment_rate_2013)
popdata$Unemployment_rate_2014 <- as.numeric(popdata$Unemployment_rate_2014)
popdata$Unemployment_rate_2015 <- as.numeric(popdata$Unemployment_rate_2015)
popdata$Unemployment_rate_2016 <- as.numeric(popdata$Unemployment_rate_2016)
popdata$Unemployment_rate_2017 <- as.numeric(popdata$Unemployment_rate_2017)

popdata$Area_Name <- as.character(popdata$Area_Name)

#popdata[,51:78] <- as.numeric(popdata[,51:78])
#write.csv(popdata, "F.csv", row.names = FALSE)

#pd <- read.csv("F.csv", stringsAsFactors = T)
popdata$Area_Name <- as.character(popdata$Area_Name)

write.csv(popdata, "pd.csv", row.names = F)