\name{trim_df}
\alias{trim_df}
\title{
Trim a Dataframe's Numeric Columns
}
\description{
Trim numeric dataframe variables using various methods.
}
\usage{
trim_df(data, type, perc = NULL)
}
\arguments{
  \item{data}{
    The dataframe you want to trim.
  }
  \item{type}{
    A string value that specifies the technique to use to trim the variables. Current options are "iqr" or "1_99".
  }
  \item{perc}{
    A dataframe containing key percentile & interquartile range information. If not provided, the function will compute & use     the percentile values of the data for trimming.
  }
}
\details{

If type="iqr", then for each numeric variable:

- Values below the 25th percentile by more than 1.5 x IQR are trimmed to be exactly 1.5 x IQR below the 25th percentile.\cr

- Values above the 75th percentile by more than 1.5 x IQR are trimmed to be exactly 1.5 x IQR above the 75th percentile.\cr\cr\cr



If type="1_99", then for each numeric variable:

- Values below the 1st percentile are trimmed to be exactly the value of the 1st percentile.\cr

- Values above the 99th percentile are trimmed to be exactly the value of the 99th percentile.\cr\cr\cr



Percentiles provided need to be in a dataframe where for each numeric variable in order:

1. The first row contains the 1st percentile values.\cr

2. The second row contains the 25th percentile values.\cr

3. The third row contains the 50th percentile (median) values. (Will not be used)\cr

4. The fourth row contains the 75th percentile values.\cr

5. The fifth row contains the 99th percentile values.\cr

6. The sixth row contains the interquartile range values.\cr
}
\value{
Returns a dataframe where the numeric columns have trimmed values. Non-numeric data remains unchanged.
}
\section{Figures}{
\if{html}{\figure{trim_df_1.svg}{options: width=100\%}}
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
trim_df(iris, type = "iqr")
}
