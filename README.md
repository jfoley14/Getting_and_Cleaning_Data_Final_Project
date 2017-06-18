---
title: "README"
author: "John Foley"
date: "6/18/2017"
output: html_document
---

My run_analysis reads in the subject, y, and x data for both the testing and training data sets and binds them by column into two data frames (one for testing data and one for training data). It also creates a column in each table named "group" that signifies whether each record is part of the testing or training data. It then row binds the training and testing data frames into one overall dataframe named "dat". It names the subject variable "subject" and the activity variable "activity". The rest of the variables are named using the values from the features.txt file. Activity values are converted from numbers 1-6 to their corresponding activities in the activity_labels.txt file. The data frame is ordered by subject, variables not having to do with mean or sd are removed, and variable names are cleaned up (parentheses removed, "-" replaced with "_", and all letters changed to lowercase). Two separate dataframes are then created using dat: one in which dat is grouped by activity and one in which dat is grouped by subject. The averages of the feature variables are then found for these respective groups. These two tables are then binded by row into one final data frame named "dat_avgs". Finally, the feature variable names are changed to indicate that the values for these columns are averages.
