---
title: "CodeBook"
author: "John Foley"
date: "6/18/2017"
output: html_document
---

1. grouptype
    Group type: Are the averages for this row based on an activity or a subject?
    "activity" => Averages are based on an activity.
    "subject" => Averages are based on a subject.
   
2. subject
    Represents the subject that the average variables describe.
    * If grouptype == "activity" then subject is NA.
    1..30 => Unique subjects
   
3. activity
    Represents the activity that the average variables describe.
    * If grouptype == "subject" then activity is NA.
    Unique activities:
        "laying"
        "sitting"
        "standing"                 
        "walking"
        "walking downstairs"
        "walking upstairs"
  
4-82.
    These variables represent the averages of various measurements taken for
    each subject and each activity. Variables are either measured in time or
    frequency, depending on the "t" or "f" prefix in the variable names. Certain
    measurement averages are computed separately for measurements taken in the 
    x, y, and z directions. More information on the original measurements can be
    found in the "features_info.txt" file in the "UCI_HAR_Dataset" folder. Note 
    that only measurements of mean and standard deviation were averaged in this
    data set.
