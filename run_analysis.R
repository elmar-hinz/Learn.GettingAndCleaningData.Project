######################################################################
#                                                                    #
#    Copyright (c) 2015 Elmar Hinz (github.com/elmar-hinz)           #
#                                                                    #
#    Code project of the course                                      #
#    Coursera Getting and Cleaning Data - getdata-032                #
#                                                                    #
#    License: MIT (see LICENSE.txt)                                  #
#                                                                    #
######################################################################

# require(stringr)

######################################################################
# Configuration
######################################################################

# Do a fullrun including download from remote or local
fullrun <- FALSE

# If local is TRUE downlad from local file (faster)
download_from_local <- TRUE

# URLs
localurl <- "file://./UciHarDataset.zip"
remoteurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Directories
unpackdir <- "temp"
datadir <- "data"
rawdir <- "data/UciHarDataset"
traindir <- "data/UciHarDataset/train"
testdir <- "data/UciHarDataset/test"

# Files
zipfile <- "data/UciHarDataset.zip"
activity_labels_file <- "data/UciHarDataset/activity_labels.txt"
features_file <- "data/UciHarDataset/features.txt"
X_train_file <- "data/UciHarDataset/train/X_train.txt"
X_test_file <- "data/UciHarDataset/test/X_test.txt"
y_train_file <- "data/UciHarDataset/train/y_train.txt"
y_test_file <- "data/UciHarDataset/test/y_test.txt"
subject_train_file <- "data/UciHarDataset/train/subject_train.txt"
subject_test_file <- "data/UciHarDataset/test/subject_test.txt"

# Number of lines to inspect in each file to detect column count
nr_inspect <- 5

######################################################################
# Create analyser object
#
# @return list - list with accessor functions
######################################################################

Analyser <- function() {

    ##################################################
    # Constructor
    #
    # @return list - list with accessor functions
    ##
    construct <- function() {
        list(
            main = main,
            cleanup = cleanup,
            setup = setup,
            download = download,
            unpack = unpack,
            inspect = inspect,
            read = read,
            combine = combine,
            setnames = setnames,
            merge =  merge,
            calculate = calculate,
            report = report
         )
    }

    ##################################################
    # Main function
    #
    # Controlls the full process.
    #
    # @return NULL
    ##
    main <- function() {
        cleanup()
        setup()
        download()
        unpack()
        read()
        combine()
        setnames()
        merge()
        # calculate()
        # report()
        NULL
    }

    ##################################################
    # Cleanup
    #
    # Cleans everything up to prepare a full run if `fullrun` is TRUE.
    #
    # 1. directories used to process the data
    # 2. variables caching data frames between non full runs
    #
    # @return NULL
    ##
    cleanup <- function() {
        if(fullrun) {
            if(file.exists(unpackdir)) unlink(unpackdir, recursive = T)
            if(file.exists(datadir)) unlink(datadir, recursive = T)
            features_df <<- NULL
            activity_labels_df <<- NULL
            X_train_df <<- NULL
            X_test_df <<- NULL
            y_train_df <<- NULL
            y_test_df <<- NULL
            subject_train_df <<- NULL
            subject_test_df <<- NULL
        }
        NULL
    }

    ##################################################
    # Setup
    #
    # Creates the workspace directories.
    #
    # @return NULL
    ##
    setup <- function() {
        if(!dir.exists(datadir)) dir.create(datadir)
        if(!dir.exists(unpackdir)) dir.create(unpackdir)
        NULL
    }

    ##################################################
    # Download
    #
    # Downloads the raw data as a Zip file if the Zip file
    # doesn't exist after a clean up.
    #
    # If `download_from_local` is TRUE it downloads
    # from a local copy of the zip file else from remote.
    #
    # @return NULL
    ##
    download <- function() {
        if(!file.exists(zipfile)) {
            if(download_from_local) url <- localurl else url <- remoteurl
            download.file(url = url, destfile = zipfile, method = "auto")
        }
        NULL
    }

    ##################################################
    # Unpack
    #
    # Unpacks the raw data from Zipfile if the raw
    # data directory doesn't exist after a clean up.
    #
    # @return NULL
    ##
    unpack <- function() {
        if(!dir.exists(rawdir)) {
            unzip(zipfile = zipfile, exdir = unpackdir)
            dir <- list.files(unpackdir, full.name = T)
            if(length(dir) == 1) {
                file.rename(dir, rawdir)
            } else {
                str(dir)
                stop("expected to find one directory")
            }
        }
        NULL
    }

    ##################################################
    # Inspect the files in the given directory tree
    #
    # * Displays  to std out.
    # * Recursively finds the files.
    # * Counts rows and columns.
    # * For plain text files the column count is *mixed*.
    # * Column count is done by inspecting x lines of head.
    # * Set global configuration *nr_inspect* to modify this.
    #
    # @return NULL
    ##
    inspect <- function(dir = rawdir) {
        files <- dir(dir, recursive=T, full.names=T)
        for(file in files) {
            lines <- readLines(file)
            x <- length(lines)
            head <- head(lines, n = nr_inspect)
            splits <- strsplit(head, "\\s+", perl = T)
            linelengths <- unique(vapply(splits, length, 0L))
            if(length(linelengths) > 1) y <- "mixed"
            else y <- linelengths
            out <- sprintf("%25s:  %s * %s", basename(file), x, y)
            print(out)
        }
        NULL
    }

    ##################################################
    # Read all necessary data files
    #
    # Reads only if `fullrun` is TRUE or
    # the data frame variable still don't exits.
    #
    # @return NULL
    ##
    read <- function() {
        if(is.null(features_df))
            features_df <<- read.table(features_file)
        if(is.null(activity_labels_df))
            activity_labels_df <<- read.table(activity_labels_file)
        if(is.null(X_train_df))
            X_train_df <<- read.table(X_train_file)
        if(is.null(X_test_df))
            X_test_df <<- read.table(X_test_file)
        if(is.null(y_train_df))
            y_train_df <<- read.table(y_train_file)
        if(is.null(y_test_df))
            y_test_df <<- read.table(y_test_file)
        if(is.null(subject_train_df))
            subject_train_df <<- read.table(subject_train_file)
        if(is.null(subject_test_df))
            subject_test_df <<- read.table(subject_test_file)
        NULL
    }

    ##################################################
    # Combine train and test data (task 1)
    #
    # Merges the training and the test sets of interest
    # to create ONE data set: combined_df
    #
    # Step 1: rbind()
    #
    # 1. subject_train_df + subject_test_df into persons
    # 2. y_train_df + y_test_df into activities
    # 3. X_train_df + X_test_df into features
    #
    # Step 2: cbind()
    #
    # 1. index (created from 1 to number of rows)
    # 2. persons
    # 3. activities
    # 4. features
    #
    # Globally exports combined_df
    #
    #   column 1: type = integer
    #   column 2: type = integer
    #   column 3: type = integer
    #   columns 4 - 564: type = numeric
    #
    # @return NULL
    ##
    combine <- function() {
        features <- rbind(X_train_df, X_test_df)
        activities <- rbind(y_train_df, y_test_df)
        persons <- rbind(subject_train_df, subject_test_df)
        index <- data.frame(1:nrow(features))
        combined_df <<- cbind(index, persons, activities, features)
        NULL
    }

    ##################################################
    # Set human readable names (task 4)
    #
    # Set column names to combined_df:
    #
    #   1. index
    #   2. person
    #   3. activity
    #   4. "tBodyAcc-mean()-X"
    #   ...
    #   564.  "angle(Z,gravityMean)"
    #
    # Names 4 - 564 are the labels from features_df.
    # The correct order of the mapping is checked against
    # it's index (column 1).
    #
    # @return NULL
    ##
    setnames <- function() {
        stopifnot(identical(1:561, features_df[,1]))
        names(combined_df) <<- c("index", "person", "activity",
            as.character(features_df[,2]))
        NULL
    }

    ##################################################
    # Merge activity labels
    #
    # Replace the activity integers by activity labels
    # from activity_labels_df.
    #
    # @return NULL
    ##
    merge <- function() {
        # get a vector of labels sorted by index of activity_labels_df
        labels <- activity_labels_df[order(activity_labels_df[1]), ][,2]
        # apply the labels
        combined_df$activity <<- labels[combined_df$activity]
        NULL
    }

    ##################################################
    # Do the required calculations
    #
    # @return NULL
    ##
    calculate  <- function() {
        NULL
    }

    ##################################################
    # Report results into the tidy data file
    #
    # @return NULL
    ##
    report <- function() {
        NULL
    }

    # Finally call the contructor function and return the object list
    construct()
}

