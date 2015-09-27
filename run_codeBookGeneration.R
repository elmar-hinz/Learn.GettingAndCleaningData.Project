## formats
fname       <- "[%s] %s"
fdesc       <- "    * Name: %s"
fclass      <- "    * Class: %s"
ffactor     <- "    * Level:"
flevel      <- "        * %s"
frange      <- "    * Range: %s - %s"
empty       <- ""

# helpers
ucfirst <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}

ucthree <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,3)), substring(s, 4), sep="", collapse=" ")
}

describe <- function(nr, name, data) {
    out <- NULL
    out <- c(out, sprintf(fname, nr, name))
    out <- c(out, empty)
    desc <- name
    desc <- gsub("_", " ", desc)
    desc <- gsub(perl = T, "^tds", "Time Domain Signal", desc)
    desc <- gsub(perl = T, "^fft", "Fast Fourrier Transformation", desc)
    desc <- ucfirst(desc)
    out <- c(out, sprintf(fdesc, desc))
    out <- c(out, sprintf(fclass, class(data)))
    out <- c(out, values(data))
    out <- c(out, empty)
    out
}

values <- function(data) {
    out <- NULL
    if(is.factor(data)) {
        out <- c(out, sprintf(ffactor))
        for(l in levels(data))
            out <- c(out, sprintf(flevel, l))
    }
    if(is.numeric(data)) {
        out <- c(out, sprintf(frange, min(data), max(data)))
    }
    out
}

lines <- NULL
put <- function(x) { lines <<- c(lines, x) }

# Read part  1
path1 <- 'CodeBookPart1.md'
file1 <- file(path1, "r")
lines <- readLines(file1)
close(file1)

# Generate Part 2

f <- read.table('tidy_data.txt', header = T)
nms <- names(f)
for(i in 1:ncol(f)) put(describe(i, nms[i], f[,i]))

# Print
outpath <- "CodeBook.md"
outfile <- file(outpath, "w")
writeLines(lines, outfile)
close(outfile)

