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

require(stringr)

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

# number of lines to inspect in each file to detect column count
nr_inspect <- 5

######################################################################
# Create analyser object
#
# @return list - list with accessor functions
######################################################################

Analyser <- function() {

    trains <- NULL
    tests <- NULL
    map <- NULL

    ##################################################
    # Constructor
    #
    # @return list - list with accessor functions
    ##
    construct <- function() {
        list(
            setup = setup,
            download = download,
            unpack = unpack,
            inspect = inspect,
            read = read,
            raw_report = raw_report,
            cleanup = cleanup,
            make_match_map = make_match_map,
            read_group = read_group,
            make_key = make_key,
            raw_report = raw_report,
            main = main
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
        raw_report()
        combine()
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
            isnu <- lapply(splits[2], is.numeric)
            out <- sprintf("%25s:  %s * %s", basename(file), x, y)
            print(out)
        }
        NULL
    }

    read <- function() {
        trains <<- read_group(traindir)
        tests <<- read_group(testdir)
        map <<- make_match_map(names(trains), names(tests))
    }

    ##################################################
    # Read files from train or test group
    #
    # Reads by `read.table` and returns a list of
    # data frames. The files basename without postfix
    # goes into each key of the list.
    #
    # @param character - path to the groups directory
    # @return list - list of dataframes
    ##
    read_group <- function(dir) {
        files <- list()
        pathes <- list.files(dir, recursive = F, full.names = T)
        for(path in pathes) {
            if(!file.info(path)$isdir) {
                name <- basename(path)
                name <- strsplit(name, split = '.', fixed = T)[[1]][1]
                files[[name]] <- read.table(path)
            }
        }
        files
    }

    ##################################################
    # Check two lists of given file pathes and pair them
    #
    # Example:
    #      data/train/X_train.txt matches data/test/X_test.txt
    #      The differing patterns are "train" vs "test".
    #
    # * Inputs two lists of file pathes that differ by pattern.
    # * Inspects the file names and matches them as pairs.
    # * Checks that nothing is in excess or missing.
    # * Creates a common key for matching files.
    # * This keys are extracted from the file names.
    # * Returns a list: keys and paired file pathes.
    #
    # @param charater - vector of train files
    # @param charater - vector of test files
    # @param charater - patterns, defaults to c(train, test)
    # @return list - char keys, char vectors of lenght 2
    ##
    make_match_map <-
        function(firsts, seconds, patterns = c('train', 'test')) {
        # initial checks
        if(length(firsts) >  length(unique(firsts)))
            stop("elements in firsts are not unique")
        if(length(seconds) > length(unique(seconds)))
            stop("elements in seconds are not unique")
        if(length(firsts) != length(seconds))
            stop("elements in firsts and seconds don't have equal length")
        # try to match
        heap <- seconds
        out <- list()
        for(candidate in firsts) {
            key <- make_key(candidate, patterns[1])
            if(key %in% names(out)) {
                msg <- 'filename "%s" and it\'s key "%s" are not unique'
                stop(sprintf(msg, candidate, key))
            }
            needle <- str_replace_all(candidate, patterns[1], patterns[2])
            if(!(needle %in% heap)) {
                msg <- 'missing element "%s" in seconds "%s"\n'
                stop(sprintf(msg, needle[1], heap[1]))
            } else {
                heap <- heap[-(match(needle, heap))]
                out[[key]] <- c(candidate, needle)
            }
        }
        out[sort(names(out))]
    }

    ##################################################
    # Make a key from a file path
    #
    # "data/X_train.txt" results in "X_" for "train"
    #
    # * directories are stripped
    # * file ending is stripped
    # * pattern is stripped
    #
    # @param character - file path
    # @param character - pattern to remove
    # @return character - the generated key
    ##
    make_key <- function(filepath, pattern_to_remove) {
        basename <- basename(filepath)
        key <- strsplit(basename, split = ".", fixed = T)[[1]][1]
        str_replace(key, pattern_to_remove, "")
    }

    ##################################################
    # Analyse import files
    ##
    raw_report <- function() {
    }

    # Finally call the contructor function and return the object list
    construct()
}

