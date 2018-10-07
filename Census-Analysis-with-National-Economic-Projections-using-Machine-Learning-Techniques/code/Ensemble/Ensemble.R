setwd("G:/MSc/Sem2/ADM/data.gov/ADM Project")
pd <- read.csv("pd.csv")

library(randomForest)
kpd <- pd
table(kpd$Unemployment_rate_2017)
kpd$Unemployment_rate_2017 <- cut(kpd$Unemployment_rate_2017, breaks=c(1.6,3.5,4.5,5.5,9.5,20.2), labels=c(1,2,3,4,5))
sapply(kpd,function(x) sum(is.na(x)))
kpd <- na.omit(kpd)
kpd$Area_Name <- as.character(kpd$Area_Name)

#RF
library(caTools)
set.seed(123)
split = sample.split(kpd$Unemployment_rate_2017, SplitRatio = 0.75)
train = subset(kpd, split == TRUE)
test = subset(kpd, split == FALSE)
train <- train[,-1]
test <- test[,-1]
sapply(train,function(x) sum(is.na(x)))
sapply(test,function(x) sum(is.na(x)))
train <- subset(train, select = c(5:7, 40:42, 55:63))
test <- subset(test, select = c(5:7, 40:42, 55:63))

table(train$Unemployment_rate_2017)
forest <- randomForest(x = train[-15],y = train$Unemployment_rate_2017, importance = TRUE,ntree=500)
varImpPlotData <- varImpPlot(forest)  
varImpPlot(forest)
rf <- predict(forest, newdata = test, type = "class")
plot(rf, main = "Class distribution", xlab = "Classes", ylab = "Frequency")
#cm= table(test[,15], rf)
#cm
library(caret)
confusionMatrix(rf, test$Unemployment_rate_2017)

#Mean decrease accuracy variables
meanDecAcc <- varImpPlotData[, 1]
# Most important variables first
meanDecAcc <- meanDecAcc[order(-meanDecAcc)]
#Vector of Numbers
a <- c(1:length(meanDecAcc))
#a
# derive those that are odd
a <- a %% 2 == 1
# get the odd colNames
knnFeatures <- names(meanDecAcc[a])
knnFeatures

train[-15] = as.data.frame(scale(train[-15]))
test[-15] = as.data.frame(scale(test[-15]))

library(class)
#library(dplyr)
tuneParams <- trainControl(method = "cv",number = 10,savePredictions = 'final')
knn <- train(train[,knnFeatures],train$Unemployment_rate_2017,method='knn',trControl=tuneParams,tuneLength=10)

knn.pred <- predict(knn, newdata = test[,knnFeatures])
#knn_pred = knn(train = train[, knnFeatures] ,test = test[, knnFeatures], cl = train[, 15], k = 3, prob = TRUE)

confusionMatrix(knn.pred, test$Unemployment_rate_2017)

split = sample.split(kpd$Unemployment_rate_2017, SplitRatio = 0.75)
train = subset(kpd, split == TRUE)
test = subset(kpd, split == FALSE)
train <- train[,-1]
test <- test[,-1]
#sapply(train,function(x) sum(is.na(x)))
#sapply(test,function(x) sum(is.na(x)))
train <- subset(train, select = c(5:7, 40:42, 55:63))
test <- subset(test, select = c(5:7, 40:42, 55:63))

library(C50)
c50Features <- names(meanDecAcc[!a])
c50Features

c50Tree <- train(train[,c50Features], train$Unemployment_rate_2017, method="C5.0", trControl=tuneParams, tuneLength=3)
c50.pred <- predict(c50Tree, newdata = test[,c50Features])
confusionMatrix(c50.pred, test$Unemployment_rate_2017)
#Accuracy- 85.57

#Gini Variables
meanDecGini <- varImpPlotData[, 2]
meanDecGini <- meanDecGini[order(-meanDecGini)]
b <- c(1:length(meanDecGini))
b <- b %% 2 == 1
cartFeatures <- names(meanDecGini[b])
cartFeatures

Tree <- train(train[,cartFeatures], train$Unemployment_rate_2017, method="rpart", trControl=tuneParams, tuneLength=3)
rpart.pred <- predict(Tree, newdata = test[,cartFeatures])
confusionMatrix(rpart.pred, test$Unemployment_rate_2017)

#Averaging
test$rpart_prob <- predict(object = Tree, test[, cartFeatures], type = 'prob')
test$c50_prob <- predict(object = c50Tree, test[,c50Features], type = 'prob')
test$knn_prob <- predict(object = knn, test[,knnFeatures], type = 'prob')

test$avg_pred <- (test$rpart_prob+test$c50_prob+test$knn_prob)/3
#summary(test$avg_pred)
test$preds <- apply(test$avg_pred, 1, FUN=function(x) {which.max(x)})
table(test$preds)
test$preds <- factor(test$preds, levels=c(1:5), labels=c(1:5))

#test$preds
confusionMatrix(test$Unemployment_rate_2017, test$preds)
# Accuracy 83.81

#Stacking
#knn$pred
train$pred_knn<-factor(knn$pred$pred[order(knn$pred$rowIndex)])
train$pred_c50<-factor(c50Tree$pred$pred[order(c50Tree$pred$rowIndex)])
train$pred_cart<-factor(Tree$pred$pred[order(Tree$pred$rowIndex)])
predictors <- c("pred_knn", "pred_c50", "pred_cart")
library(gbm)
gbm <- train(train[, predictors],train$Unemployment_rate_2017,method='gbm',trControl=tuneParams,tuneLength=3)

test$pred_knn <- factor(knn.pred)
test$pred_c50 <- factor(c50.pred)
test$pred_cart <- factor(rpart.pred)

gbm.pred <- predict(gbm, test[, predictors])
confusionMatrix(test$Unemployment_rate_2017, gbm.pred)
#85.19

#Individual model implementation
kpd <- pd
table(kpd$Unemployment_rate_2017)
kpd$Unemployment_rate_2017 <- cut(kpd$Unemployment_rate_2017, breaks=c(1.6,3.5,4.5,5.5,9.5,20.2), labels=c(1,2,3,4,5))
sapply(kpd,function(x) sum(is.na(x)))
kpd <- na.omit(kpd)
kpd$Area_Name <- as.character(kpd$Area_Name)
library(caret)
library(caTools)
split = sample.split(kpd$Unemployment_rate_2017, SplitRatio = 0.75)
train = subset(kpd, split == TRUE)
test = subset(kpd, split == FALSE)
train <- train[,-1]
test <- test[,-1]
sapply(train,function(x) sum(is.na(x)))
sapply(test,function(x) sum(is.na(x)))
train <- subset(train, select = c(5:7, 40:42, 55:63))
test <- subset(test, select = c(5:7, 40:42, 55:63))

#C5.0
library(C50)
c50Tree <- train(train[,-15], train$Unemployment_rate_2017, method="C5.0", trControl=tuneParams, tuneLength=3)

c50.pred <- predict(c50Tree, newdata = test[,-15])
confusionMatrix(c50.pred, test$Unemployment_rate_2017)

#rpart
Tree <- train(train[,-15], train$Unemployment_rate_2017, method="rpart", trControl=tuneParams, tuneLength=3)
rpart_pred <- predict(Tree, newdata = test[,-15])
confusionMatrix(rpart_pred, test$Unemployment_rate_2017)

#KNN
train[-15] = as.data.frame(scale(train[-15]))
test[-15] = as.data.frame(scale(test[-15]))

knn <- train(train[,-15],train$Unemployment_rate_2017,method='knn',trControl=tuneParams,tuneLength=10)
knn.pred <- predict(knn, newdata = test[,-15])
confusionMatrix(knn.pred, test$Unemployment_rate_2017)


