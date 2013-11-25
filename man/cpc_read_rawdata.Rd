\name{cpc_read_rawdata}
\alias{cpc_read_rawdata}
\title{Read downloaded raw rainfall data from CPC}
\usage{
  cpc_read_rawdata(yr, mo, day)
}
\arguments{
  \item{yr}{year associated with the downloaded file, 1979
  - 2012}

  \item{mo}{month associated with the downloaded file, 1 -
  12}

  \item{day}{day associated with the downloaded file, 1 -
  28/29/30/31}
}
\description{
  Function checks for the existence of the raw files from
  CPC and only then attempts to process the data. Output
  matrix is written to a binary file. The output matrix has
  360 rows (latitudes) and 720 columns (longitudes) of
  rainfall/precipitation in units of mm/day. The first data
  point has the lat, lon values of -89.75 and 0.25 degrees,
  respectively. Spatial resolution of the data is 0.5
  degrees. Refer to the project home page for plotting the
  data with proper North-South orientation.
}
\examples{
# CPC data for Jan 01 2008
cpc_1day <- cpc_read_rawdata(2008, 1, 1)
}

