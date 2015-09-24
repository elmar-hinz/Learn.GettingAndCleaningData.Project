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
    checkTrue(is.character(
       c(unpackdir, datadir, rawdir, zipfile, traindir, testdir)))
    checkTrue(is.integer(nr_inspect))
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
    # analyser$inspect('data/UciHarDataset/')
    analyser$inspect()
}

test.read_group <- function() {
    prepare()
    out <- analyser$read_group(testdir)
    for(file in names(out)) {
        checkTrue(is.data.frame(out[[file]]))
    }
    checkTrue(3 == length(out))
}

test.make_key <- function() {
    path <- "data/train/X_train.txt"
    pattern <- "train"
    checkIdentical("X_", analyser$make_key(path, pattern))
}

test.make_match_map <- function() {
    # check non uniqe file pathes
    checkException(silent = silent,
       analyser$make_match_map(c('a', 'a'), c('a', 'b')))
    checkException(silent = silent,
       analyser$make_match_map(c('a', 'b'), c('a', 'a')))
    # check different lengths
    checkException(silent = silent,
       analyser$make_match_map(1:2, 1:3))
    # check ununique keys
    firsts <- c('train/a.txt', 'train/plus/a.txt')
    seconds <- c('test/a.txt', 'test/plus/a.txt')
    checkException(silent = silent,
       analyser$make_match_map(firsts, seconds))
    # check missing element alpha in seconds
    firsts <- c('train/alpha.txt', 'a')
    seconds <- c('test/beta.txt', 'a')
    checkException(silent = silent,
       analyser$make_match_map(firsts, seconds))
    # check expected result even when input is disordered
    # alphabetically sorted by keys
    trains <- c('train/b.txt', 'train/a.txt')
    tests <- c('test/a.txt', 'test/b.txt')
    patterns <- c('train', 'test')
    out <- analyser$make_match_map(trains, tests, patterns)
    checkIdentical(c('a', 'b'), names(out))
    checkIdentical(c(trains[1], tests[2]), out[['b']])
    checkIdentical(c(trains[2], tests[1]), out[['a']])
}

# test.combine_train_and_test <- function() {
#     prepare()
#     analyser$combine_train_and_test()
# }


