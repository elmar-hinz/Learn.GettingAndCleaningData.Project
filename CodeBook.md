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

    * Name: Person
    * Class: integer
    * Range: 1 - 30

[2] activity

    * Name: Activity
    * Class: factor
    * Level:
        * laying
        * sitting
        * standing
        * walking
        * walking_downstairs
        * walking_upstairs

[3] tds_body_acceleration_average_x

    * Name: Time Domain Signal Body Acceleration Average X
    * Class: numeric
    * Range: 0.22159824394 - 0.3014610196

[4] tds_body_acceleration_average_y

    * Name: Time Domain Signal Body Acceleration Average Y
    * Class: numeric
    * Range: -0.0405139534294 - -0.00130828765170213

[5] tds_body_acceleration_average_z

    * Name: Time Domain Signal Body Acceleration Average Z
    * Class: numeric
    * Range: -0.152513899520833 - -0.07537846886

[6] tds_body_acceleration_standard_deviation_x

    * Name: Time Domain Signal Body Acceleration Standard Deviation X
    * Class: numeric
    * Range: -0.996068635384615 - 0.626917070512821

[7] tds_body_acceleration_standard_deviation_y

    * Name: Time Domain Signal Body Acceleration Standard Deviation Y
    * Class: numeric
    * Range: -0.990240946666667 - 0.616937015333333

[8] tds_body_acceleration_standard_deviation_z

    * Name: Time Domain Signal Body Acceleration Standard Deviation Z
    * Class: numeric
    * Range: -0.987658662307692 - 0.609017879074074

[9] tds_gravity_acceleration_average_x

    * Name: Time Domain Signal Gravity Acceleration Average X
    * Class: numeric
    * Range: -0.680043155060241 - 0.974508732

[10] tds_gravity_acceleration_average_y

    * Name: Time Domain Signal Gravity Acceleration Average Y
    * Class: numeric
    * Range: -0.479894842941176 - 0.956593814210526

[11] tds_gravity_acceleration_average_z

    * Name: Time Domain Signal Gravity Acceleration Average Z
    * Class: numeric
    * Range: -0.49508872037037 - 0.9578730416

[12] tds_gravity_acceleration_standard_deviation_x

    * Name: Time Domain Signal Gravity Acceleration Standard Deviation X
    * Class: numeric
    * Range: -0.996764227384615 - -0.829554947808219

[13] tds_gravity_acceleration_standard_deviation_y

    * Name: Time Domain Signal Gravity Acceleration Standard Deviation Y
    * Class: numeric
    * Range: -0.99424764884058 - -0.643578361424658

[14] tds_gravity_acceleration_standard_deviation_z

    * Name: Time Domain Signal Gravity Acceleration Standard Deviation Z
    * Class: numeric
    * Range: -0.990957249538462 - -0.610161166287671

[15] tds_body_acceleration_jerk_average_x

    * Name: Time Domain Signal Body Acceleration Jerk Average X
    * Class: numeric
    * Range: 0.0426880986186441 - 0.130193043809524

[16] tds_body_acceleration_jerk_average_y

    * Name: Time Domain Signal Body Acceleration Jerk Average Y
    * Class: numeric
    * Range: -0.0386872111282051 - 0.056818586275

[17] tds_body_acceleration_jerk_average_z

    * Name: Time Domain Signal Body Acceleration Jerk Average Z
    * Class: numeric
    * Range: -0.0674583919268293 - 0.0380533591627451

[18] tds_body_acceleration_jerk_standard_deviation_x

    * Name: Time Domain Signal Body Acceleration Jerk Standard Deviation X
    * Class: numeric
    * Range: -0.994604542264151 - 0.544273037307692

[19] tds_body_acceleration_jerk_standard_deviation_y

    * Name: Time Domain Signal Body Acceleration Jerk Standard Deviation Y
    * Class: numeric
    * Range: -0.989513565652174 - 0.355306716915385

[20] tds_body_acceleration_jerk_standard_deviation_z

    * Name: Time Domain Signal Body Acceleration Jerk Standard Deviation Z
    * Class: numeric
    * Range: -0.993288313333333 - 0.0310157077775926

[21] tds_body_gyro_average_x

    * Name: Time Domain Signal Body Gyro Average X
    * Class: numeric
    * Range: -0.205775427307692 - 0.19270447595122

[22] tds_body_gyro_average_y

    * Name: Time Domain Signal Body Gyro Average Y
    * Class: numeric
    * Range: -0.204205356087805 - 0.0274707556666667

[23] tds_body_gyro_average_z

    * Name: Time Domain Signal Body Gyro Average Z
    * Class: numeric
    * Range: -0.0724546025804878 - 0.179102058245614

[24] tds_body_gyro_standard_deviation_x

    * Name: Time Domain Signal Body Gyro Standard Deviation X
    * Class: numeric
    * Range: -0.994276591304348 - 0.267657219333333

[25] tds_body_gyro_standard_deviation_y

    * Name: Time Domain Signal Body Gyro Standard Deviation Y
    * Class: numeric
    * Range: -0.994210471914894 - 0.476518714444444

[26] tds_body_gyro_standard_deviation_z

    * Name: Time Domain Signal Body Gyro Standard Deviation Z
    * Class: numeric
    * Range: -0.985538363333333 - 0.564875818162963

[27] tds_body_gyro_jerk_average_x

    * Name: Time Domain Signal Body Gyro Jerk Average X
    * Class: numeric
    * Range: -0.157212539189362 - -0.0220916265065217

[28] tds_body_gyro_jerk_average_y

    * Name: Time Domain Signal Body Gyro Jerk Average Y
    * Class: numeric
    * Range: -0.0768089915604167 - -0.0132022768074468

[29] tds_body_gyro_jerk_average_z

    * Name: Time Domain Signal Body Gyro Jerk Average Z
    * Class: numeric
    * Range: -0.0924998531372549 - -0.00694066389361702

[30] tds_body_gyro_jerk_standard_deviation_x

    * Name: Time Domain Signal Body Gyro Jerk Standard Deviation X
    * Class: numeric
    * Range: -0.99654254057971 - 0.179148649684615

[31] tds_body_gyro_jerk_standard_deviation_y

    * Name: Time Domain Signal Body Gyro Jerk Standard Deviation Y
    * Class: numeric
    * Range: -0.997081575652174 - 0.295945926186441

[32] tds_body_gyro_jerk_standard_deviation_z

    * Name: Time Domain Signal Body Gyro Jerk Standard Deviation Z
    * Class: numeric
    * Range: -0.995380794637681 - 0.193206498960417

[33] tds_body_acceleration_magnitude_average

    * Name: Time Domain Signal Body Acceleration Magnitude Average
    * Class: numeric
    * Range: -0.986493196666667 - 0.644604325128205

[34] tds_body_acceleration_magnitude_standard_deviation

    * Name: Time Domain Signal Body Acceleration Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.986464542615385 - 0.428405922622222

[35] tds_gravity_acceleration_magnitude_average

    * Name: Time Domain Signal Gravity Acceleration Magnitude Average
    * Class: numeric
    * Range: -0.986493196666667 - 0.644604325128205

[36] tds_gravity_acceleration_magnitude_standard_deviation

    * Name: Time Domain Signal Gravity Acceleration Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.986464542615385 - 0.428405922622222

[37] tds_body_acceleration_jerk_magnitude_average

    * Name: Time Domain Signal Body Acceleration Jerk Magnitude Average
    * Class: numeric
    * Range: -0.99281471515625 - 0.434490400974359

[38] tds_body_acceleration_jerk_magnitude_standard_deviation

    * Name: Time Domain Signal Body Acceleration Jerk Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.994646916811594 - 0.450612065720513

[39] tds_body_gyro_magnitude_average

    * Name: Time Domain Signal Body Gyro Magnitude Average
    * Class: numeric
    * Range: -0.980740846769231 - 0.418004608615385

[40] tds_body_gyro_magnitude_standard_deviation

    * Name: Time Domain Signal Body Gyro Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.981372675614035 - 0.299975979851852

[41] tds_body_gyro_jerk_magnitude_average

    * Name: Time Domain Signal Body Gyro Jerk Magnitude Average
    * Class: numeric
    * Range: -0.997322526811594 - 0.0875816618205128

[42] tds_body_gyro_jerk_magnitude_standard_deviation

    * Name: Time Domain Signal Body Gyro Jerk Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.997666071594203 - 0.250173204117966

[43] fft_body_acceleration_average_x

    * Name: Fast Fourrier Transformation Body Acceleration Average X
    * Class: numeric
    * Range: -0.995249932641509 - 0.537012022051282

[44] fft_body_acceleration_average_y

    * Name: Fast Fourrier Transformation Body Acceleration Average Y
    * Class: numeric
    * Range: -0.989034304057971 - 0.524187686888889

[45] fft_body_acceleration_average_z

    * Name: Fast Fourrier Transformation Body Acceleration Average Z
    * Class: numeric
    * Range: -0.989473926666667 - 0.280735952206667

[46] fft_body_acceleration_standard_deviation_x

    * Name: Fast Fourrier Transformation Body Acceleration Standard Deviation X
    * Class: numeric
    * Range: -0.996604570307692 - 0.658506543333333

[47] fft_body_acceleration_standard_deviation_y

    * Name: Fast Fourrier Transformation Body Acceleration Standard Deviation Y
    * Class: numeric
    * Range: -0.990680395362319 - 0.560191344

[48] fft_body_acceleration_standard_deviation_z

    * Name: Fast Fourrier Transformation Body Acceleration Standard Deviation Z
    * Class: numeric
    * Range: -0.987224804307692 - 0.687124163703704

[49] fft_body_acceleration_jerk_average_x

    * Name: Fast Fourrier Transformation Body Acceleration Jerk Average X
    * Class: numeric
    * Range: -0.994630797358491 - 0.474317256051282

[50] fft_body_acceleration_jerk_average_y

    * Name: Fast Fourrier Transformation Body Acceleration Jerk Average Y
    * Class: numeric
    * Range: -0.989398823913043 - 0.276716853307692

[51] fft_body_acceleration_jerk_average_z

    * Name: Fast Fourrier Transformation Body Acceleration Jerk Average Z
    * Class: numeric
    * Range: -0.992018447826087 - 0.157775692377778

[52] fft_body_acceleration_jerk_standard_deviation_x

    * Name: Fast Fourrier Transformation Body Acceleration Jerk Standard Deviation X
    * Class: numeric
    * Range: -0.995073759245283 - 0.476803887476923

[53] fft_body_acceleration_jerk_standard_deviation_y

    * Name: Fast Fourrier Transformation Body Acceleration Jerk Standard Deviation Y
    * Class: numeric
    * Range: -0.990468082753623 - 0.349771285415897

[54] fft_body_acceleration_jerk_standard_deviation_z

    * Name: Fast Fourrier Transformation Body Acceleration Jerk Standard Deviation Z
    * Class: numeric
    * Range: -0.993107759855072 - -0.00623647528983051

[55] fft_body_gyro_average_x

    * Name: Fast Fourrier Transformation Body Gyro Average X
    * Class: numeric
    * Range: -0.99312260884058 - 0.474962448333333

[56] fft_body_gyro_average_y

    * Name: Fast Fourrier Transformation Body Gyro Average Y
    * Class: numeric
    * Range: -0.994025488297872 - 0.328817010088889

[57] fft_body_gyro_average_z

    * Name: Fast Fourrier Transformation Body Gyro Average Z
    * Class: numeric
    * Range: -0.985957788 - 0.492414379822222

[58] fft_body_gyro_standard_deviation_x

    * Name: Fast Fourrier Transformation Body Gyro Standard Deviation X
    * Class: numeric
    * Range: -0.994652185217391 - 0.196613286661538

[59] fft_body_gyro_standard_deviation_y

    * Name: Fast Fourrier Transformation Body Gyro Standard Deviation Y
    * Class: numeric
    * Range: -0.994353086595745 - 0.646233637037037

[60] fft_body_gyro_standard_deviation_z

    * Name: Fast Fourrier Transformation Body Gyro Standard Deviation Z
    * Class: numeric
    * Range: -0.986725274871795 - 0.522454216314815

[61] fft_body_acceleration_magnitude_average

    * Name: Fast Fourrier Transformation Body Acceleration Magnitude Average
    * Class: numeric
    * Range: -0.986800645362319 - 0.586637550769231

[62] fft_body_acceleration_magnitude_standard_deviation

    * Name: Fast Fourrier Transformation Body Acceleration Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.987648484461539 - 0.178684580868889

[63] fft_body_body_acceleration_jerk_magnitude_average

    * Name: Fast Fourrier Transformation Body Body Acceleration Jerk Magnitude Average
    * Class: numeric
    * Range: -0.993998275797101 - 0.538404846128205

[64] fft_body_body_acceleration_jerk_magnitude_standard_deviation

    * Name: Fast Fourrier Transformation Body Body Acceleration Jerk Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.994366667681159 - 0.316346415348718

[65] fft_body_body_gyro_magnitude_average

    * Name: Fast Fourrier Transformation Body Body Gyro Magnitude Average
    * Class: numeric
    * Range: -0.986535242105263 - 0.203979764835897

[66] fft_body_body_gyro_magnitude_standard_deviation

    * Name: Fast Fourrier Transformation Body Body Gyro Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.981468841692308 - 0.236659662496296

[67] fft_body_body_gyro_jerk_magnitude_average

    * Name: Fast Fourrier Transformation Body Body Gyro Jerk Magnitude Average
    * Class: numeric
    * Range: -0.997617389275362 - 0.146618569064407

[68] fft_body_body_gyro_jerk_magnitude_standard_deviation

    * Name: Fast Fourrier Transformation Body Body Gyro Jerk Magnitude Standard Deviation
    * Class: numeric
    * Range: -0.99758523057971 - 0.287834616098305

