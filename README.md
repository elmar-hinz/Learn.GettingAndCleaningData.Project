# Coursera Getting and Cleaning Data Course Project

* Title: Course Project
* Copyright (c): 2015 Elmar Hinz
* Code license: **MIT**, see LICENSE.txt
* Original data license: see **Original Data License** below
* Coursera ID: getdata-032
* Project URL: https://class.coursera.org/getdata-032/human_grading

## Original Data License:

Use of this dataset in publications must be acknowledged by referencing the
following publication [1]

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
    Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a
    Multiclass Hardware-Friendly Support Vector Machine. International
    Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain.
    Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit
can be addressed to the authors or their institutions for its use or misuse.
Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita.
November 2012.

## Checklist to Assist Reviewers

Above each function within the code file you find a documentation. Within this
documentation I give the reasoning for my decisions for each of the required
steps. This comments are the central documentation.

Primarly have a look to the funtionc `Analyser()$main()` wich explains the
overall order of the processing.

To view the result data: `View(read.table("tidy_data.txt", header = T))`

1. Has the student submitted a tidy data set?
    1. wide or long?
        * See: https://github.com/elmar-hinz/Learn.GettingAndCleaningData.Project/blob/master/tidy_data.txt
    2. measures to columns
        * There is one measure per column.
    3. observations to rows
        * Each row contains the oberservation of an acitivity per user.
2. Did the student submit a Github repo with the required scripts?
    * https://github.com/elmar-hinz/Learn.GettingAndCleaningData.Project
    * https://github.com/elmar-hinz/Learn.GettingAndCleaningData.Project/blob/master/run_analysis.R
    * https://github.com/elmar-hinz/Learn.GettingAndCleaningData.Project/blob/master/run_analysis_test.R
3. Was code book submitted to GitHub?
    1. modifies and updates the codebooks available to you
        * https://github.com/elmar-hinz/Learn.GettingAndCleaningData.Project/blob/master/CodeBook.md
    2. variables and summaries you calculated
    3. along with units, and any other relevant information
4. README
    1. Explains what the analysis files did.
        * This file.

In addition to the code file you find a file with unit tests, to show the
code is working as promised. Run it like this:

```
    library(RUnit)
    runTestFile('run_analysis_test.R')
```

This 3 lines should be the end of the output, if everything works well:

```
    Number of test functions: 14
    Number of errors: 0
    Number of failures: 0
```

Warning: This may delete the file `tidy_data.txt` as the order of the
unit tests is not defined. To regenerate it you want to run:

```
    source("run_analysis.R"); Analyser()$main()
```

## Project Files

1. `README.md`: This file. Users guide.
2. `UciHarDataset.zip`: The raw data.
3. `CodeBook.md`: Describing the processing of the data.
4. `run_analysis.R`: The data processing script.
5. `run_analysis_test.R`: Unit tests for the previous script.
6. `LICENSE.txt`: MIT Licencense covering the code.
7. `tidy_data.txt`: The data output of this project.

## Given Project Instructions

Note: This text is slightly modified to improve readability.

The purpose of this project is to demonstrate your ability to collect, work
with, and clean a data set. The goal is to prepare tidy data that can be used
for later analysis. You will be graded by your peers on a series of yes/no
questions related to the project. You will be required to submit:

    1. a tidy data set as described below,
    2. a link to a Github repository with your script for performing the
       analysis, and
    3. a code book that describes the variables, the data, and any
       transformations or work that you performed to clean up the data
       called CodeBook.md.
    4. You should also include a README.md in the repo with your scripts. This
       repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable
computing - see for example this article . Companies like Fitbit, Nike, and
Jawbone Up are racing to develop the most advanced algorithms to attract new
users. The data linked to from the course website represent data collected
from the accelerometers from the Samsung Galaxy S smartphone. A full
description is available at the site where the data was obtained:

    * http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

    * https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called **run_analysis.R** that does the
following.

    1. Merges the training and the test sets to create one data set.
    2. Extracts **only** the measurements on the **mean** and
       **standard deviation** for each measurement.
    3. Uses descriptive activity names to name the activities in the data set.
    4. Appropriately labels the data set with descriptive variable names.
    5. From the data set in step 4, creates a **second**, independent tidy
       data set with the **average** of each variable for each activity and
       each subject.

## Summary of David Hoods Advices

Source: https://class.coursera.org/getdata-032/forum/thread?thread_id=26

* Check what the dimensions of the data is, for how they will fit together.
* When you give the variables descriptive names, explain why the names are
  descriptive.
* Commands:
    * dim()
    * rbind()
    * cbind()
    * write.table()
* Ignore the *inertial folder* first. Useful for to check later.
* Decide yourself what *means* to calculate, but explain your reasoning.
* Descriptive activity names things like "Walking" and "Walking Up". (see 3.)
* Descriptive variable names things like "V1" and "V2". (see 4.)
* Attention: Merging reorders data!
* Give the code for reading the file back into R.

```
     data <- read.table(file_path, header = TRUE)
     View(data)
 ```

* Either the wide or narrow form is tidy. Give reasoning!
    * Read Hadley Wickham's Tidy Data paper.
    * Look for thread about tidy data of David Hoods.
* Compare codebook in quiz 1
* Check result:
    * All subjects should have done all activities.
    * Has it got headings that make it clear which column is which?
    * Is it one column per variable?
    * Is it one row per observation?
    * Tidy data is not a certain number of rows and columns.
* Cite and link!
* Up load the set created in step 5 only.

## Plan / Protocol

### Prepare

* Read the given tasks - DONE
* Setup a Github repository with stubs for Readme,  License, Codebook - DONE
    * Grow this documents while working along. - DONE
    * Do regular `git commit` - DONE
* Visit the reviewers checkpoints on Coursera - DONE
    * Note them to Readme - DONE
    * Set hyperlinks for all points - DONE
* Read the posting **A really long advice thread for the Project**
  by David Hood - DONE
    * Take notes to the Readme. - DONE
* Manually download the data  - DONE
* Read the datas Readme - DONE
* Inspect the files with command lines tools. How do they match together? - DONE
  * `head, tail`
  * `wc -l, wc -w`
* Describe the raw data within the Codebook - DONE
* Setup stubs `run_analysis.R` and `run_analysis_tests.R` (using Runit). - DONE
* Add file overview to README. - DONE

### Codebook

* The goals - DONE
* The raw data - DONE
* The processing steps - DONE
* The resulting data - DONE

### Coding and Testing Side by Side

* prepare - DONE
    * cleanup
    * setup directories
    * download data
    * unpack data
* inspect data - DONE
    * especially dimensions
* read data - DONE
* combine train and test data (1.) - DONE
* extract mean and standard deviations (2.) - DONE
* merge tables with activity labels (3.) - DONE
* add descriptive variable names (4.) - DONE
* do 5. - DONE
    * create independent tidy dataset
    * average of each variable from 4. per activity per subject

### Document

* Finalize the Codebook. - DONE
* Finalize the Readme. - DONE
* Finalize code comments. - DONE
* Anything else? - DONE
* Revisit the reviewers checkpoints in the Readme - DONE
    * Document in wich files to find the solutions to assist the reviewer.

### Finally

* Check exists: - DONE
    1. Readme.md
    2. codebook.md
    3. run_analysis.R
    4. tidy data text file

* Check the checklist for reviewers links to all.
* Check everything marked as TODO - DONE
* Final push to Github - DONE
* Submit to Coursera - DONE

