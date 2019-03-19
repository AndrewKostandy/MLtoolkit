\name{plot_prop2}
\alias{plot_prop2}
\title{
Plot the Proportion of Each Combination of Two Predictors' Levels Having a Specific Outcome Level
}
\description{
Plot the proportion of each combination of two predictors' levels having a specific outcome level and the 95\% confidence interval of the proportion. Useful for assessing the presence/effects of an interaction between categorical predictors on an outcome.
}
\usage{
  plot_prop2(data, predictor1, predictor2, outcome, ref_level,
             ref_value = 0.5, add_n = FALSE, width = 0, flip = FALSE)
}
\arguments{
  \item{data}{
    The dataframe containing the predictor and outcome variables.
  }
  \item{predictor1}{
    The first predictor variable name. This will be shown on the x-axis.
  }
  \item{predictor2}{
    The second predictor variable name. This will be identified by color and shape in the legend.
  }
  \item{outcome}{
    The outcome variable name.
  }
  \item{ref_level}{
    A string providing the specific outcome level to show the proportions for.
  }
  \item{ref_value}{
    Defaults to 0.5. A numeric providing the proportion value of interest to compare to.
  }
  \item{add_n}{
    Defaults to TRUE. A logical indicating whether to add the total number of observations of each level to the plot.
  }
  \item{width}{
    Defaults to 0. A numeric providing the width of the error bars.
  }
  \item{flip}{
    Defaults to FALSE. A logical indicating whether to flip the plot.
  }
}
\value{
Returns a ggplot object with the first predictor levels on the x-axis and the proportion of values in the ref_level of the outcome on the y-axis. The second predictor variable is identified by shape and color in the legend.
}
\section{Figures}{
\if{html}{\figure{plot_prop2_1.svg}{options: width=100\%}}
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
Titanic2 <- as.data.frame(Titanic)
Titanic2 <- Titanic2[rep(seq(1:nrow(Titanic2)), Titanic2$Freq), -5]

plot_prop2(Titanic2, Class, Sex, Survived, "Yes", ref_value = 0.323,
           add_n = FALSE, width = 0, flip = FALSE)
}
