  # GETTING AND CLEANING DATA COURSE PROJECT ####
  # Lisa Voss
  # Submitted June 18, 2017

  # Create one R script called run_analysis.R that does the following:
  # 1. Merges the training and the test sets to create one data set.
  # 2. Extracts only the measurements on the mean and standard deviation for 
  #    each measurement.
  # 3. Uses descriptive activity names to name the activities in the data set
  # 4. Appropriately labels the data set with descriptivariable names.
  # 5. From the data set in step 4, creates a second, independent tidy data set 
  #    with the average of each variable for each activity and each subject.
  
  # NOTE: all file paths are relative!

  #****************************************************************************
  # 0. Prepare the environment and download data  ####
  #****************************************************************************

  suppressMessages(library(dplyr))
  
  file.url <- 
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  if (!file.exists("C:./data")){
      download.file(file.url, destfile = "./HAR_Download.zip") 
      date.downloaded <- date(); print(date.downloaded)
      unzip("./HAR_Download.zip"); file.remove(dir(pattern=".zip"))
      file.rename(list.files(pattern="Dataset"), "data")
  }
  setwd("./data") 
  rm(file.url)
  
  #****************************************************************************
  # 1. Merge the training and the test sets to create one data set  ####
  #****************************************************************************
  
  # read activity data - activity id 1-6 for each measured observation
  activity.train <- read.table("./train/y_train.txt", col.names="activity.id")
  activity.test <- read.table("./test/y_test.txt", col.names="activity.id")
  activity.all <- bind_rows(activity.train, activity.test)  
  rm(activity.train, activity.test)
  
  
  # read subject data - volunteer id 1-30 for each measured observation
  subj.train <- read.table("./train/subject_train.txt", col.names="subject.id")
  subj.test <- read.table("./test/subject_test.txt", col.names="subject.id") 
  subject.all <- bind_rows(subj.train, subj.test) 
  rm(subj.train, subj.test)
  
  
  # read feature data - 10299 observations of 561 variables
  feature.train <- read.table("./train/X_train.txt")
  feature.test <- read.table("./test/X_test.txt")
  feature.all <- bind_rows(feature.train, feature.test)
  rm(feature.train, feature.test)
  
  
  # combine all dataframes into a single dataset
  data.all <- bind_cols(activity.all, subject.all, feature.all)
  rm(activity.all, subject.all, feature.all)
  
  #****************************************************************************
  # 2. Extract only the features with mean and standard deviation  ####
  #****************************************************************************
  
  feature.names <- read.table("./features.txt", stringsAsFactors = F)
  
  # add activity.name & subject.id to names list to match data.all dimensions
  names.all <- feature.names[, 2] %>% 
      c("activity.name", "subject.id", .)
  
  # see README for explanation of mean & std variable selection    
  index.mean.std <- grepl('\\bmean\\b|std|activity|subject', names.all)
  
  # select columns with mean & std deviation to create reduced dataset
  data.mean.std <- select(data.all, which(index.mean.std)) 
  rm(feature.names, data.all)
  
  #****************************************************************************
  # 3. Use descriptive activity names to name activities in the dataset  ####
  #****************************************************************************
  
  activity.key <- read.table("./activity_labels.txt",
                           col.names=c("activity.id", "activity.name"))
  activity.key[, "activity.name"] <- tolower(activity.key[, "activity.name"])
  
  # substitute activity names for activity ids in reduced dataset & remove ids
  data.mean.std <- data.mean.std  %>%
      mutate(activity.name = factor(activity.id, levels=1:6, 
                                    labels=activity.key[,2]))  %>% 
      select(-activity.id)  %>%   
      select(activity.name, subject.id, everything())
  rm(activity.key)
  
  #****************************************************************************
  # 4. Appropriately label the dataset with descriptive variable names  ####
  #****************************************************************************
  
  # see README.md for renaming convention explanation
  var.names.descriptive <- names.all[index.mean.std]
  var.names.descriptive <- var.names.descriptive %>%
      gsub("\\(|\\)", "", .) %>%
      gsub("\\-", ".", .) %>%
      gsub("(t)([A-Z])", "time.\\2", .) %>%
      gsub("(f)([A-Z])", "freq.\\2", .) %>%
      gsub("BodyBody", "Body", .) %>%
      gsub("([A-Za-z])([A-Z])([a-z])", "\\1.\\2\\3", .) %>%
      tolower
  names(data.mean.std) <- var.names.descriptive
  rm(names.all, index.mean.std, var.names.descriptive)
  
  #****************************************************************************
  # 5. Create tidy dataset with variable mean for each activity & subject  ####
  #****************************************************************************
  
  # create "wide" version of tidy dataset using reduced mean/std variable set  
  finaltidy <- data.mean.std %>%   
      group_by(activity.name, subject.id) %>%  
      summarize_each(funs(mean))  
  rm(data.mean.std)
  
  #****************************************************************************
  # OUTPUT: write the final tidy dataset to a text file  ####
  #****************************************************************************
  
  # relative path writes one level above data directory used in the script
  write.table(finaltidy, "../finaltidy.txt", row.names = FALSE)  
  setwd("..") # return working directory to its original location
  
  #****************************************************************************
  #****************************************************************************

