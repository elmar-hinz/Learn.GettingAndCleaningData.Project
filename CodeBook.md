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

[1] person
        person
        integer 1 - 3

[2] activity
        activity
        string
           * laying
           * sitting
           * standing
           * walking
           * walking_downstairs
           * walking_upstairs

[3] tds_body_acceleration_average_x
         tds body acceleration average x

[4] tds_body_acceleration_average_y
         tds body acceleration average y

[5] tds_body_acceleration_average_z
         tds body acceleration average z

[6] tds_body_acceleration_standard_deviation_x
         tds body acceleration standard deviation x

[7] tds_body_acceleration_standard_deviation_y
         tds body acceleration standard deviation y

[8] tds_body_acceleration_standard_deviation_z
         tds body acceleration standard deviation z

[9] tds_gravity_acceleration_average_x
         tds gravity acceleration average x

[10] tds_gravity_acceleration_average_y
         tds gravity acceleration average y

[11] tds_gravity_acceleration_average_z
         tds gravity acceleration average z

[12] tds_gravity_acceleration_standard_deviation_x
         tds gravity acceleration standard deviation x

[13] tds_gravity_acceleration_standard_deviation_y
         tds gravity acceleration standard deviation y

[14] tds_gravity_acceleration_standard_deviation_z
         tds gravity acceleration standard deviation z

[15] tds_body_acceleration_jerk_average_x
         tds body acceleration jerk average x

[16] tds_body_acceleration_jerk_average_y
         tds body acceleration jerk average y

[17] tds_body_acceleration_jerk_average_z
         tds body acceleration jerk average z

[18] tds_body_acceleration_jerk_standard_deviation_x
         tds body acceleration jerk standard deviation x

[19] tds_body_acceleration_jerk_standard_deviation_y
         tds body acceleration jerk standard deviation y

[20] tds_body_acceleration_jerk_standard_deviation_z
         tds body acceleration jerk standard deviation z

[21] tds_body_gyro_average_x
         tds body gyro average x

[22] tds_body_gyro_average_y
         tds body gyro average y

[23] tds_body_gyro_average_z
         tds body gyro average z

[24] tds_body_gyro_standard_deviation_x
         tds body gyro standard deviation x

[25] tds_body_gyro_standard_deviation_y
         tds body gyro standard deviation y

[26] tds_body_gyro_standard_deviation_z
         tds body gyro standard deviation z

[27] tds_body_gyro_jerk_average_x
         tds body gyro jerk average x

[28] tds_body_gyro_jerk_average_y
         tds body gyro jerk average y

[29] tds_body_gyro_jerk_average_z
         tds body gyro jerk average z

[30] tds_body_gyro_jerk_standard_deviation_x
         tds body gyro jerk standard deviation x

[31] tds_body_gyro_jerk_standard_deviation_y
         tds body gyro jerk standard deviation y

[32] tds_body_gyro_jerk_standard_deviation_z
         tds body gyro jerk standard deviation z

[33] tds_body_acceleration_magnitude_average
         tds body acceleration magnitude average

[34] tds_body_acceleration_magnitude_standard_deviation
         tds body acceleration magnitude standard deviation

[35] tds_gravity_acceleration_magnitude_average
         tds gravity acceleration magnitude average

[36] tds_gravity_acceleration_magnitude_standard_deviation
         tds gravity acceleration magnitude standard deviation

[37] tds_body_acceleration_jerk_magnitude_average
         tds body acceleration jerk magnitude average

[38] tds_body_acceleration_jerk_magnitude_standard_deviation
         tds body acceleration jerk magnitude standard deviation

[39] tds_body_gyro_magnitude_average
         tds body gyro magnitude average

[40] tds_body_gyro_magnitude_standard_deviation
         tds body gyro magnitude standard deviation

[41] tds_body_gyro_jerk_magnitude_average
         tds body gyro jerk magnitude average

[42] tds_body_gyro_jerk_magnitude_standard_deviation
         tds body gyro jerk magnitude standard deviation

[43] fft_body_acceleration_average_x
         fft body acceleration average x

[44] fft_body_acceleration_average_y
         fft body acceleration average y

[45] fft_body_acceleration_average_z
         fft body acceleration average z

[46] fft_body_acceleration_standard_deviation_x
         fft body acceleration standard deviation x

[47] fft_body_acceleration_standard_deviation_y
         fft body acceleration standard deviation y

[48] fft_body_acceleration_standard_deviation_z
         fft body acceleration standard deviation z

[49] fft_body_acceleration_jerk_average_x
         fft body acceleration jerk average x

[50] fft_body_acceleration_jerk_average_y
         fft body acceleration jerk average y

[51] fft_body_acceleration_jerk_average_z
         fft body acceleration jerk average z

[52] fft_body_acceleration_jerk_standard_deviation_x
         fft body acceleration jerk standard deviation x

[53] fft_body_acceleration_jerk_standard_deviation_y
         fft body acceleration jerk standard deviation y

[54] fft_body_acceleration_jerk_standard_deviation_z
         fft body acceleration jerk standard deviation z

[55] fft_body_gyro_average_x
         fft body gyro average x

[56] fft_body_gyro_average_y
         fft body gyro average y

[57] fft_body_gyro_average_z
         fft body gyro average z

[58] fft_body_gyro_standard_deviation_x
         fft body gyro standard deviation x

[59] fft_body_gyro_standard_deviation_y
         fft body gyro standard deviation y

[60] fft_body_gyro_standard_deviation_z
         fft body gyro standard deviation z

[61] fft_body_acceleration_magnitude_average
         fft body acceleration magnitude average

[62] fft_body_acceleration_magnitude_standard_deviation
         fft body acceleration magnitude standard deviation

[63] fft_body_body_acceleration_jerk_magnitude_average
         fft body body acceleration jerk magnitude average

[64] fft_body_body_acceleration_jerk_magnitude_standard_deviation
         fft body body acceleration jerk magnitude standard deviation

[65] fft_body_body_gyro_magnitude_average
         fft body body gyro magnitude average

[66] fft_body_body_gyro_magnitude_standard_deviation
         fft body body gyro magnitude standard deviation

[67] fft_body_body_gyro_jerk_magnitude_average
         fft body body gyro jerk magnitude average

[68] fft_body_body_gyro_jerk_magnitude_standard_deviation
         fft_body_body_gyro_jerk_magnitude_standard_deviation

