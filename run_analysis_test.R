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
        train_features_file, test_features_file
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
    analyser$inspect()
}

test.read <- function() {
    prepare()
    analyser$read()
    checkTrue(is.data.frame(train_features_df))
    checkTrue(is.data.frame(test_features_df))
}

