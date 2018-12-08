\name{get_quartiles}
\alias{get_quartiles}
\title{
Get Quartiles of a Dataframe's Numeric Columns
}
\description{
This function allows you to get quartiles of the variables in a dataframe & their interquartile range values.

Any non-numeric columns in the dataframe would be ignored.

The function ignores NA values within the columns.
}
\usage{
get_quartiles(data)
}
\arguments{
  \item{data}{
The dataframe you want to get the quartiles of.
}
}
\value{
Returns a dataframe with the three quartile values of each numeric column in the data and the interquartile range values.
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
get_quartiles(iris)
}
_______________________________________________________________________
