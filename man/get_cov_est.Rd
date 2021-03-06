% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/om_get_cov_est.R
\name{get_cov_est}
\alias{get_cov_est}
\title{Load covariance and estimates R}
\usage{
get_cov_est(directory = "../OM/arc/base2016_sqrt")
}
\arguments{
\item{directory}{the directory that the ADMB .par/.std/.cor files are in}
}
\value{
a list of objects dimensioned by number of grids
}
\description{
Goes to the specified directory and finds the .est and .cov files. 
Loads them one by one into an R list of objects. This ensures that
the reading in stage (which can take 3-10 minutes) need only be done once, 
and then subsequent function calls looping through an entire grid will run 
in a few seconds instead of minutes. Required the following files: something 
ending in .cor and .std
}
\examples{
grid.cov.est <- get_grid_cov_est(directory = "arc/basesqrt")
}
\author{
Jim Ianelli, Darcy Webber,  Ana Parma
}
