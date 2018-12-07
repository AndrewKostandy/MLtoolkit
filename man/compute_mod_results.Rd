\name{compute_mod_results}
\alias{compute_mod_results}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Compute Performance Metrics of a Caret Model Object Across Resamples
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function allows you to compute various types of performance metrics across resamples for a binary classification or regression model from the caret package.

The metrics computed for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

The metrics computed for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE).
}
\usage{
compute_mod_results(mod_object, mod_name)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mod_object}{
%%     ~~Describe \code{x} here~~
A caret model object.
}
\item{mod_name}{
%%     ~~Describe \code{x} here~~
A name for the model.
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
Returns a tibble with the the results of the model object across resamples.
}
\references{
%% ~put references to the literature/web site here ~
The "InformationValue", "caret", and "mltools" packages were used to compute many of the metrics.
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
library(caret)

train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
                           summaryFunction = defaultSummary,
                           savePredictions = "final")

lm_fit_1 <- train(Sepal.Length ~ Sepal.Width, data = iris,
                  method = "lm",
                  metric = "RMSE",
                  trControl = train_ctrl)

compute_mod_results(lm_fit_1, "LM 1")
}
_______________________________________________________________________
