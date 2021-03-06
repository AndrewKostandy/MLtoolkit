\name{plot_prop}
\alias{plot_prop}
\title{
Plot the Proportion of Each Predictor Level Having a Specific Outcome Level
}
\description{
Plot the proportion of each predictor level having a specific outcome level and the 95\% confidence interval of the proportion.
}
\usage{
  plot_prop(data, predictor, outcome, ref_level, ref_value = 0.5,
            add_n = TRUE, width = 0)
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
}
\value{
Returns a ggplot object with the predictor levels on the x-axis and the proportion of values in the ref_level of the outcome on the y-axis.
}
\section{Figures}{
\if{html}{\figure{plot_prop_1.svg}{options: width=100\%}}
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
diamonds2 <- diamonds \%>\%
  mutate(cut = fct_collapse(cut,
                            `>= Premium` = c("Premium", "Ideal"),
                            `<= Very Good` = c("Very Good", "Good",
                                               "Fair")))

plot_prop(diamonds2, clarity, cut, ref_level = ">= Premium",
          ref_value = 0.5, add_n = TRUE, width = 0)
}

