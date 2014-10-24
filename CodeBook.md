#Code Book for DataTidyingProject

This file should be read in conjunction with the 'README.md' file in the same GitHub repository.
It describes the contents of the tidied data file, 'tidiedData.txt', produced by the 
'run_analysis.R' script.

The data in this file was derived from raw data sourced from the UCI Machine Learning Repository, at 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. That data was
provided along with a file entitled 'features_info.txt' which formed a Code Book for their data. 
Basically the data consists of sensor reading taken from a mobile phone strapped to a person as they
performed various activities. It is recommended that the 'features_info.txt' file be consulted for
a fuller description of the source of each of these readings.

The contents of the 'tidiedData.txt' file should be interpreted as follows.

##Subject

The original experiments were performed by 30 subjects (people). To preserve anonymity these people 
are simply numbered rather than named,

##Activity

Each person performed six different activities whilst they were being monitored. 

##Remaining columns

The remaining column names were derived from those in the original 'features_info.txt' Code Book.
Certain columns were selected from that original data set (those columns including the word 'mean'
or 'std' anywhere within their feature name). The selected columns then had their names expanded 
according to the following rule set:

* any hyphens, commas and parentheses removed
* any occurrence of 'Acc' expanded out to 'Acceleration'
* any occurrence of 'Mag' expanded out to 'Magnitude'
* any occurrence of 'std' expanded out to 'StandardDeviation'
* any occurrence of 'freq' expanded out to 'Frequency'
* any prefix of 't' or 'f' expanded out to 'time' or 'frequency' respectively.
* any instances of 'mean' or 'gravity' converted to 'Mean' or 'Gravity' respectively.

These rules then created a set of feature names which were (arguably) more readable, and all in 
'camelCase' (see http://en.wikipedia.org/wiki/CamelCase).

The following extract is quoted directly from the 'features_info.txt' Code Book from UCI.

----

The features selected for this database come from the accelerometer and gyroscope 3-axial raw 
signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured 
at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass 
Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration 
signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) 
using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk 
signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals 
were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, 
tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, 
fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to 
indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag