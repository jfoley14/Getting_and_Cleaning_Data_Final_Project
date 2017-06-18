setwd("/Users/JohnFoley/Desktop/Course_Project")

# Get training data
Xtrain <- read.table("UCI_HAR_Dataset/train/X_train.txt")
Ytrain <- read.table("UCI_HAR_Dataset/train/Y_train.txt")
Ytrain$group <- "train" # Create group column to signify training data
subject_train <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
train <- cbind(subject_train, Ytrain, Xtrain)

# Get testing data
Xtest <- read.table("UCI_HAR_Dataset/test/X_test.txt")
Ytest <- read.table("UCI_HAR_Dataset/test/Y_test.txt")
Ytest$group <- "test" # Create group column to signify testing data
subject_test <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
test <- cbind(subject_test, Ytest, Xtest)

# Get features
features <- read.table("UCI_HAR_Dataset/features.txt")
features <- as.character(features[,2])

# Combine training and testing data and change column names
dat <- rbind(train, test)
colnames(dat)[1] <- "subject"
colnames(dat)[2] <- "activity"
colnames(dat)[4:564] <- features

# Change activity values
dat[dat["activity"] == 1, ]$activity <- "walking"
dat[dat["activity"] == 2, ]$activity <- "walking upstairs"
dat[dat["activity"] == 3, ]$activity <- "walking downstairs"
dat[dat["activity"] == 4, ]$activity <- "sitting"
dat[dat["activity"] == 5, ]$activity <- "standing"
dat[dat["activity"] == 6, ]$activity <- "laying"

# Order rows of dat by subject
dat <- dat[order(dat[, "subject"]), ]

# Extract only measurements of mean and sd
dat <- cbind(subject = dat$subject, activity = dat$activity, group = dat$group, 
             dat[, grep("mean|std", colnames(dat))])

# Take out "()" from variable names
colnames(dat) <- sapply(colnames(dat), gsub, pattern = "()", replacement = "", 
                        fixed = TRUE)

# Switch "-" with "_" in variable names
colnames(dat) <- sapply(colnames(dat), gsub, pattern = "-", replacement = "_", 
                        fixed = TRUE)

# make all variable names lowercase
colnames(dat) <- sapply(colnames(dat), tolower)

library(dplyr)

# Group dat by activity and find average of each variable
dat_by_activity <- aggregate(dat[, c(2, 4:82)], list(dat$activity), 
                             mean) # Ignore warning messages
dat_by_activity <- select(dat_by_activity, -activity)
colnames(dat_by_activity)[1] <- "activity"
dat_by_activity <- cbind(grouptype = "activity", subject = NA, dat_by_activity)

# Group dat by subject and find average of each variable
dat_by_subject <- aggregate(dat[, c(1, 4:82)], list(dat$subject), mean)
dat_by_subject <- select(dat_by_subject, -subject)
colnames(dat_by_subject)[1] <- "subject"
dat_by_subject <- cbind(grouptype = "subject", subject = dat_by_subject[, 1], 
                        activity = NA, dat_by_subject[, 2:80])

# Combine dat_by_activity and dat_by_subject
dat_avgs <- rbind(dat_by_activity, dat_by_subject)

# Update variable names to signify averages
colnames(dat_avgs)[4:82] <- sapply(colnames(dat_avgs)[4:82], 
                                   function(x) paste("avg_", x, sep = ""))

###############################################################################

###############################################################################

# Create a txt file containing the final data frame
write.table(dat_avgs, file = "final_data.txt", row.names = FALSE)

# Read the txt file back into R to better read the data frame
data <- read.table("final_data.txt", header = TRUE)

# View the data frame from the txt file
View(data)
