# Getting and Cleaning Data Coursera
Final project for Coursera Getting And Cleaning Data course

June 18, 2017

README created using https://jbt.github.io/markdown-editor 

## Project overview
### Purpose
The purpose of this project is to demonstrate the ability to collect, work with, and clean a dataset. 
Desired outcome is a tidy dataset that can be used for later analysis.

### Deliverables
There are four main deliverables for this project:
1. Tidy dataset as described below; the space-delimited output file in the GitHub repository is called "finaltidy.txt"; 
	_NOTE:_ Use "header = TRUE" when reading this file into R
2. Link to a Github repository with the R script for performing the analysis
3. Codebook called CodeBook.md describing the variables, data, and transformations performed to clean up the data (in the repository)
4. README.md in the repo with the R script

### R script requirements
The R script called run_analysis.R must do the following:
1. Merge the training and the test sets to create one dataset
2. Extract only the measurements on the mean and standard deviation for each measurement
3. Use descriptive activity names to name the activities in the dataset
4. Appropriately label the data set with descriptive variable names
5. From the data set in step 4, create a second, independent tidy dataset with the average of each variable for each activity and each subject


## Source data<sup>1</sup>
### Human activity recognition using smartphones dataset, version 1.0

Research overview is available at this site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Project data are obtained from this site:   
https://d396qusza40orc.cloudfront.net/getdata%2Fproject?les%2FUCI%20HAR%20Dataset.zip

A detailed description of the source data and variables used in this assignment can be found in "CodeBook.md"


## Explanation of R script steps
This section provides a _narrative_ description of the inputs, assumptions, tradeoffs, and transformation steps 
for each major segment of the R script. The code itself is in the separate script file "run_analysis.R".

### Overall assumptions and practices
- The definition of "tidy" used follows Wickham's<sup>2</sup> criteria, with output in the "wide" form of tidy:
  - Each variable forms a column
  - Each observation forms a row
  - Each type of observational unit forms a table
- All file paths used in script operations are relative; setwd() must be performed before running the script
- Instruction steps are taken as cumulative; all operations after step 2 are based on the reduced dataset of 
only variables with mean and standard deviation
- Google's R Style Guide<sup>3</sup> is the primary reference for formatting
- Interim variables are removed after use to minimize clutter in the working environment


### **0. Prepare the environment and download data**
	a) Load dplyr() as the only package needed for this script beyond base functionality
	
	b) If the directory named "data" does not already exist in the working directory, then:
		- download the dataset zip file into the current working directory
		- unzip the downloaded file and remove the original zip file
		- rename the folder "UCI HAR Dataset" to the simpler name "data"
		- change the working directory to the "data" folder to enable more concise commands later

_NOTE:_ Using the generic name "data" for the main file can be problematic if the chosen 
working directory already has another folder of that name; it is recommened to select or create 
a unique working directory before running this script


### **1. Merge the training and the test sets to create one dataset**
###### _INPUT_
	Training and test files for each variable set (activities, subjects, features); six (6) files total: 
	"y_train/test.txt", "subject_train/test.txt", "X_train/test.txt"

###### _PROCESS_ 

	Combine files first by variable set, then by observation. For each of the three variable sets:
    a) Read the training and test files and apply meaningful names as follows:
		- "activity.train/test" from "y_train/test"  [10299, 1]
		- "subj.train/test" from "subject_train/test"  [10299, 1]
		- "feature.train/test" from "X_train/test"  [10299, 561]
	
	b) Vertically connect by rows the training and test files for each variable set using dplyr command bind_rows
	
	c) Horizontally connect the three resulting data frames with bind_cols() into new data frame called "data.all"

_NOTE:_ Checks were peformed during code development to ensure all data frames have compatible dimensions; 
a more generic version of this script would include runtime checks and error messaging

###### _OUTPUT_ 
	Data frame with all variables and all observations: "data.all"  [10299, 563]


### **2. Extract only measurements with mean & standard deviation for each variable**
Key Assumption: Several features contain "mean" in the name in some form. For this task a narrow interpretation 
was used, where "mean" is strictly the simple mean of a set of signal measurements. 

Approach: Only those variables ending in "-mean()" were selected. Angle variables (e.g., "angle(X,gravityMean)") 
were excluded because they represent the _angle_ between mean signal vectors rather than the mean itself. 
In addition, meanFreq variables (e.g., "fBodyAccMag-meanFreq()") were excluded because those calculations are 
weighted averages rather than simple averages.

###### _INPUT_
	Text file of feature indices and names: "features.txt" [561, 2]

###### _PROCESS_ 
	a) Read "features.txt" into a data frame variable "feature.names" and ensure feature names are not 
	coerced into factors

	b) Add "activity.name" and "subject.id" to the vector of feature names to create a full list of 
	column names ("names.all") so length is equal to the column dimension of the full dataset ("data.all")

	c) Use grepl() on the list of names to identify the indices for -mean() and -var() features of interest; 
	this results in 66 feature variables plus "activity.name" and "subject.id", total = 68

	d) Use the vector of indices ("index.meand.std") to select relevant columns in the full measurement set and 
	form a new data frame called "data.mean.std" with only the mean and standard deviation features represented

###### _OUTPUT_ 
	Reduced data frame named "data.mean.std" [10299, 68]


### **3. Use descriptive activity names to name the activities in the dataset**
This section substitutes character activity names for the integer activity id's listed in the original dataset, 
using the dplyr functions "mutate" and "select".

###### _INPUT_
	Text file of id's and names for the six activites performed by research subjects: "activity_labels.txt" [6, 2]

###### _PROCESS_ 
	a) Read "activity_labels.txt" into a data frame variable "activity.key" [6, 2]

	b) Convert activity names from all-caps to lowercase in anticipation of the final output

	c) Use the dplyr function "mutate" to add an activity.name column to the (reduced) data frame "data.mean.std" 
	from the previous step, and populate the new column with the activity name corresponding to the activity id 
	for each row in "data.mean.std"

	d) Remove the now-unneeded "activity.id" column from the "data.mean.std" data frame

	e) By default, the new column "activity.name" was added as the last column in the data frame, 
	so the "select" function is used to reorder the columns to place "activity.name" in the first column, 
	"subject.id" in the second, and the (reduced) set of features following in their original order

###### _OUTPUT_ 
	Data frame "data.mean.std" [10299, 68] with English activity names in the first column instead of 
	integer id numbers


### **4. Appropriately label the dataset with descriptive variable names**
Key Assumption: The primary learning goal for this section is to demonstrate the ability to to rename 
column headings. The choice of what constitutes a "descriptive" name is left to the student. 

Approach: The script uses "gsub" and regular expressions to modify the original feature names as described below. 
For brevity, the script preserves common abbreviations such as "acc" for acceleration and "sd" for standard 
deviation, but those abbreviations can easily be be expanded if the need arises.

###### _INPUT_
	Two variables previously defined in Step 2: "names.all" and "index.mean.std", plus the working data frame 
	to be modified: "data.mean.std"

###### _PROCESS_ 
	Define a new variable "var.names.descriptive" that is a vector of mean and standard deviation variables 
	with modified names, then use this vector to rename the columns of the reduced dataset "data.mean.std"

	Specific text changes:
	a) Remove "()" to remove visual clutter
	b) Convert "-" to "." to follow Google's R Style Guide[4]
	c) Expand leading "t" to "time" and separate with "."
	d) Expand leading "f" to "freq" and separate with "."
	e) Shorten "BodyBody" to "Body" (NOTE: if a technical reason for the duplication, eliminate this step)
	f) Separate all other elements (e.g., "BodyAccJerk") with "." to follow Google[4]
	g) Convert everything to lowercase

###### _OUTPUT_ 
	Data frame "data.mean.std" with revised feature names in columns [, 3:68]


### **5. Create a separate, independent tidy dataset with the average of each variable for each activity and subject**
This section produces a "wide" version of the desired dataset. As explained by Hood<sup>4</sup>, both "wide" 
and "narrow" formats are acceptable for this assignment.

###### _INPUT_
	Updated data frame "data.mean.std" from Step 4

###### _PROCESS_ 
	a) Group the observations in "data.mean.std", first by "activity.name" and then by "subject.id"; this 
	produces 180 unique activity-subject pairs (6 activities x 30 subjects)

	b) Use dplyr function "summarize_each" to compute the mean of each feature for every activity-subject pair

_NOTE:_ The "summarize" function sorts data by the grouping variables (first alphabetical, then integer in this case), 
so the final activity-subject ordering does not match the ordering in the original dataset. This is acceptable since 
original order is not meaningful for this analysis.

###### _OUTPUT_ 
	Tidy dataset "finaltidy" [180, 68] in which every row is a unique activity-subject pair, and the 66 columns 
	after "activity.name" and "subject.id" are all features with "mean" and "std" in the name

&nbsp;
## References and license
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition
on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient 
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012. This dataset is distributed AS-IS and no 
responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. 
Any commercial use is prohibited. Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

[2] Wickham, H. (2014). Tidy Data. _Journal Of Statistical Software_, 59(10). http://dx.doi.org/10.18637/jss.v059.i10

[3] _Google's R Style Guide - Google Search_. (2017). _Goo.gl_. Retrieved 6 June 2017, from https://goo.gl/woDc4i

[4] Hood, D. _Getting and cleaning the assignment_ Retrieved 6 June 2017, from https://goo.gl/PWZPGs



