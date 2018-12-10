\name{get_perc}
\alias{get_perc}
\title{
Get Key Percentiles of a Dataframe's Numeric Columns
}
\description{
This function allows you to get key percentiles (1, 25, 50, 75, 99) of the variables in a dataframe & their interquartile range values.

Any non-numeric columns in the dataframe would be ignored.

The function ignores NA values within the columns.
}
\usage{
get_perc(data)
}
\arguments{
  \item{data}{
The dataframe you want to get the percentiles of.
}
}
\value{
Returns a dataframe with the key percentiles of each numeric column in the data and the interquartile range values.
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
get_perc(iris)
}
_______________________________________________________________________
