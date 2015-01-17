## Part 1: Merge the training and test data sets into one


# Go get the data set, store it to a working directory
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileURL, destfile = './data/projectdata.zip')

# unzip the files
unzip('./data/projectdata.zip')

# create data objects from the text files

# start with the training files, renaming columns to make sense

setwd("./data/UCI HAR Dataset")
x_train <- read.table('./train/X_train.txt')
subject_train <- read.table('./train/subject_train.txt')
colnames(subject_train)[1] <- "subject"

label_train <- read.table('./train/y_train.txt')
colnames(label_train)[1] <- "activity"

# now the test files

x_test <- read.table('./test/X_test.txt')

subject_test <- read.table('./test/subject_test.txt')
colnames(subject_test)[1] <- "subject"

label_test <- read.table('./test/y_test.txt')
colnames(label_test)[1] <- "activity"

# concatenate the train and test files

ttrain <- cbind(subject_train, label_train, x_train)
ttest <- cbind(subject_test, label_test, x_test)

# merge the files into one
dat <- rbind(ttrain, ttest)


## Part 2: Extract only the measurements on mean and standard deviation for each measurement


# create a vector of column means
average_value <- sapply(dat[3:563], mean) 

#create a vector of column sd
standard_deviation <- sapply(dat[3:563], sd) 

# combine them
aggstats <- cbind(average_value, standard_deviation) 


## Part 3: Use descriptive activity names to name the activities in the data set

# make sure of the column name for activities
names(dat[1:2])

dat$activity[which(dat$activity == 1)] <- 'Walking'
dat$activity[which(dat$activity == 2)] <- 'Walking upstairs'
dat$activity[which(dat$activity == 3)] <- 'Walking downstairs'
dat$activity[which(dat$activity == 4)] <- 'Sitting'
dat$activity[which(dat$activity == 5)] <- 'Standing'
dat$activity[which(dat$activity == 6)] <- 'Laying'


## Part 4: Appropriately labels the data set with descriptive names


# create column labels and remove the first unwanted column using NULL command
features <- read.table('features.txt')
features$V1 <- NULL

# Assign each row name from the 'features' data frame to the appropriate column in the 'dat' data frame
# Assign each row name from the 'features' data frame to the appropriate row in the 'aggstats' data frame

m <- 1
n <- m + 2

for(m in 1:561) {
        colnames(dat)[n] <- paste(features[m,])
        rownames(aggstats)[m] <- paste(features[m,])
        m = m + 1
        n = n + 1
}

## Part 5: Create a new tidy data set with the average of each variable for each activity and each subject

attach(dat)
dat <- aggregate(dat[, -c(1,2)], by = list(subject = subject, activity = activity), mean)
detach(dat)

#review a few records
head(dat)

# write the new tidy data file
write.table(dat, "tidydata4.txt", row.name=FALSE)