x <- source("run_analysis.R")

.setUp <- function() {
    fullrun <<- FALSE
    download_from_local <<- TRUE
    analyser <<- Analyser()
}

.tearDown <- function() { }

prepare <- function() {
    analyser$setup()
    analyser$download()
    analyser$unpack()
}

test.configuration <- function() {
    checkTrue(is.logical(c(fullrun, download_from_local)))
    checkTrue(is.character(
       c(unpackdir, datadir, rawdir, zipfile, traindir, testdir)))
}

test.constructor <- function() {
    checkTrue(is.function(analyser$main))
}

test.setup_and_clean <- function() {
    # cleanup roundtrip on fullrun
    fullrun <<- TRUE
    analyser$clean()
    checkTrue(!dir.exists(datadir))
    checkTrue(!dir.exists(unpackdir))
    analyser$setup()
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
    analyser$download()
    checkTrue(file.exists(zipfile))
}

test.unpack <- function() {
    if(file.exists(rawdir)) unlink(rawdir, recursive = T)
    checkTrue(!file.exists(rawdir))
    analyser$setup()
    analyser$download()
    analyser$unpack()
    checkTrue(file.exists(rawdir))
}


