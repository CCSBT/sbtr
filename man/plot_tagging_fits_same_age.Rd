% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/om_plot_tagging_fits.R
\name{plot_tagging_fits_same_age}
\alias{plot_tagging_fits_same_age}
\title{Plots the fits to the tagging data}
\usage{
plot_tagging_fits_same_age(
  data.object,
  ages = 1:8,
  years = 1991:1997,
  case_label = "c1s1l1orig.5_h1m1M1O1C2a1"
)
}
\description{
Plots the fits to the pooled tagging data for sbtmod22.tpl outputs from a _lab.rep file, assuming that the naming convention in the file has sections of outputs separated by $name comments so that it can be easily parsed by readList() function of Jon Schnute
}
