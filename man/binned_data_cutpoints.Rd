% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/variable_binning.R
\name{binned_data_cutpoints}
\alias{binned_data_cutpoints}
\title{Get the unique cutpoints of each appropriate column in a tbl.}
\usage{
binned_data_cutpoints(d, parallel = FALSE)
}
\arguments{
\item{d}{a tbl}

\item{parallel}{logical. If TRUE, parallel foreach used. Must register
parallel beforehand. Default false}
}
\value{
a named list containing one vector for each factor type variable.
Each vector contains the unique cut points of that variable
}
\description{
This function takes a dataframe where any number of columns have been binned
into factors using cut/vector_bin and returns a named list containing the
cutpoints for each variable.
This is useful for, for example, binning a new dataset into the same bins
as an older dataset- such as when making predictions on test data
}
\details{
This function essentially calls \code{\link{get_vector_cutpoints}} on all
factor type columns of \code{d}. It is meant to be used to provide an output
format that works with the \code{bins} argument of \code{\link{simple_bin}},
for the purpose of defining cutpoints based on one dataset and then applying
them to other datasets. The basic functionality of binning on training data
and applying those bins to test data is built right in to
\code{\link{simple_bin}}, but this function allows the user total
flexibility.
}
\examples{
x <- dplyr::data_frame(v1 = cut(rnorm(100),c(-1,0,1)),
                       v2 = cut(rnorm(100),c(-.5,0,.5)))
binned_data_cutpoints(x)
binned_data_cutpoints(x,parallel = TRUE)
}
\seealso{
\code{\link{get_vector_cutpoints}}, \code{\link{simple_bin}}

Other discretization: \code{\link{get_vector_cutpoints}},
  \code{\link{simple_bin}}, \code{\link{vector_bin}}
}

