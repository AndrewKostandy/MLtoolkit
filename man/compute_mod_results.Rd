\name{compute_mod_results}
\alias{compute_mod_results}
\title{
Compute Performance Metrics of a Single Caret Model Object Across Resamples
}
\description{
This function allows you to compute various types of performance metrics across resamples for a binary classification or regression model from the caret package.

The metrics computed for binary classification are: ROC, Sensitivity, Specificity, Precision, Accuracy, Cohen's Kappa, F1 Score, Matthews Correlation Coefficient, Concordance, Discordance, Somer's D, and KS Statistic.

The metrics computed for regression are: Root Mean Squared Error (RMSE), RSquared, Mean Absolute Error (MAE), and Mean Absolute Percentage Error (MAPE). Note that MAPE will not be provided if any observations equal zero to avoid division by zero.
}
\usage{
compute_mod_results(mod_object, mod_name)
}
\arguments{
  \item{mod_object}{
A caret model object.
}
\item{mod_name}{
A name for the model.
}
}
\value{
Returns a dataframe with the the performance metrics of the model object across resamples.
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

compute_mod_results(lm_fit_1, "LM 1")
}
_______________________________________________________________________
