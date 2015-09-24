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
    * Grow this documents while working along. - TODO
    * Do regular `git commit` - TODO
* Visit the reviewers checkpoints on Coursera - DONE
* Note them to Readme - TODO
    1. Has the student submitted a tidy data set?
        1. wide or long
        2. measurs to columns
        3. observations to rows
    2. Did the student submit a Github repo with the required scripts?
    3. Was code book submitted to GitHub?
        1. modifies and updates the codebooks available to you
        2. variables and summaries you calculated
        3. along with units, and any other relevant information
    4. README
        1. Explains what the analysis files did.
* Read the posting **A really long advice thread for the Project**
  by David Hood - DONE
    * Take notes to the Readme. - DONE
* Manually download the data  - DONE
* Read the datas Readme - DONE
* Inspect the files with command lines tools. How do they match together? - DONE
  * `head, tail`
  * `wc -l, wc -w`
* Describe the raw data within the Codebook - TODO
* Setup stubs `run_analysis.R` and `run_analysis_tests.R` (using Runit). - DONE

### Codebook

* The goals - TODO
* The raw data - DONE
* The processing steps - TODO
* The resulting data - TODO

### Coding and Testing Side by Side

* prepare - DONE
    * cleanup
    * setup directories
    * download data
    * unpack data
* inspect data - DONE
    * especially dimensions
* read data
* combine train and test data (1.)
* extract mean and standard deviations (2.)
* merge tables with activity labels to address (3.)
* add descriptive variable names (4.)
* do 5.
    * create independent tidy dataset
    * average of each variable from 4. per activity per subject

### Document

* Finalize the Codebook.
* Finalize the Readme.
* Finalize code comments.
* Anything else?
* Revisit the reviewers checkpoints in the Readme
    * Document in wich files to find the solutions to assist the reviewer.

### Finally

* Check exists: - TODO
    1. Readme.md
    2. codebook.md
    3. run_analysis.R
    4. tidy data text file

* Check everything marked as TODO - TODO
* Final push to Github - TODO
* Submit to Coursera - TODO

