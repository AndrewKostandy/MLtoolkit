\name{plot_pred_improve}
\alias{plot_pred_improve}
\title{
Plot the Model Performance Improvement of Each Predictor Relative to the Null Model
}
\description{
Plot the model performance improvement of each predictor relative to the null model. If the outcome is categorical, then a logisitic regression model is used and the area under the ROC curve is used to assess performance. If the outcome is numeric, then an ordinary least squares model is used and the root mean squared error (RMSE) is used to assess performance.

The results are estimated across resamples and the p-value is determined using a one-sided paired t-test of the predictor results and the null model results in each case. The p-values are adjusted using the Benjamini-Hochberg method to control the false discovery rate.
}
\usage{
plot_pred_improve(data, outcome, seed, folds = 10, repeats = 3)
}
\arguments{
  \item{data}{
    The dataframe containing the predictors and the outcome.
}
  \item{outcome}{
    The outcome variable name.
}
  \item{seed}{
    A numeric seed for reproducibility. L'Ecuyer-CMRG is used as the RNG kind.
}
  \item{folds}{
    Defaults to 10. The number of folds to use with repeated cross-validation.
}
  \item{repeats}{
    Defaults to 3. The number of repeats to use with repeated cross-validation.
}
}
\value{
Returns a ggplot object with the improvement value on the x-axis and the negative log10 of the adjusted p-value on the y-axis.

A vertical dashed red line marks the 0 improvement level on the x-axis while a horizontal dashed red line marks the 0.05 p-value level after adjustment.
}
\section{Figures}{
\if{html}{\figure{plot_pred_improve_1.svg}{options: width=100\%}}
}
\references{
This technique was discussed in the book Feature Engineering and Selection: A Practical Approach for Predictive Models by Max Kuhn and Kjell Johnson.
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
library(tidyverse)
library(mlbench)

data(BreastCancer)
dat <- BreastCancer \%>\% select(-Id)

dat <- dat \%>\% modify_at(c(1:9), as.numeric) \%>\% mutate(Class = fct_rev(Class))

plot_pred_improve(data = dat, outcome = Class,
                  seed = 42, folds = 10, repeats = 3)
}
