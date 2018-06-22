
#Download the file and unzip the file

fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
tidyZIP <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
dirFile <- "./UCI HAR Dataset"

tidyFile <- "./tidy-UCI-HAR-dataset.txt"
tidytxt <- "./tidy-UCI-HAR-dataset-AVG.txt"
#If the data does not exist download the file
if (file.exists(tidyZIP) == FALSE) {
  download.file(fileURL, destfile = tidyZIP)
}
#Unzip the data file
if (file.exists(dirFile) == FALSE) {
  unzip(tidyZIP)
}

#1. Merges the training and the test sets to create one data set.

#Merge the data into  train and test of x,y,s
#Read the data set of train

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Read the data set of test

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Combine train and test of  X, Y, S emerge in to one data set

x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement:
#Read the features.txt from UCI HAR Dataset
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feat_id', 'feat_name')
#Get the mean and standard deviation value
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))

## 3. Uses descriptive activity names to name the activities in the data set:

#Read the activity lables from the activity_labels.txt
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
#Dislay activities
activities
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
y[,1] = activities[y[,1], 2]
names(y) <- c("activity")

## 4. Appropriately labels the data set with descriptive activity names:

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"
tidyDataSet <- cbind(s, y, x)
p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidy1 <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
names(tidy1)[1] <- "Subject"
names(tidy1)[2] <- "Activity"# Created csv (tidy data set) in diretory
write.table(tidy1, tidytxt)
write.table(tidyDataSet, tidyDataFile)
dim(tidyDataSet)
dim(tidy1)

