#' Identify CPC file extnensions
#'
#' @param yr year from 1979 to 2012
#' @keywords internal
cpc_file_extns <- function(yr) {
  stopifnot(yr %in% seq(1979, 2012))
  
  if (yr %in% seq(1979, 2005)) {
    urlTag  <- "V1.0/"
    fileTag <- ".gz"
  } else if (yr %in% c(2006)) {
    urlTag  <- "RT/"
    fileTag <- "RT.gz"
  } else if (yr %in% c(2007, 2008)) {
    urlTag  <- "RT/"
    fileTag <- ".RT.gz"
  } else { #if (yr %in% seq(2009, 2013)) {
    urlTag  <- "RT/"
    fileTag <- ".RT"
  } 
  
  return (list(urlTag = urlTag, fileTag = fileTag))
}
