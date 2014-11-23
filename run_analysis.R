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



