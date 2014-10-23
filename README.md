#DataTidyingProject


The project related to the Coursera 'Getting and Cleaning Data' course.

## Introduction

This project consists of 3 elements:
* this file, README.md, describing how to use the script, and what the script actually does.
* CodeBook.md, which explains the meaning of the final tidied data output from the script.
* run_analysis.R, the actual R script that must be executed.


## The script

There is only a single R script required for this project. It performs the 5 steps itemised in the
project schedule, i.e.
1. Merge the given training and test data sets.
2. Extract only a subset of the measurements.
3. Apply descriptive names to the activities.
4. Apply descriptive variable names.
5. Produce a tidied subset of the data.

The script requires that the "dplyr" package has been installed.

The comments within the code describe in some detail the steps being performed. 

Prior to step 1 of the activities above, the script downloads and unzips the provided data sets. This 
step could have been done manually, but that could have resulted in problems caused by inconsistencies
in file naming, or storage location. By scripting these steps it should ensure repeatability.

Step 1 processing is straightforward. Each of the given data sets is first read in separately, and then
merged together to create a larger set.

Step 2 is slightly more controversial. We are tasked with extracting data relating to the mean and
standard deviation of features. So which features _exactly_ does that mean ? There are some features
that have those words at the end of their names, and other features that include them in the start or middle
of their name. I have chosen to retain all features that include 'mean' or 'std' anywhere within their
original feature name.

Step 3 processing is straightforward. Our data set has numerical indications of what activity each
person is doing during each observation. We are provided with a file containing the textual interpretations
of each of those numbers. The script therefore simply replaces the numerical with the textual.

Step 4 is again slightly contentious. The original feature names were defined in accordance with a 
code book provided to us. They were reasonably well defined (with some exceptions such as repeated names).
Those original feature names contained many abbreviations, such as 'freq'. Those abbreviations were generally
well known abbreviations (certainly in the physics world) and were also defined in the original code book.
My own personal opinion is that, therefore, they were perfectly adequate to retain. However, we are
given very clear guidance in the Coursera Forums that our expected action is to rename the features by
using regular expressions and replacement. Fine. There are many competing conventions for variable naming, and
as such I have stuck with my own personal preference, which is camelCase. This consists of each new word
starting with a capital letter, apart from the first word.

Step 5 uses the 'dplyr' package, as it substantially simplifies the coding. We group the data firstly by
the subject (person), and then by their activity ('walking' etc). We then create a summary of each grouping,
where the function used to create that summary is the 'mean'. This effectively shows the average value
for each activity for each person.

Finally, the tidied data set is written to a file.

In order to recover the tidied data from file, the best approach is to:
	data <- read.table(file_path, header = TRUE)
    View(data)
