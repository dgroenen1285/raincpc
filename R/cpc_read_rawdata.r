# read raw cpc data

cpc_read_rawdata <- function(yr, mo, day) {
  
  # file name
  dateStr <- paste0(yr, sprintf("%.2d", mo), sprintf("%.2d", day))
  cpcFile <- paste0("raw_", dateStr, ".bin")
  if (yr <= 2008) {
    cpcFile <- paste0("raw_", dateStr, ".gz")
  }
  stopifnot(file.exists(cpcFile))
  
  # open file connection
  if (yr <= 2008) {
    fileCon <- gzcon(file(cpcFile, "rb"))
  } else {
    fileCon <- file(cpcFile, "rb")
  }
  
  # data attributes, from PRCP_CU_GAUGE_V1.0GLB_0.50deg_README.txt
  cpcNumLat   <- 360 # number of lats
  cpcNumLon   <- 720 # number of lons
  cpcNumBytes <- cpcNumLat * cpcNumLon * 2 # 2 fields, precipitation and num gages
  cpcRes      <- 0.5 # data resolution
  cpcLatVec   <- -89.75 + (1:cpcNumLat) * cpcRes - cpcRes # latitudes
  cpcLonVec   <- 0.25 + (1:cpcNumLon) * cpcRes - cpcRes # longitudes
  
  # read data
  inData  <- readBin(con = fileCon, 
                     what = numeric(), 
                     n = cpcNumBytes, 
                     size = 4, 
                     endian = "little")
  close(fileCon)
  
  # extract first field (precipitation), ignore second field (num gages)
  inData <- inData[1:(cpcNumBytes/2)]
  
  # reshape, flip rows for proper North-South orientation
  # original data goes from South to North
  prcpData <- array(0, dim = c(cpcNumLat, cpcNumLon))
  for(eachRow in 1:cpcNumLat) {
    index1 <- 1 + (eachRow - 1) * cpcNumLon
    index2 <- eachRow * cpcNumLon
    prcpData[eachRow, ] <- inData[index1:index2]
  }
  # remove -ve (missing) values
  prcpData[prcpData < 0] <- NA
  # convert tenths of mm to mm
  prcpData <- ifelse(prcpData > 0, prcpData * 0.1, prcpData)
  
  # write data to file
  outCon <- file(paste0(dateStr, ".bin"), "wb")
  writeBin(as.numeric(prcpData), con = outCon, size = 4, endian = "little")
  close(outCon)
  
  return (prcpData)
}
