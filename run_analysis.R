# Getting and cleaning data class project
# Date:  20140622
# Assigment:
# You should create one R script called run_analysis.R that does the following:
#   -Merges the training and the test sets to create one data set.
#   -Extracts only the measurements on the mean and standard deviation for each measurement. 
#   -Uses descriptive activity names to name the activities in the data set
#   -Appropriately labels the data set with descriptive variable names. 
#   -Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# preliminaries
setwd("C:/Users/Bryan/Desktop/Coursera/Course 3 - clean")
dir()
rm(list=ls())
ls()


## -Merges the training and the test sets to create one data set.

# load training data
trainX<-read.table("X_train.txt")
str(trainX)
trainY<-read.table("y_train.txt")
str(trainY)
trainS<-read.table("subject_train.txt")
str(trainS)

# column bind training data and add indicator for training data
train<-cbind(trainS, trainY, trainX)
str(train)
head(train)

# load test data
testX<-read.table("X_test.txt")
str(testX)
testY<-read.table("y_test.txt")
str(testY)
testS<-read.table("subject_test.txt")
str(testS)

# column bind test data
test<-cbind(testS, testY, testX)
str(test)
head(test)

# row bind train and test sets
dim(train)
colnames(train)
dim(test)
colnames(test)

trainTest<-rbind(train, test)
dim(trainTest)
head(trainTest)
str(trainTest)



## -Extracts only the measurements on the mean and standard deviation for each measurement. 
## -Uses descriptive activity names to name the activities in the data set

dim(trainTest)
head(trainTest)
str(trainTest)
colnames(trainTest)

names(trainTest)[1]<-"subject"
names(trainTest)[2]<-"activity"

# load feature names...
features<-read.table("features.txt")
str(features)
head(features)

# ...and use as descriptive names
names(trainTest)[3:563]<-as.character(features[,2])
trainTest

# change activity number to label
activity<-read.table("activity_labels.txt")
str(activity)
head(activity)

colnames(activity)<-c("activity", "activity_desc")
head(activity)

str(activity)
str(trainTest)

trainTest2<-merge(activity, trainTest)
head(trainTest2)

# extract measurement columns with mean() and std() in names (note: very poorly worded qustions in this assignment!!)
(indexMeanStd<-sort(c(1:3, grep("mean()", colnames(trainTest2)), grep("std()", colnames(trainTest2)))))
(trainTest3<-trainTest2[,indexMeanStd])
dim(trainTest3)#10299, 82



## -Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
head(trainTest3)
str(trainTest3)

trainTest3Means<-aggregate(.~subject+activity, data=trainTest3, FUN=length, na.rm=TRUE)
head(trainTest3, 20)

trainTest3Means<-aggregate(.~subject+activity+activity_desc, data=trainTest3, FUN=mean, na.rm=TRUE)
head(trainTest3Means, 20)

trainTest4Means<-trainTest3Means[order(trainTest3Means$subject, trainTest3Means$activity),]
head(trainTest4Means, 20)
dim(trainTest4Means)

write.csv(trainTest4Means, "trainTest4Means.csv")



## Git bash code used to complete assignment

# mkdir getCleanDataProject
# cd getCleanDataProject
#touch README.md
#touch run_analysis.R <copy and paste in code>
#git init
#git add .
#git commit -m "first commit"
#git remote add origin https://github.com/wrightbr/getCleanDataProject.git
#git push -u origin master

