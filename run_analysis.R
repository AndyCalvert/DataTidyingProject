###################################################################################################################
# Getting and Cleaning Data, course project.
###################################################################################################################

library( dplyr )

# Pre-requisite - we have the files for analysis !
# This step could be performed manually, but has been scripted to ensure repeatability (for example, the 
# location of the stored file).
zipFileName <- "dataset.zip"
if ( !file.exists( zipFileName ))
{
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  # Being downloaded on a PC running Windows 8.1, so we don't need to specify the 'curl' method, 
  # but we do need to download the file as binary format to ensure no corruption of the zip file.
  download.file( fileUrl, destfile = zipFileName, mode="wb" )
}

# Unzip the file. If we specify overwrite to be FALSE then it will do no harm if run again.
unzip( zipFileName, overwrite = FALSE )

# Now, we should have one folder in our working directory, with a subfolder for training data and a 
# subfolderfor test data. Each of those subfolders in turn contains their own subfolders for inertia signals.
# Reading ahead through the steps we are told to take, we are going to throw away most data presented (in step 2), 
# including this inertia signal data .... so just ignore it and do not even try to merge it in step 1.

###################################################################################################################
# 1. Merge the training and test sets to create one data set.
###################################################################################################################

# First let's make a table of all the test data. Read and combine the three separate test data files.
testSubjectFileName <- "UCI HAR Dataset/test/subject_test.txt"
testXFileName <- "UCI HAR Dataset/test/X_test.txt"
testYFileName <- "UCI HAR Dataset/test/y_test.txt"

# Start with reading the subject identifiers.
testSubject <- read.table( testSubjectFileName )
# Then their activities.
testY <- read.table( testYFileName )
# and finish with the big table of details.
testX <- read.table( testXFileName )
# Combine them.
testData <- cbind( testX, testY )
testData <- cbind( testData, testSubject )

# Now repeat all that but for the training data. Read and combine the three separate training data files.
trainingSubjectFileName <- "UCI HAR Dataset/train/subject_train.txt"
trainingXFileName <- "UCI HAR Dataset/train/X_train.txt"
trainingYFileName <- "UCI HAR Dataset/train/y_train.txt"

# Start with reading the subject identifiers.
trainingSubject <- read.table( trainingSubjectFileName )
# Then their activities.
trainingY <- read.table( trainingYFileName )
# and finish with the big table of details.
trainingX <- read.table( trainingXFileName )
# Combine them.
trainingData <- cbind( trainingX, trainingY )
trainingData <- cbind( trainingData, trainingSubject )

# Now we are asked to merge the test and training data together.
data <- rbind( testData, trainingData )

# So now we have one big table with the feature columns, then the activity, then the subject identifier.


###################################################################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
###################################################################################################################

# The project requirements are unfortunately rather unclear on which measurements should actually be retained.
# The concensus on the forums appears to be to retain any column related to means or standard deviations.

# Start by reading in the list of features.
featureListFileName <- "UCI HAR Dataset/features.txt"
features <- read.table( featureListFileName )

# Find the features that include the word 'mean' or 'std'.
# Be careful ! Some of the names have capitals, others do not.
means <- grep( "mean", tolower( features$V2 ))
stds <- grep( "std", tolower( features$V2 ))
interestingColumns <- c( means, stds )

# and then make sure that we keep those two extra columns that we added.
lastColumn <- ncol(data)
interestingColumns <- c( interestingColumns,  lastColumn - 1, lastColumn )

filteredData <- data[, interestingColumns]

###################################################################################################################
# 3. Use descriptive activity names to name the activities in the data set.
###################################################################################################################

# CUrrently our second to last column contains the numeric indication of what activity a person
# was doing. We need to turn that into the respective textual description.

activityFileName <- "UCI HAR Dataset/activity_labels.txt"
activityLabels <- read.table( activityFileName )

# Now use that information to factor the activities.
filteredData$V1.1 <- factor( filteredData$V1.1, levels = activityLabels$V1, labels = activityLabels$V2 )

###################################################################################################################
# 4. Appropriately label the data with descriptive variable names.
###################################################################################################################

# Now we need to rename the columns.There are competing standards for variable naming, so I
# will stick with my preferance, camelCase (no underscrores or other punctuation, each new 
# word apart from the first has a capital letter).

featureNames <- as.character(features[interestingColumns,]$V2)

#   '-' anywhere  => removed
featureNames <- gsub( "-", "", featureNames )

#   ',' anywhere  => removed
featureNames <- gsub( ",", "", featureNames )

#   '()' anywhere => removed. Note that we have to escape the opening parenthesis.
featureNames <- gsub( "\\(", "", featureNames )
featureNames <- gsub( ")", "", featureNames )

#   Acc           => 'Acceleration'
featureNames <- gsub( "Acc", "Acceleration", featureNames, ignore.case = FALSE )

#   Mag           => 'Magnitude'
featureNames <- gsub( "Mag", "Magnitude", featureNames, ignore.case = FALSE )

#   gravity       => 'Gravity'
featureNames <- gsub( "gravity", "Gravity", featureNames, ignore.case = FALSE )

#   mean          => 'Mean'
featureNames <- gsub( "mean", "Mean", featureNames, ignore.case = FALSE )

#   std           => 'StandardDeviation'
featureNames <- gsub( "std", "StandardDeviation", featureNames, ignore.case = TRUE )

#   freq          => 'Frequency'
featureNames <- gsub( "freq", "Frequency", featureNames, ignore.case = TRUE )

#   t as a prefix => 'time'
featureNames <- gsub( "^t", "time", featureNames, ignore.case = FALSE )

#   f as a prefix => 'frequency'
featureNames <- gsub( "^f", "frequency", featureNames, ignore.case = FALSE )

lastColumn <- length( featureNames )
featureNames[lastColumn -1] <- "Activity"
featureNames[lastColumn] <- "Subject"

# Now apply these edited names back to the table.
names( filteredData ) <- featureNames

###################################################################################################################
#5. Create a second, independent tiday data set with the average of each variable for each activity and each subject.
###################################################################################################################

df <- as.tbl( filteredData)
grouped <- group_by( df, Subject, Activity )
tidied <- summarise_each( grouped, funs( mean ))
write.table( tidied, "tidiedData.txt", row.name=FALSE )
