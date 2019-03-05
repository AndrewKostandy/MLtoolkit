single_mod_results <- function(mod_object, mod_name = NULL) {
  if (is.null(mod_name)) {
    stop("Please provide a name for the model.")
  }

  results <- mod_object$pred %>% dplyr::select(-rowIndex)


  if (is.factor(results$obs)) {

    resample_loc <- which(colnames(results) == "Resample")
    results <- dplyr::select(results, obs, pred, resample_loc-2, resample_loc-1, Resample)
    colnames(results)[3] <- "Y"
    results <- dplyr::mutate(results,
                             obs_temp = as.numeric(obs),
                             obs2 = if_else(obs_temp == 2, 0, obs_temp),
                             pred_temp = as.numeric(pred),
                             pred2 = if_else(pred_temp == 2, 0, pred_temp))

    results <- results %>%
      dplyr::group_by(Resample) %>%
      dplyr::summarize(
        TN = as.numeric(table(obs2, pred2)[1]),
        FN = as.numeric(table(obs2, pred2)[2]),
        FP = as.numeric(table(obs2, pred2)[3]),
        TP = as.numeric(table(obs2, pred2)[4]),
        AUROC = InformationValue::AUROC(actuals = obs2, predictedScores = Y),
        Sensitivity = InformationValue::sensitivity(actuals = obs2, predictedScores = Y),
        Specificity = InformationValue::specificity(actuals = obs2, predictedScores = Y),
        AUPRC = MLmetrics::PRAUC(y_pred = Y, y_true = obs2),
        Precision = InformationValue::precision(actuals = obs2, predictedScores = Y),
        `F1 Score` = 2 * ((Precision * Sensitivity) / (Precision + Sensitivity)),
        Accuracy = MLmetrics::Accuracy(y_pred = pred2, y_true = obs2),
        `Cohen's Kappa` = caret::postResample(pred = pred, obs = obs)[2],
        `Log Loss` = MLmetrics::LogLoss(y_pred = Y, y_true = obs2),
        `Matthews Cor. Coef.` = (TP*TN-FP*FN) / sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)),
        Concordance = InformationValue::Concordance(actuals = obs2, predictedScores = Y)[[1]],
        Discordance = InformationValue::Concordance(actuals = obs2, predictedScores = Y)[[2]],
        `Somer's D` = InformationValue::somersD(actuals = obs2, predictedScores = Y),
        `KS Statistic` = InformationValue::ks_stat(actuals = obs2, predictedScores = Y),
        `False Discovery Rate` = 1 - Precision
      ) %>%
      dplyr::ungroup() %>%
      dplyr::select(-TN, -FN, -FP, -TP)
  } else {
    if (any(results$obs == 0)) {
      results <- results %>%
        dplyr::group_by(Resample) %>%
        dplyr::summarize(
          RMSE = caret::RMSE(pred = pred, obs = obs),
          MAE = caret::MAE(pred = pred, obs = obs),
          `Spearman's Rho` = cor(pred, obs, method = "spearman"),
          `Concordance Cor. Coef.` = (2*(cov(pred, obs) * (length(pred)-1)/length(pred))) /
            ((var(pred)*(length(pred)-1)/length(pred)) +
               (var(obs)* (length(obs)-1)/length(obs)) +
               (mean(pred) - mean(obs))^2),
          R2 = caret::R2(pred = pred, obs = obs)
        ) %>%
        dplyr::ungroup()
    } else {
      results <- results %>%
        dplyr::group_by(Resample) %>%
        dplyr::summarize(
          RMSE = caret::RMSE(pred = pred, obs = obs),
          MAE = caret::MAE(pred = pred, obs = obs),
          MAPE = mean(abs((obs - pred) / obs)) * 100,
          `Spearman's Rho` = cor(pred, obs, method = "spearman"),
          `Concordance Cor. Coef.` = (2*(cov(pred, obs) * (length(pred)-1)/length(pred))) /
            ((var(pred)*(length(pred)-1)/length(pred)) +
               (var(obs)* (length(obs)-1)/length(obs)) +
               (mean(pred) - mean(obs))^2),
          R2 = caret::R2(pred = pred, obs = obs)
        ) %>%
        dplyr::ungroup()
    }
  }

  results <- results %>%
    dplyr::mutate(Model = mod_name) %>%
    dplyr::select(Model, Resample, dplyr::everything())

  return(results)
}
