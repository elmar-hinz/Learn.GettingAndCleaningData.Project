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

