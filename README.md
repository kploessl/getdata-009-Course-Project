"""
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
You will be graded by your peers on a series of yes/no questions related to the project. 
You will be required to submit: 
1) a tidy data set as described below
2) a link to a Github repository with your script for performing the analysis
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
   You should also include a README.md in the repo with your scripts. 
   This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article. 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S 
smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following: 
1) Merges the training and the test sets to create one data set
2) Extracts only the measurements on the mean and standard deviation for each measurement
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names 
5) From the data set in step 4, creates a second, independent tidy data set 
   with the average of each variable for each activity and each subject


EVALUATION:
Has the student submitted a tidy data set? 
Either a wide or a long form of the data is acceptable 
Tidy data principles:
- Each variable you measure should be in one column
- Each different observation of that variable should be in a different roW

Did the student submit a Github repo with the required scripts?

Was code book submitted to GitHub that modifies and updates the codebooks available 
to you with the data to indicate all the variables and summaries you calculated, 
along with units, and any other relevant information?

I was able to follow the README in the directory that explained what the analysis files did.

"""
# Read in Activity Labels to a data frame and name the columns
ActivityLabels <- read.table("./Data/UCI HAR Dataset/activity_labels.txt", sep="", header = FALSE)
colnames(ActivityLabels) <- c('ActivityID', 'ActivityName')
# head(ActivityLabels)

# Read in Features to a data frame
Features <- read.table("./Data/UCI HAR Dataset/features.txt", sep="", header = FALSE)
colnames(Features) <- c('id','FeatureName')
# head(Features)

# Read in X_test data to a data frame
# head(X_test)
# head(X_train)
X_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", sep="", header = FALSE)
X_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", sep="", header = FALSE)

# Assign column names to X_test data using the Features data
colnames(X_test) <- Features$FeatureName
colnames(X_train) <- Features$FeatureName

# Select only the measures for mean or stand deviation by filtering on columns with 'mean' or 'std'
library(dplyr)
X_test_mean_cols <- select(X_test,contains("mean()"))
X_test_std_cols <- select(X_test,contains("std()"))
X_test <- cbind(X_test_mean_cols,X_test_std_cols)

X_train_mean_cols <- select(X_train,contains("mean()"))
X_train_std_cols <- select(X_train,contains("std()"))
X_train <- cbind(X_train_mean_cols,X_train_std_cols)

# Read in subject_test.txt and subject_train.txt to data frames and name the columns
Test_SubjectID <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", sep="", header = FALSE)
colnames(Test_SubjectID) <- 'SubjectID'

Train_SubjectID <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt", sep="", header = FALSE)
colnames(Train_SubjectID) <- 'SubjectID'

# Add the SubjectID column to X_test and X_train
X_test$SubjectID <- Test_SubjectID$SubjectID
X_train$SubjectID <- Train_SubjectID$SubjectID

# Read in Activity Labels from y_test.txt and y_train.txt to data frames
# head(ActivityData)
Test_ActivityID <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", sep="", header = FALSE)
colnames(Test_ActivityID) <- 'ActivityID'

Train_ActivityID <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", sep="", header = FALSE)
colnames(Train_ActivityID) <- 'ActivityID'

# Make a new table by joining the ActivityID table with the ActivityLabels table
# head(ActivityData, n=40)
library(plyr)
Test_ActivityData <- join(Test_ActivityID,ActivityLabels)
Train_ActivityData <- join(Train_ActivityID,ActivityLabels)

# Combine X_test and X_train data with the corresponding ActivityID and ActivityName columns
X_test <- cbind(X_test, Test_ActivityData)
X_train <- cbind(X_train, Train_ActivityData)

# Combine X_test and X_train into one data frame
X_data <- rbind(X_test, X_train)

# Reshape the table using melt to make it easier to average each variable
library(reshape2)
X_data_melt <- melt(X_data, id=(c("SubjectID", "ActivityName", "ActivityID")))

# Get the mean of each variable by Subject and ActivityName
SummaryData <- dcast(X_data_melt, SubjectID + ActivityName ~ variable, mean)

# Write SummaryData to a text file for uploading
write.table(SummaryData, file = "./Data/UCI HAR Dataset/SummaryData.txt", row.names=FALSE)



