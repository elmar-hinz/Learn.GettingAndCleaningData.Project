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

# Directories and files
unpackdir <- "temp"
datadir <- "data"
rawdir <- "data/UciHarDataset"
zipfile <- "data/UciHarDataset.zip"
traindir <- "data/UciHarDataset/train"
testdir <- "data/UciHarDataset/test"

train_features <- "data/UciHarDataset/train/X_test.txt"
test_features <- "data/UciHarDataset/test/X_test.txt"

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
    }

    ##################################################
    # Combine train and test data
    #
    # @return NULL
    ##
    combine <- function() {}

    ##################################################
    # Merge data into one table
    #
    # @return NULL
    ##
    merge <- function() {}

    ##################################################
    # Do the required calculations
    #
    # @return NULL
    ##
    calculate  <- function() {}

    ##################################################
    # Report results into the tidy data file
    #
    # @return NULL
    ##
    report <- function() {}

    # Finally call the contructor function and return the object list
    construct()
}

