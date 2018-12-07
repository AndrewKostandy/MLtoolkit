\name{plot_mod_results}
\alias{plot_mod_results}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Produce a Box Plot with the Performance Metrics of Multiple Caret Model Object Across Resamples.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function allows you to produce a boxplot of performance metrics across resamples for multiple binary classification or regression models from the caret package.

The metrics shown for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

The metrics shown for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE).
}
\usage{
plot_mod_results(data, mod_names = NULL, plot_columns = 3)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
%%     ~~Describe \code{x} here~~
This argument can be either of the below options:

1. A dataframe with the performance metrics of 1 or more models across resamples. The dataframe must contain the column "Model" containing the model name(s). The remaining columns in the dataframe would be the performance metrics where each metric is one column. In this option, the argument mod_names is not used.

2. A list of caret model objects. In this case, the argument mod_names is required.
}
\item{mod_names}{
%%     ~~Describe \code{x} here~~
Defaults to NULL. A vector or list of names for the models. This argument is required only if option 2 is used for the data argument. Otherwise, it is not used.
}
\item{plot_columns}{
%%     ~~Describe \code{x} here~~
Defaults to NULL. An integer providing the number of facet columns to have in the plot. NULL value would use the default settings of ggplot2's facet_wrap() function.
}
\item{plot_rows}{
%%     ~~Describe \code{x} here~~
Defaults to NULL. An integer providing the number of facet rows to have in the plot. NULL value would use the default settings of ggplot2's facet_wrap() function.
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
Returns a ggplot object with the box plot of performance metrics of the model objects across resamples.
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

plot_mod_results(list(lm_fit_1, lm_fit_2, lm_fit_3), c("LM 1", "LM 2", "LM 3"), plot_columns = 4)
}
