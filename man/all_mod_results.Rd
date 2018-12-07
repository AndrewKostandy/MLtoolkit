\name{all_mod_results}
\alias{all_mod_results}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Compute Performance Metrics of Multiple Caret Model Object Across Resamples
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function allows you to compute various types of performance metrics across resamples for multiple binary classification or regression models from the caret package.

The metrics computed for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

The metrics computed for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE).
}
\usage{
all_mod_results(mod_list, mod_names)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mod_list}{
%%     ~~Describe \code{x} here~~
A list of caret model objects.
}
\item{mod_names}{
%%     ~~Describe \code{x} here~~
A vector or list of names for the models.
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
Returns a tibble with the performance metrics of the model objects across resamples.
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
train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
                           summaryFunction = defaultSummary,
                           savePredictions = "final")

lm_fit_1 <- train(Sepal.Length ~ Sepal.Width, data = iris,
                  method = "lm",
                  metric = "RMSE",
                  trControl = train_ctrl)

lm_fit_2 <- train(Sepal.Length ~ Sepal.Width + Petal.Length, data = iris,
                  method = "lm",
                  metric = "RMSE",
                  trControl = train_ctrl)

lm_fit_3 <- train(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data = iris,
                  method = "lm",
                  metric = "RMSE",
                  trControl = train_ctrl)

all_mod_results(list(lm_fit_1, lm_fit_2, lm_fit_3), c("LM 1", "LM 2", "LM 3"))
}
_______________________________________________________________________
