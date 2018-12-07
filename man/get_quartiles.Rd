\name{get_quartiles}
\alias{get_quartiles}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Get Quartiles of a Dataframe's Numeric Columns
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function allows you to get quartiles of the variables in a dataframe & their interquartile range values.

Any non-numeric columns in the dataframe would be ignored.

The function ignores NA values within the columns.
}
\usage{
get_quartiles(data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
%%     ~~Describe \code{x} here~~
The dataframe you want to get the quartiles of.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
Returns a dataframe with the three quartile values of each numeric column in the data and the interquartile range values.
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
get_quartiles(iris)
}
_______________________________________________________________________
