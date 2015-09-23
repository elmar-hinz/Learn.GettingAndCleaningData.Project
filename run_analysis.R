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
# Setup
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
# Create Analyser object
#
# Make the methods public available via a list for testing purposes.
######################################################################

Analyser <- function() {

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

    main <- function() {
        cleanup()
        setup()
        download()
        unpack()
        # combine_train_and_test()
        NULL
    }

    cleanup <- function() {
        if(fullrun) {
            if(file.exists(unpackdir)) unlink(unpackdir, recursive = T)
            if(file.exists(datadir)) unlink(datadir, recursive = T)
        }
        NULL
    }

    setup <- function() {
        if(!dir.exists(datadir)) dir.create(datadir)
        if(!dir.exists(unpackdir)) dir.create(unpackdir)
        NULL
    }

    download <- function() {
        if(download_from_local) url <- localurl else url <- remoteurl
        if(!file.exists(zipfile))
            download.file(url = url, destfile = zipfile, method = "auto")
        NULL
    }

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

    construct()
}

