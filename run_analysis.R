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

# Display raw data inspection (takes some time)
do_inspect <- TRUE

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

# number of lines to inspect in each file to detect column count
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
            merge =  merge,
            calculate = calculate,
            report = report
         )
    }

    ##################################################
    # Main functions
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
        if(do_inspect) inspect(rawdir)
        read()
        # combine()
        # merge()
        # calculate()
        # report()
        NULL
    }

    ##################################################
    # Cleanup
    #
    # Cleans everything up to prepare a full run if `fullrun` is TRUE.
    #
    # @return NULL
    ##
    cleanup <- function() {
        if(fullrun) {
            if(file.exists(unpackdir)) unlink(unpackdir, recursive = T)
            if(file.exists(datadir)) unlink(datadir, recursive = T)
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

    read <- function() {
        if(!exists('features_df') || fullrun)
            features_df <<- read.table(features_file)
        if(!exists('activity_labels_df') || fullrun)
            activity_labels_df <<- read.table(activity_labels_file)
        if(!exists('X_train_df') || fullrun)
           X_train_df <<- read.table(X_train_file)
        if(!exists('X_test_df') || fullrun)
            X_test_df <<- read.table(X_test_file)
        if(!exists('y_train_df') || fullrun)
            y_train_df <<- read.table(y_train_file)
        if(!exists('y_test_df') || fullrun)
            y_test_df <<- read.table(y_test_file)
        if(!exists('subject_train_df') || fullrun)
            subject_train_df <<- read.table(subject_train_file)
        if(!exists('subject_test_df') || fullrun)
            subject_test_df <<- read.table(subject_test_file)
        NULL
    }

    ##################################################
    # Combine train and test data
    #
    # @return NULL
    ##
    combine <- function() {
        main_df <<- rbind(X_train_df, X_test_df)
        person_df <<- rbind(subject_train_df, subject_test_df)
        activity_df <<- rbind(y_train_df, y_test_df)
        NULL
    }

    ##################################################
    # Merge data into one table
    #
    # @return NULL
    ##
    merge <- function() {
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

