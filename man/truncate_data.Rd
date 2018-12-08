\name{truncate_data}
\alias{truncate_data}
\title{
Truncate a Dataframe's Numeric Columns
}
\description{
This function allows you to truncate a dataframe using quartile and interquartile range values of the variables.
}
\usage{
truncate_data(data, quartiles = NULL)
}
\arguments{
  \item{data}{
The dataframe you want to truncate.
}
\item{quartiles}{
A dataframe containing quartile & interquartile range information. If not provided, the function will compute & use the quartile values of the data for truncation.
}
}
\details{
For each numeric variable:

- Values below the 1st quartile by more than 1.5 x IQR are truncated to be exactly 1.5 x IQR below the 1st quartile.\cr

- Values above the 3rd quartile by more than 1.5 x IQR are truncated to be exactly 1.5 x IQR above the 3rd quartile.\cr

Quartiles provided need to be in a dataframe where for each numeric variable in order:

1. The first row contains the 1st quartile values.\cr

2. The second row contains the 2nd quartile (median) values. (Will not be used)\cr

3. The third row contains the 3rd quartile values.\cr

4. The fourth row contains the interquartile range values.\cr
}
\value{
Returns a dataframe containing the numeric columns of the passed data with truncated values.
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
truncate_data(iris)
}
_______________________________________________________________________
