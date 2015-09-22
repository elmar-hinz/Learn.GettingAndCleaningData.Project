# The input data overview

The input data is retrieved by measuring the movement profiles of
30 persons during differnt activities. Measurments are done by
use of Smartphones tied to the waists. The data is matched to
six types of activities.

Each row in the main data files contains 128 signal values,
the signals of a fixed frame of time within the measurement.

The 30 persons are split into two groups *Train* and *Test*
by a relation of 70% to 30% (21/9).

The raw data is finally processed into 561 features for both
groups in the same way.

For a details description see: `UCI HAR Dataset/README.txt`

# Files within the input data

* Top directory:
    * README.txt:
        Overwview
    * activity_labels.txt:
        List of 6 activety labels
    * features.txt:
        List of 561 calculated features
    * features_info.txt:
        Description how the features have been calculated.
* `train/`:
    * X_train.txt:
        Feature results, 561 numbers per line, 7352 lines
    * subject_train.txt:
        Maps measurements to person, 1 number per line, 2947 lines
    * y_train.txt:
        Maps measurements to activities (1 - 6), 2947 lines
* `test/`:
    * X_test.txt:
        Feature resuts, 561 numbers per line, 2947 lines
    * subject_test.txt:
        Maps measurements to person, 1 number per line, 2947 lines
    * y_test.txt:
        Maps measurements to activities (1 - 6), 1947 lines

```
raw signals tAcc-XYZ and tGyro-XYZ
    -> (Butterworth filter):
    -> tBodyAcc-XYZ and tGravityAcc-XYZ
    -> tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ + Magnitudes:
        * tBodyAccMag, tGravityAccMag, tBodyGyroMag
        * tBodyAccJerkMag, tBodyGyroJerkMag
    -> (Fast Fourier Transform (FFT)):
        * fBodyAcc-XYZ, fBodyGyro-XYZ
        * fBodyAccJerk-XYZ
        * fBodyGyroMag
        * fBodyAccJerkMag, fBodyGyroJerkMag
```

* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyAccJerkMag
* fBodyAccMag
* fBodyGyro-XYZ
* fBodyGyroJerkMag
* fBodyGyroMag
* tBodyAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyAccJerkMag
* tBodyAccMag
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyGyroJerkMag
* tBodyGyroMag
* tGravityAcc-XYZ
* tGravityAccMag


# Description

* The data is split into the directories `train` and  `tests`.
  matching participatiants groups *Train* and *Test*.
* Train group contains 70% of participationts.
* Test group contains 30% of participationts.
* The data in both directories is equally structured.
*






