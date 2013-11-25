#' Download raw rainfall data from CPC for time period of interest
#'
#' @param begYr beginning year of the time period of interest, 1979 - 2012
#' @param begMo beginning month of the time period of interest, 1 - 12
#' @param begDay beginning day of the time period of interest, 1 - 28/29/30/31
#' @param endYr ending year of the time period of interest, 1979 -2012
#' @param endMo ending month of the time period of interest, 1 - 12
#' @param endDay ending day of the time period of interest, 1 - 28/29/30/31
#' @export
#' @examples
#' # CPC data for Jan 01 2012
#' cpc_1day <- cpc_get_rawdata(2012, 1, 1, 2012, 1, 1)
#' 
#' # CPC data for Jan 01 - Jan 02, 2012
#' cpc_2days <- cpc_get_rawdata(2012, 1, 1, 2012, 1, 2)

cpc_get_rawdata <- function(begYr, begMo, begDay, endYr, endMo, endDay) {                            
  
  # check year and month validity
  # day validity - mostly leave it up to the user
  if (!(begYr %in% seq(1979, 2012) & endYr %in% seq(1979, 2012))) {
    stop("year should be between 1979 to 2012!")
  }
  
  # url and file prefixes
  urlHead  <- "ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/"
  fileHead <- "PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx."
  
  for (eachYr in c(begYr:endYr)) {
    # generate dates of all the days in the format yyyy-mm-dd
    allDates <- seq(as.Date(paste(eachYr, begMo, begDay, sep = "-")), 
                    as.Date(paste(eachYr, endMo, endDay, sep = "-")), 
                    by = "day")
    # date string used in the filenames below
    dateStr  <- paste0(substr(allDates, 1, 4), 
                       substr(allDates, 6, 7), 
                       substr(allDates, 9, 10))
    yrStr    <- substr(allDates, 1, 4)
    
    # identify file names and extensions
    filex <- cpc_file_extns(eachYr)
    
    # download
    for (eachDay in 1:length(allDates)) {
      # construct url
      fileUrl <- paste0(urlHead, filex$urlTag, yrStr[eachDay], "/", fileHead, 
                        dateStr[eachDay], filex$fileTag)
      
      # out file name; gzipped file prior to 2008 otherwise binary
      outFile <- ifelse(eachYr <= 2008, 
                        paste0("raw_", dateStr[eachDay], ".gz"), 
                        paste0("raw_", dateStr[eachDay], ".bin")) 
      
      # download file only if it doesnt exist
      # internet connection could be "intermittent" - could be due to the CPC server?
      # hence files are not sometimes downloaded; hence the quieted while loop below
      if (!file.exists(outFile)) {
        fileError <- TRUE
        while (fileError) {
          if (eachYr <= 2008) {
            fileStatus <- try(download.file(url = fileUrl, 
                                            destfile = outFile, 
                                            quiet = TRUE), 
                              silent = TRUE)
          } else {
            fileStatus <- try(download.file(url = fileUrl, 
                                            destfile = outFile, 
                                            mode = "wb", 
                                            quiet = TRUE), 
                              silent = TRUE)    
          }
          fileError  <- ifelse(class(fileStatus) == "try-error", TRUE, FALSE)
        }
      }
      
    }
  }
}
