# Intro

The overal goal is to take the raw data, group it by activities per
person, then to calculate avarages and standard deviations for each group.

To phrase this as a question:

If a person performs a certain action, what are the different calculated
means and standard deviations for the signals produced by this action?

This follows a divide and conquer approach. The raw data is parted into time
frames of equal lenght and different types a avarages and standard deviations
are already calculated for each frame of time. Each group result is the
mean of means and mean of standard deviations calculated within the raw data.

The original data is divided into two sets *train* and *test*. This have to
be merged into one before grouping.

# Content

    1. The raw data
    2. The processing
    3. The resulting data

# The raw data

## Overview

The input data is retrieved by tracking the movement profiles of
30 persons during differnt activities. Trackings are done by
use of Smartphones tied to the waists. The data is matched to
six types of activities.

Each row of the main data files contains one **measurement**, that is 128
signal values of type float. This are the tracked signals of a fixed frame of
time.

The 30 persons are split into two groups *Train* and *Test*
by a relation of 70% to 30% (21/9).

The raw signals finally processed into 561 features for both
groups in the same way.

For a details description see: `UCI HAR Dataset/README.txt`

## Signals processing

```
raw signals tAcc-XYZ and tGyro-XYZ
    -> [Butterworth filter]:
    -> tBodyAcc-XYZ and tGravityAcc-XYZ
    -> tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ + Magnitudes:
        * tBodyAccMag, tGravityAccMag, tBodyGyroMag
        * tBodyAccJerkMag, tBodyGyroJerkMag
    -> [Fast Fourier Transform (FFT)]:
        * fBodyAcc-XYZ, fBodyGyro-XYZ
        * fBodyAccJerk-XYZ
        * fBodyGyroMag
        * fBodyAccJerkMag, fBodyGyroJerkMag
```

## Files included in raw data

* `/`:
    * README.txt:
        contains: Overwview
        types: plain text
    * activity_labels.txt:
        contains: map of labels
        types: integer, charater
        dimensions: 6 * 2
    * features.txt:
        conatains: list of features
        types: integer, charater
        dimensions: 561 * 2
    * features_info.txt:
        contains: Description how the features have been calculated.
        types: plain text
* `train/`:
    * X_train.txt:
        contains: features
        types: float
        dimensions: 7352 * 561
    * subject_train.txt:
        contains: map to persons
        types: integer
        dimensions: 7352 * 1
    * y_train.txt:
        contains: map to activities
        types: integer - range 1:6
        dimensions: 7352 * 1
    * Inertial\ Signals/:
        contains: 9 files with measurements
        types: float
        dimensions: 7352 * 128
* `test/`:
    * X_test.txt:
        contains: features
        types: float
        dimensions: 2947 * 561
    * subject_test.txt:
        contains: map to persons
        types: integer
        dimensions: 2947 * 1
    * y_test.txt:
        contains: map to activities
        types: integer - range 1:6
        dimensions: 2947 * 1
    * Inertial\ Signals/:
        contains: 9 files with measurements
        types: float
        dimensions: 2947 * 128

# The processing

## Reading

Reading into dframes derived from the file names of the raw data:

* features_df from features.txt
* activity_labels_df from activity_labels.txt
* X_train_df from X_train.txt
* X_test_df from X_test.txt
* y_train_df from X_train.txt
* y_test_df from y_test.txt
* subject_train_df from subject_train.txt
* subject_test_df from subject_test.txt

## Combining the rows of test and train data

Reasoning:

    This is straight forward. It's not fully documented in the raw data
    docs, how everything matches, but the dimensions of the dataframes
    give the required hints. See above.

* subject_train_df + subject_test_df into persons
* y_train_df + y_test_df into activities
* X_train_df + X_test_df into features

## Combining the colums

persons + activitiesi + features into combined_df

## Setting column names

Reasoning:

    Finding descriptive variable names in features_df.

* person
* activity
* "tBodyAcc-mean()-X" ...  "angle(Z,gravityMean)"

Apart from *person* and *activity* the names are the function labels
from features_df. The correct order of the mapping is checked against
it's index in col 1.

## Setting activity labels

Reasoning:

    There are descriptive activity labels in activity_labels_df.

This are merged with combined_df to replace the integers.

## Tidy data

At this point we have tidy human readable data:

    1. All raw data is combined into one data frame.
    2. Names and labels are human readable.
    3. There is one row per observation.
    4. There is one column per variable.

## Extract

The task is to extract those colomns containing averages and standard
deviations.

Reasoning:

    The patterns to select these columns in an automated way
    by their columnn names are "mean(" and "std(".

# Calculate

The task it to calculate the mean of each variable for each activity and
each subject.

The data is grouped by person and activity. For each variable of a group
the mean is calculated.

Reasoning:

    The task doesn't require an order for the grouping, but it's a question
    in which order to sort the results.

    The tasks names the activity first. But if we would be interested in the
    means of activities, there would be no need to seperate them by persons.
    If they are grouped by persons, we want rather to know about the
    activities of a person. That's why I choose person as the primary criteria
    for ordering.

# The resulting data


