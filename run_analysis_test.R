##################################################
# Source the file to test
##################################################
source("run_analysis.R")

silent <- T

##################################################
# Setup the analyser object with a useful
# default configuration
#
# @return NULL
##
.setUp <- function() {
    fullrun <<- FALSE
    download_from_local <<- TRUE
    analyser <<- Analyser()
    NULL
}

##################################################
# Helper functions to ensure everything
# is set up for to do analysis.
#
# @return NULL
##
prepare <- function() {
    analyser$setup()
    analyser$download()
    analyser$unpack()
    NULL
}

test.configuration <- function() {
    checkTrue(is.logical(c(fullrun, download_from_local, do_inspect)))
    checkTrue(is.character(c(
        localurl, remoteurl,
        unpackdir, datadir, rawdir, zipfile, traindir, testdir,
        X_train_file, X_test_file
    )))
    checkTrue(is.numeric(nr_inspect))
}

test.constructor <- function() {
    checkTrue(is.function(analyser$main))
}

test.setup_and_clean <- function() {
    # cleanup roundtrip on fullrun
    fullrun <<- TRUE
    out <- analyser$clean()
    checkTrue(is.null(out))
    checkTrue(!dir.exists(datadir))
    checkTrue(!dir.exists(unpackdir))
    out <- analyser$setup()
    checkTrue(is.null(out))
    checkTrue(dir.exists(datadir))
    checkTrue(dir.exists(unpackdir))
    analyser$clean()
    checkTrue(!dir.exists(datadir))
    checkTrue(!dir.exists(unpackdir))
    # when not fullrun setup keeps working but cleanup is skipped
    fullrun <<- FALSE
    analyser$setup()
    analyser$clean()
    checkTrue(dir.exists(datadir))
    checkTrue(dir.exists(unpackdir))
}

test.download <- function() {
    analyser$setup()
    if(file.exists(zipfile)) file.remove(zipfile)
    checkTrue(!file.exists(zipfile))
    out <- analyser$download()
    checkTrue(is.null(out))
    checkTrue(file.exists(zipfile))
}

test.unpack <- function() {
    if(file.exists(rawdir)) unlink(rawdir, recursive = T)
    checkTrue(!file.exists(rawdir))
    analyser$setup()
    analyser$download()
    out <- analyser$unpack()
    checkTrue(is.null(out))
    checkTrue(file.exists(rawdir))
}

test.inspect <- function() {
    prepare()
    # Just run to prove nothing breaks
    # The output is directly to std out
    out <- analyser$inspect()
    checkTrue(is.null(out))
}

test.read <- function() {
    prepare()
    out <- analyser$read()
    checkTrue(is.null(out))
    checkTrue(is.data.frame(features_df))
    checkEquals(561, nrow(features_df))
    checkEquals(2, ncol(features_df))
    checkTrue(is.data.frame(activity_labels_df))
    checkEquals(6, nrow(activity_labels_df))
    checkEquals(2, ncol(activity_labels_df))
    checkTrue(is.data.frame(X_train_df))
    checkEquals(7352, nrow(X_train_df))
    checkEquals(561, ncol(X_train_df))
    checkTrue(is.data.frame(y_train_df))
    checkEquals(7352, nrow(y_train_df))
    checkEquals(1, ncol(y_train_df))
    checkTrue(is.data.frame(subject_train_df))
    checkEquals(7352, nrow(subject_train_df))
    checkEquals(1, ncol(subject_train_df))
    checkTrue(is.data.frame(X_test_df))
    checkEquals(2947, nrow(X_test_df))
    checkEquals(561, ncol(X_test_df))
    checkTrue(is.data.frame(y_test_df))
    checkEquals(2947, nrow(y_test_df))
    checkEquals(1, ncol(y_test_df))
    checkTrue(is.data.frame(subject_test_df))
    checkEquals(2947, nrow(subject_test_df))
    checkEquals(1, ncol(subject_test_df))
}

test.combine <- function() {
    prepare()
    analyser$read()
    out <- analyser$combine()
    checkTrue(is.null(out))
    checkTrue(is.data.frame(combined_df))
    checkEquals(10299, nrow(combined_df))
    checkEquals(564, ncol(combined_df))
    for(i in 1:3) checkEquals("integer", class(combined_df[,i]))
    for(i in 4:561) checkEquals("numeric", class(combined_df[,i]))
}

test.setnames <- function() {
    prepare()
    analyser$read()
    analyser$combine()
    out <- analyser$setnames()
    checkTrue(is.null(out))
    checkIdentical(c("index", "person", "activity"),
        head(names(combined_df), n=3))
    checkIdentical("tBodyAcc-mean()-X", names(combined_df)[4])
    checkIdentical("angle(Z,gravityMean)", names(combined_df)[564])
}

test.setlabels <- function() {
    prepare()
    analyser$read()
    analyser$combine()
    analyser$setnames()
    checkTrue(!is.factor(combined_df$activity))
    out <- analyser$setlabels()
    checkTrue(is.null(out))
    checkTrue(is.factor(combined_df$activity))
    checkEquals("STANDING", as.character(combined_df$activity[1]))
    checkEquals("SITTING", as.character(combined_df$activity[28]))
    checkEquals("LAYING", as.character(combined_df$activity[52]))
}

test.extract <- function() {
    prepare()
    analyser$read()
    analyser$combine()
    analyser$setnames()
    analyser$setlabels()
    out <- analyser$extract()
    checkTrue(is.null(out))
    checkTrue(is.data.frame(extracted_df))
    checkEquals(10299, nrow(extracted_df))
    checkEquals(69, ncol(extracted_df))
    checkIdentical(c("index", "person", "activity"),
        head(names(extracted_df), n=3))
    checkIdentical("tBodyAcc-mean()-X", names(extracted_df)[4])
    checkIdentical("fBodyBodyGyroJerkMag-std()", names(extracted_df)[69])
}

test.calculate <- function() {
    out <- analyser$calculate()
    checkTrue(is.null(out))
}

test.report <- function() {
    out <- analyser$report()
    checkTrue(is.null(out))
}

