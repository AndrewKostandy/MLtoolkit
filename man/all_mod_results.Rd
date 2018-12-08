\name{all_mod_results}
\alias{all_mod_results}
\title{
Compute Performance Metrics of Multiple Caret Model Objects Across Resamples
}
\description{
This function allows you to compute various types of performance metrics across resamples for multiple binary classification or regression models from the caret package.

The metrics computed for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

The metrics computed for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE).
}
\usage{
all_mod_results(mod_list, mod_names)
}
\arguments{
  \item{mod_list}{
A list of caret model objects.
}
\item{mod_names}{
A vector or list of names for the models.
}
}
\value{
Returns a dataframe with the performance metrics of the model objects across resamples.
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
