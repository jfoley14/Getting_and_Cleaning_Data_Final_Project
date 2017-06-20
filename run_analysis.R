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

# Group dat by subject and activity and find the averages of the feature 
# variables for each group
grouped_dat <- aggregate(dat[, c(1, 4:82)], list(dat$subject, dat$activity), 
                         mean)
grouped_dat <- select(grouped_dat, -subject)
colnames(grouped_dat)[1] <- "subject"
colnames(grouped_dat)[2] <- "activity"
grouped_dat <- arrange(grouped_dat, subject, activity)

# Update variable names to signify averages
colnames(grouped_dat)[3:81] <- sapply(colnames(grouped_dat)[3:81], 
                                   function(x) paste("avg_", x, sep = ""))

View(grouped_dat)

###############################################################################

###############################################################################

# Create a txt file containing the final data frame
write.table(grouped_dat, file = "final_data.txt", row.names = FALSE)

# Read the txt file back into R to better read the data frame
data <- read.table("final_data.txt", header = TRUE)

# View the data frame from the txt file
View(data)
