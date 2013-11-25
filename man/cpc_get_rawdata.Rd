\name{cpc_get_rawdata}
\alias{cpc_get_rawdata}
\title{Download raw rainfall data from CPC for time period of interest}
\usage{
  cpc_get_rawdata(begYr, begMo, begDay, endYr, endMo,
    endDay)
}
\arguments{
  \item{begYr}{beginning year of the time period of
  interest, 1979 - 2012}

  \item{begMo}{beginning month of the time period of
  interest, 1 - 12}

  \item{begDay}{beginning day of the time period of
  interest, 1 - 28/29/30/31}

  \item{endYr}{ending year of the time period of interest,
  1979 -2012}

  \item{endMo}{ending month of the time period of interest,
  1 - 12}

  \item{endDay}{ending day of the time period of interest,
  1 - 28/29/30/31}
}
\description{
  It is assumed that the ending year, month and day follow
  the beginning year, month and day. Output is either a
  ".gz" file (1979 - 2008) or a ".bin" file (2009 - 2013).
}
\examples{
# CPC data for 1 day, Jan 01 2008
cpc_get_rawdata(2008, 1, 1, 2008, 1, 1)

# CPC data for two days, Jul 11-12 2005
cpc_get_rawdata(2005, 7, 11, 2005, 7, 12)
}

