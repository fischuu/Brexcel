#' Emulate PHE Data Handling
#'
#' This function truncates all data frames and matrices in your global environment to
#' emulate Public Health England (PHE) data handling with Excel (i.e. truncate them)
#'
#' Available presets are \code{"Excel2003"} (default) and \code{"Excel2007"}.
#' The preset \code{"Excel2003"} keeps 65,536 rows and 255 columns, whereas
#' \code{"Excel2007"} keeps 1,048,576 rows and 16,384 columns.
#' Any other truncation is applied with the \code{nrow} and \code{ncol} options.
#'
#' WARNING: RUN THIS FUNCTION ONLY, IF YOU REALLY WANT TO TRUNCATE ALL OBJECTS!
#' REMEMBER, THERE IS NO WAY TO RESTORE THE TRUNCATED PARTS, OTHER THAN TO
#' RECREATE THE TRUNCATED OBJECTS. DO NOT BLAME ME FOR DATA LOSS!
#'
#' @param version Different truncation presets
#' @param nrow User defined number of rows to keep
#' @param ncol User defined number of columns to keep
#' @param verbose Logical, switch on/off function feedback
#'
#' @examples
#' ds1 <- matrix(1,ncol=100, nro=100)
#' ds2 <- as.data.frame(ds1)
#' ds3 <- matrix(1, ncol=3, nrow=10)
#' ds4 <- matrix(1, ncol=10, nrow=2)
#' ds5 <- matrix(1,ncol=3, nrow=2)
#' ds6 <- matrix(1,ncol=5, nrow=10)
#' brexcelfy(ncol=5, nrow=5)
#'
#' @export

brexcelfy <- function(version="Excel2003", nrow=NULL, ncol=NULL, verbose=TRUE){

# Input checks
  version <- match.arg(version, c("Excel2003", "Excel2007"))

# Apply the presets
  if(version == "Excel2003"){
    nrow.int <- 65536
    ncol.int <- 255
  } else if(version == "Excel2007"){
    nrow.int <- 1048576
    ncol.int <- 16384
  }

# Apply user defined settings
  if(!is.null(nrow)){
    nrow.int <- nrow
  }
  if(!is.null(ncol)){
    ncol.int <- ncol
  }

# Give feedback
  if(verbose) message("All objects will be truncated to ", format(nrow.int, big.mark=","), " rows and ", format(ncol.int, big.mark=","), " columns")

# Find all objects of interest and truncate them
  envObjects <- ls(envir = .GlobalEnv)
  objectsOI <- c()
  for(i in 1:length(envObjects)){
  # Make current object available
    evalObj <- eval(parse(text=envObjects[i]))
    nrow.orig <- nrow(evalObj)
    ncol.orig <- ncol(evalObj)

  # Check, if object is data.frame or matrix
    if(is.data.frame(evalObj) | is.matrix(evalObj)){
      objectsOI <- c(objectsOI, envObjects[i])

    # Handle the situation, of object does not 'need' any truncation
      if(verbose){
        if(nrow.orig<=nrow.int & ncol.orig<=ncol.int){
          nrow.tmp <- nrow.orig
          ncol.tmp <- ncol.orig
          message(envObjects[i], " does not need any truncation")
        } else {
          nrow.tmp <- min(nrow.int, nrow(evalObj))
          ncol.tmp <- min(ncol.int, ncol(evalObj))
          message(envObjects[i], " truncated from ", nrow.orig,"x",ncol.orig," to ", nrow.tmp,"x", ncol.tmp)
        }
      }

    # Do the truncation
      assign(envObjects[i], evalObj[1:nrow.tmp, 1:ncol.tmp], envir = .GlobalEnv)
    }
  }
}
