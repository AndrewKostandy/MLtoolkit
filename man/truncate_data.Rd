\name{truncate_data}
\alias{truncate_data}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Truncate a Dataframe's Numeric Columns
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function allows you to truncate a dataframe using quartile and interquartile range values of the variables.
}
\usage{
truncate_data(data, quartiles = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
%%     ~~Describe \code{x} here~~
The dataframe you want to truncate.
}
\item{quartiles}{
%%     ~~Describe \code{x} here~~
A dataframe containing quartile & interquartile range information. If not provided, the function will compute & use the quartile values of the data for truncation.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
Returns a dataframe containing the numeric columns of the passed data with truncated values.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
truncate_data(iris)
}
_______________________________________________________________________
