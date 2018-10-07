#import data and convert to timeseries
setwd("D:/Project")
library(MASS)
library(tseries)
library(forecast)

pd<- read.csv("Aritry.csv", stringsAsFactors = T)

lnpop=(log(pd$Pop))
lnpop <- ts(lnpop)

ndiffs(pd$Pop)
#diffrences b/w each time series points. Dickey Fuller test is used for the same.
diffpd=(diff(lnpop))  #the DF p value (.0113/0.01) suggestes stationary data with rejection of null hypothesis.
diffpd
ndiffs(diffpd)
adf.test(lnpop) #by DF test p-value <.05 indicates that we reject the null hypothesis of non stationarity. 
adf.test(diffpd)
acf(pd$Pop, main="Auto Correlation Function")
pacf(diffpd, main="Partial Auto Correlation Function")
#TS and arima. Arima will choose the no: of diffrences automatically for computation. Hence the efforts of selection of auto regressors and moving averages is eliminated.
Poparima <- ts(lnpop, start = c(2011), frequency= 12)
fitpd <- auto.arima(Poparima)
fitpd
summary(fitpd)
plot(Poparima,type='l')
exp(lnpop)
#forecasted values from arima
forecastedvalues_ln=forecast(fitpd,h=12)
forecastedvalues_ln
plot(forecastedvalues_ln)

forecastedvaluesextracted=as.numeric(forecastedvalues_ln$mean)
finalforecastvalues=exp(forecastedvaluesextracted)
finalforecastvalues

#percentage error
df<-data.frame(pd$Pop,finalforecastvalues)
col_headings<-c("Actual Population","Forecasted Population")
names(df)<-col_headings

percentage_error=((df$`Actual Population`-df$`Forecasted Population`)/(df$`Actual Population`))
percentage_error

View(df)

