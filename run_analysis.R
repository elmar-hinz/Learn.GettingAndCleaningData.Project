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

downloadurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datadir <- "data"
zipfile <- "data/UciHarDataset.zip"

main <- function() {
    prepare()
}

prepare <- function() {
    if(!dir.exists(datadir)) dir.create(datadir)
    if(!file.exists(zipfile)) {
        download.file(url = downloadurl, destfile = zipfile, method = "curl")
    }
    unzip(zipfile = zipfile, exdir = datadir)
}

main()
