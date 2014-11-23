#Assignment Details
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
You will be graded by your peers on a series of yes/no questions related to the project. 

You will be required to submit: 
1) a tidy data set as described below
2) a link to a Github repository with your script for performing the analysis
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
   You should also include a README.md in the repo with your scripts. 
   This repo explains how all of the scripts work and how they are connected.  

Here are the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following: 
1) Merges the training and the test sets to create one data set
2) Extracts only the measurements on the mean and standard deviation for each measurement
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names 
5) From the data set in step 4, creates a second, independent tidy data set 
   with the average of each variable for each activity and each subject

#My Approach
## Step 1: Read Activity Labels and Features metadata shared by both test and train data
- Read in Activity Labels to a data frame and name the columns
- Read in Features to a data frame

## Step 2: Read test and train data and apply column names
- Read in test and train data to data frames
- Assign column names to test and train data using the Features data

## Step 3: Create a subset of each data frame with mean and std variables only
- Select only the measures for mean or stand deviation by filtering on columns with 'mean' or 'std' using dplyr

## Step 4: Bind SubjectID data to data sets
- Read in subject_test.txt and subject_train.txt to data frames and name the columns
- Add the SubjectID column to X_test and X_train

## Step 5: Bind Activity labels to data sets
- Read in Activity Labels from y_test.txt and y_train.txt to data frames
- Make a new table by joining the ActivityID table with the ActivityLabels table using the join functionality in plyr
- Combine X_test and X_train data with the corresponding ActivityID and ActivityName columns

## Step 6: Combine test and train data
- Combine X_test and X_train into one data frame

## Step 7: Summarize data
- Reshape the table using melt to make it easier to average each variable
- Get the mean of each variable by Subject and ActivityName

## Step 8: Write summary to a text file
- Write SummaryData to a text file for uploading


