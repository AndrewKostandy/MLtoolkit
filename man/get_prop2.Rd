\name{get_prop2}
\alias{get_prop2}
\title{
Get the Proportion of Each Combination of Two Predictors' Levels Having Each Outcome Level
}
\description{
Get the proportion of each combination of two predictors' levels having each outcome level as well as the lower and higher ends of the 95\% confidence interval of the proportion.
}
\usage{
get_prop2(data, predictor1, predictor2, outcome)
}
\arguments{
  \item{data}{
    The dataframe containing the predictor and outcome variables.
  }
  \item{predictor1}{
    The first predictor variable name.
  }
  \item{predictor2}{
    The second predictor variable name.
  }
  \item{outcome}{
    The outcome variable name.
  }
}
\value{
Returns a dataframe that includes the following columns:
  \item{predictor1}{
    The first predictor variable levels.
  }
  \item{predictor2}{
    The second predictor variable levels.
  }
  \item{outcome}{
    The outcome variable levels.
  }
  \item{n}{
    The number of observations for each combination of levels of both predictors and the outcome.
  }
  \item{sum_n}{
    The total number of observations for each combination of levels of both predictors.
  }
  \item{prop}{
    The proportion of each combination of both predictor levels having each outcome level.
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
Titanic2 <- as.data.frame(Titanic)
Titanic2 <- Titanic2[rep(seq(1:nrow(Titanic2)), Titanic2$Freq), -5]

get_prop2(Titanic2, Class, Sex, Survived)
}
