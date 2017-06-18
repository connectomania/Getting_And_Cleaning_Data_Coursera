
# CodeBook: Coursera Getting and Cleaning Data
### Peer graded assignment: Course final project
Lisa Voss,  June 2017

CodeBook created using https://jbt.github.io/markdown-editor 

## Data collection overview<sup>1</sup>
_Content for this section is from the file "README.txt" in the original dataset package_

The experiments were carried out with a group of 30 volunteers, 19-48 years of age. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using the phone's embedded accelerometer and gyroscope, researchers captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, with 70% of the volunteers selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

### Components of each record
- Triaxial acceleration from the accelerometer (total acceleration) and estimated body acceleration
- Triaxial angular velocity from the gyroscope
- A 561-feature vector with time and frequency domain variables
- Activity label
- An identifier of the subject who carried out the experiment

### Files included in the source dataset package
- "README.txt"
- "features_info.txt": Shows information about the variables used on the feature vector
- "features.txt": Lists all features
- "activity_labels.txt": Links id labels with activity names
- "train/X_train.txt": Training set
- "train/y_train.txt": Training labels
- "test/X_test.txt": Test set
- "test/y_test.txt": Test labels
- "train/subject_train.txt": Each row identifies the subject who performed the activity for each window sample in the training set; the range is from 1 to 30
- "test/subject_test.txt": Each row identifies the subject who performed the activity for each window sample in the test set; the range is from 1 to 30

### Notes
- Features are normalized and bounded within [-1,1] (**and thus are dimensionless**)
- Each feature vector is a row on the text file
- The original dataset package also includes files with raw inertial signal readings; these files are not needed for this analysis, per the assignment guidance from Hood<sup>2</sup>
- For more information about the source dataset contact: activityrecognition@smartlab.ws


## Feature selection
_Content for this section is from the file "features_info.txt" in the original dataset package_

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag


The set of variables that were estimated from these signals are (_estimates selected in the R script are noted in_ **BOLD**): 

- **mean(): Mean value**
- **std(): Standard deviation**
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample are used on the angle() variable (_NOTE: not used in R script_):

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean


## Variables used in the R script
Table listing the name of each variable used in the script, its role in the script (input, interim, or output), and a brief description of the contents. Note the table is sorted alphabetically by feature name and does not reflect the order in which the variables appear in the R script.

| ITEM NAME | ROLE | DESCRIPTION
|:--- |:---: |:---|
activity.all | interim |  row combination of "activity.train" and "activity.test" | 
activity.key | input |  activity id and name for the 6 activities | 
activity.test | input |  activity code for each observation in test set | 
activity.train | input |  activity code for each observation in train set | 
data.all | interim |  column combination of "activity.all", "subject.all", "feature.all" | 
data.mean.std | interim |  reduced dataset with only "-mean()" and "-std()" features | 
feature.all | interim |  row combination of "feature.train" and "feature.test" | 
feature.names | input |  feature id and name for the 561 features | 
feature.test | input |  sensor readings for each feature in test set | 
feature.train | input |  sensor readings for each feature in train set | 
file.url | input |  file url to retrieve the source dataset | 
finaltidy | OUTPUT |  columns are the mean of all observations for every selected feature for each activity-subject pair | 
index.mean.std | interim |  logical vector indicating features with "-mean()" and "-std()"  | 
names.all | interim |  vector of all column headings before reduction | 
subj.test | input |  research subject id for each observation in test set | 
subj.train | input |  research subject id for each observation in train set | 
subject.all | interim |  row combination of "subj.train" and "subj.test" | 
var.names.descriptive | interim | renamed features used for final output | 

&nbsp;

For each variable, the table below gives the R data structure and a small sample of the data.

| ITEM NAME | TYPE | LENGTH | SIZE | VALUE | SAMPLE |
|:--- |:--- |:---:|---:|:--- |:--- |
activity.all | tbl_df | 1 | 41 KB | 10299 obs. of 1 var. | 5 5 5 5 5 ...| 
activity.key | data.frame | 2 | 1.2 KB | 6 obs. of 2 vars.  | "walking" "walking_upstairs" "walking_do ... | 
activity.test | data.frame | 1 | 12 KB | 2947 obs. of 1 var. | 5 5 5 5 5 ... | 
activity.train | data.frame | 1 | 29 KB | 7352 obs. of 1 var. | 5 5 5 5 5 ... | 
data.all | tbl_df | 563 | 44 MB | 10299 obs.  563 var. | 5 1 0.28858 -0.02029 -0.13291 ... | 
data.mean.std | tbl_df | 68 | 5.3 MB | 10299 obs. 68 vars. | "standing" 1 0.28858 -0.0202942 ... | 
feature.all | tbl_df | 561 | 44 MB | 10299 obs. 561 vars. | 0.28858 -0.02029 -0.13291 ...  | 
feature.names | data.frame | 2 | 41 KB | 561 obs. of 2 vars. | "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" ...  | 
feature.test | data.frame | 561 | 13 MB | 2947 obs. 561 vars. | 0.25718 -0.02329 -0.01465 ... | 
feature.train | data.frame | 561 | 32 MB | 7352 obs.  561 vars. | 0.28858 -0.02029 -0.13291 ...  | 
file.url | character | 1 | 216 B | url | https://d396qusza40orc.cloudfront.net/get ... | 
finaltidy | grouped_df | 68 | 105 KB | 180 obs. of 68 vars. | "walking" 1 0.27733 -0.01738 ... | 
index.mean.std | logical | 563 | 2.2 KB | logi [1:563]  | TRUE TRUE TRUE TRUE TRUE ... | 
names.all | character | 563 | 38 KB | chr [1:563]  | "activity.name"  "subject.id"  "tBodyAcc-mean()-X" .. | 
subj.test | data.frame | 1 | 12 KB | 2947 obs. of 1 var. | 2 2 2 2 2 ... | 
subj.train | data.frame | 1 | 29 KB | 7352 obs. of 1 var. | 1 1 1 1 1 ... | 
subject.all | tbl_df | 1 | 41 KB | 10299 obs. of 1 var. | 1 1 1 1 1 ... | 
var.names.descriptive | character | 68 | 5.3 KB | chr [1:68]  | "activity.name"  "subject.id"  "time.body.acc.mean.x" ...|

&nbsp;

Final list of variables after renaming:
- "activity.name"
- "subject.id"
- "time.body.acc.mean.x"
- "time.body.acc.mean.y"
- "time.body.acc.mean.z"
- "time.body.acc.std.x"
- "time.body.acc.std.y"
- "time.body.acc.std.z"
- "time.gravity.acc.mean.x"
- "time.gravity.acc.mean.y"
- "time.gravity.acc.mean.z"
- "time.gravity.acc.std.x"
- "time.gravity.acc.std.y"
- "time.gravity.acc.std.z"
- "time.body.acc.jerk.mean.x"
- "time.body.acc.jerk.mean.y"
- "time.body.acc.jerk.mean.z"
- "time.body.acc.jerk.std.x"
- "time.body.acc.jerk.std.y"
- "time.body.acc.jerk.std.z"
- "time.body.gyro.mean.x"
- "time.body.gyro.mean.y"
- "time.body.gyro.mean.z"
- "time.body.gyro.std.x"
- "time.body.gyro.std.y"
- "time.body.gyro.std.z"
- "time.body.gyro.jerk.mean.x"
- "time.body.gyro.jerk.mean.y"
- "time.body.gyro.jerk.mean.z"
- "time.body.gyro.jerk.std.x"
- "time.body.gyro.jerk.std.y"
- "time.body.gyro.jerk.std.z"
- "time.body.acc.mag.mean"
- "time.body.acc.mag.std"
- "time.gravity.acc.mag.mean"
- "time.gravity.acc.mag.std"
- "time.body.acc.jerk.mag.mean"
- "time.body.acc.jerk.mag.std"
- "time.body.gyro.mag.mean"
- "time.body.gyro.mag.std"
- "time.body.gyro.jerk.mag.mean"
- "time.body.gyro.jerk.mag.std"
-  "freq.body.acc.mean.x"
- "freq.body.acc.mean.y"
- "freq.body.acc.mean.z"
- "freq.body.acc.std.x"
- "freq.body.acc.std.y"
- "freq.body.acc.std.z"
- "freq.body.acc.jerk.mean.x"
- "freq.body.acc.jerk.mean.y"
- "freq.body.acc.jerk.mean.z"
- "freq.body.acc.jerk.std.x"
- "freq.body.acc.jerk.std.y"
- "freq.body.acc.jerk.std.z"
- "freq.body.gyro.mean.x"
- "freq.body.gyro.mean.y"
- "freq.body.gyro.mean.z"
- "freq.body.gyro.std.x"
- "freq.body.gyro.std.y"
- "freq.body.gyro.std.z"
- "freq.body.acc.mag.mean"
- "freq.body.acc.mag.std"
- "freq.body.acc.jerk.mag.mean"
- "freq.body.acc.jerk.mag.std"
- "freq.body.gyro.mag.mean"
- "freq.body.gyro.mag.std"
- "freq.body.gyro.jerk.mag.mean"
- "freq.body.gyro.jerk.mag.std"

&nbsp;
## References and license
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012. This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited. Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

[2] Hood, D. _Getting and cleaning the assignment_ Retrieved 6 June 2017, from https://goo.gl/PWZPGs
