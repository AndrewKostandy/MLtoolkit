\name{get_prop}
\alias{get_prop}
\title{
Get the Proportion of Each Predictor Level Having Each Outcome Level
}
\description{
Get the proportion of each predictor level having each outcome level as well as the lower and higher ends of the 95\% confidence interval of the proportion.
}
\usage{
get_prop(data, predictor, outcome)
}
\arguments{
  \item{data}{
    The dataframe containing the predictor and outcome variables.
  }
  \item{predictor}{
    The predictor variable name.
  }
  \item{outcome}{
    The outcome variable name.
  }
}
\value{
Returns a dataframe that includes the following columns:
  \item{predictor}{
    The predictor variable levels.
  }
  \item{outcome}{
    The outcome variable levels.
  }
  \item{n}{
    The number of observations for each combination of levels of the predictor and the outcome.
  }
  \item{sum_n}{
    The total number of observations for each level of the predictor.
  }
  \item{prop}{
    The proportion of each predictor level associated with each outcome level.
  }
  \item{low_95ci}{
    The lower end of the 95\% confidence interval of the proportion.
  }
  \item{high_95ci}{
    The upper end of the 95\% confidence interval of the proportion.
  }
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
get_prop(diamonds, clarity, cut)
}
