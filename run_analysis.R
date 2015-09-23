######################################################################
#                                                                    #
#    Copyright (c) 2015 Elmar Hinz (github.com/elmar-hinz)           #
#                                                                    #
#    This script solves the TODO                 #
#    of coursera TODO
#    It ships with a suite of unit tests.                            #
#                                                                    #
#    License: MIT (see LICENSE.txt)                                  #
#                                                                    #
######################################################################

######################################################################
# Configuration
######################################################################

# Do a fullrun including download from remote or local
fullrun <- FALSE

# If local is TRUE downlad from local file
download_from_local <- TRUE

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
            setup = setup,
            download = download,
            unpack = unpack,
            combine_train_and_test = combine_train_and_test,
            cleanup = cleanup
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
        # combine_train_and_test()
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

    combine_train_and_test <- function() {
        trains <- read_all_files(traindir)
        tests <- read_all_files(traindir)
        for(t in c(trains, tests)) { print(summary(t)) }
        NULL
    }

    read_all_files <- function(dir) {
        files <- list()
        pathes <- list.files(dir, recursive = F, full.names = T)
        for(path in pathes) {
            if(!file.info(path)$isdir) {
                files[[path]] <- read.table(path)
            }
        }
        files
    }

    # Finally call the contructor function and return the object list
    construct()
}

