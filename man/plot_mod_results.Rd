\name{plot_mod_results}
\alias{plot_mod_results}
\title{
Produce a Box Plot with the Performance Metrics of Multiple Caret Model Object Across Resamples.
}
\description{
This function allows you to produce a boxplot of performance metrics across resamples for multiple binary classification or regression models from the caret package.

The metrics shown for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

The metrics shown for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE).
}
\usage{
plot_mod_results(data, mod_names = NULL,
                 plot_cols = NULL, plot_rows = NULL,
                 conf_int95 = FALSE)
}
\arguments{
  \item{data}{
This argument can be either of the below options:

1. A dataframe with the performance metrics of one or more models across resamples. The dataframe must contain the column "Model" containing the model name(s). The remaining columns in the dataframe would be the performance metrics where each metric is one column. In this option, the argument mod_names is not used.

2. A list of caret model objects. In this case, the argument mod_names is required.
}
\item{mod_names}{
Defaults to NULL. A vector or list of names for the models. This argument is required only if option 2 is used for the data argument. Otherwise, it is not used.
}
\item{plot_cols}{
Defaults to NULL. An integer providing the number of facet columns to have in the plot. NULL value would use the default settings of ggplot2's facet_wrap() function.
}
\item{plot_rows}{
Defaults to NULL. An integer providing the number of facet rows to have in the plot. NULL value would use the default settings of ggplot2's facet_wrap() function.
}
\item{conf_int95}{
Defaults to FALSE. A logical indicating whether the plot should add errorbars representing the 95\% confidence interval of the mean.
}
}
\value{
Returns a ggplot object with the box plot of performance metrics of the model objects across resamples.
}
\section{Figures}{
\if{html}{\figure{plot_mod_results_1.svg}{options: width=100\%}}
}
\references{
The "InformationValue", "caret", and "mltools" packages were used to compute many of the metrics.
}
\author{
Andrew Kostandy (andrew.kostandy@gmail.com)
}
\examples{
train_ctrl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 4,
                           summaryFunction = defaultSummary,
                           savePredictions = "final")

lm_fit_1 <- train(Sepal.Length ~ Sepal.Width,
                  data = iris,
                  method = "lm",
                  metric = "RMSE",
                  trControl = train_ctrl)

lm_fit_2 <- train(Sepal.Length ~ Sepal.Width + Petal.Length,
                  data = iris,
                  method = "lm",
                  metric = "RMSE",
                  trControl = train_ctrl)

plot_mod_results(list(lm_fit_1, lm_fit_2), c("LM 1", "LM 2"))
}
_______________________________________________________________________
