library(mltools)
library(InformationValue)
library(MLmetrics)
library(tidyverse)
library(caret)

compute_mod_results <- function(mod_object, mod_name = NULL) {
  if (is.null(mod_name)) {
    stop("Please provide a name for the model.")
  }

  results <- mod_object$pred

  if (is.factor(results$obs)) {
    colnames(results)[5] <- "Y"
    results <- mutate(results, actual = as.numeric(obs), actual = ifelse(actual == 2, 0, actual))

    results <- results %>%
      group_by(Resample) %>%
      summarize(
        AUROC = InformationValue::AUROC(actual, Y),
        Sensitivity = InformationValue::sensitivity(actuals = actual, predictedScores = Y),
        Specificity = InformationValue::specificity(actuals = actual, predictedScores = Y),
        `AUPRC` = MLmetrics::PRAUC(y_pred = Y, y_true = actual),
        Precision = InformationValue::precision(actuals = actual, predictedScores = Y),
        `Log Loss` = MLmetrics::LogLoss(y_pred = Y, y_true = actual),
        Accuracy = caret::postResample(pred = pred, obs = obs)[1],
        `Cohen's Kappa` = caret::postResample(pred = pred, obs = obs)[2],
        `F1 Score` = 2 * ((Precision * Sensitivity) / (Precision + Sensitivity)),
        `Matthews Corr. Coeff.` = mltools::mcc(preds = pred, actuals = obs),
        Concordance = InformationValue::Concordance(actuals = actual, predictedScores = Y)[[1]],
        Discordance = InformationValue::Concordance(actuals = actual, predictedScores = Y)[[2]],
        `Somer's D` = InformationValue::somersD(actuals = actual, predictedScores = Y),
        `KS Statistic` = InformationValue::ks_stat(actuals = actual, predictedScores = Y)
      )
  } else {
    if (any(results$obs == 0)) {
      results <- results %>%
        group_by(Resample) %>%
        summarize(
          RMSE = caret::RMSE(pred = pred, obs = obs),
          R2 = caret::R2(pred = pred, obs = obs),
          MAE = caret::MAE(pred = pred, obs = obs)
        )
    } else {
      results <- results %>%
        group_by(Resample) %>%
        summarize(
          RMSE = caret::RMSE(pred = pred, obs = obs),
          R2 = caret::R2(pred = pred, obs = obs),
          MAE = caret::MAE(pred = pred, obs = obs),
          MAPE = mean(abs((obs - pred) / obs)) * 100
        )
    }
  }

  results <- results %>% mutate(Model = mod_name) %>% select(Model, Resample, everything())
  return(results)
}
