pred_improve <- function(data, outcome, seed, folds = 10, repeats = 3){

  outcome_var <- dplyr::enquo(outcome)

  outcome_values <- dplyr::pull(data, !!outcome_var)

  set.seed(seed, kind = "L'Ecuyer-CMRG")
  id <- caret::createMultiFolds(outcome_values, k = folds, times = repeats)

  if(is.factor(outcome_values) & length(unique(outcome_values)) == 2){

    categorical <- TRUE

    method <- "glm"
    metric <- "ROC"
    train_ctrl <- caret::trainControl(method = "repeatedcv",
                                      number = folds,
                                      repeats = repeats,
                                      index = id,
                                      summaryFunction = caret::twoClassSummary,
                                      classProbs = TRUE,
                                      savePredictions = "final")
    predictors_null <- data[,-ncol(data)]
    null_mod <- caret::train(predictors_null, outcome_values,
                             method = "null",
                             metric = metric,
                             trControl = train_ctrl)

    null_results <- dplyr::select(null_mod$pred, -rowIndex)

    resample_loc <- which(colnames(null_results) == "Resample")
    null_results <- dplyr::select(null_results, obs, pred, resample_loc-2, resample_loc-1, Resample)
    colnames(null_results)[3] <- "Y"
    null_results <- dplyr::mutate(null_results,
                                  actual = as.numeric(obs),
                                  actual = ifelse(actual == 2, 0, actual))

    null_results <- null_results %>%
      dplyr::group_by(Resample) %>%
      dplyr::summarize(AUROC = InformationValue::AUROC(actual, Y)) %>%
      dplyr::ungroup() %>%
      dplyr::pull(AUROC)

  } else if(is.numeric(outcome_values)){

    method <- "lm"
    metric <- "RMSE"
    train_ctrl <- caret::trainControl(method = "repeatedcv",
                                      number = folds,
                                      repeats = repeats,
                                      index = id,
                                      summaryFunction = caret::defaultSummary,
                                      savePredictions = "final")

    null_preds <- numeric(length(id))
    null_resample <- character(length(id))
    null_rmse <- numeric(length(id))

    for (i in 1:length(id)){

      null_preds[i] <- mean(outcome_values[unlist(id[i])], na.rm = TRUE)
      null_resample[i] <- names(id[i])
      null_rmse[i] <- caret::RMSE(pred = null_preds[i], obs = outcome_values[-unlist(id[i])])

    }
    null_results <- dplyr::data_frame(Resample = null_resample, RMSE = null_rmse) %>%
      dplyr::arrange(Resample) %>%
      dplyr::pull(RMSE)

  } else
      stop("Outcome must be either a factor with 2 unique values or a numeric.")

  single_pred_improve <- function(pred, pred_name) {

    pred_df <- data.frame(pred)

    pred_mod <- caret::train(pred_df, outcome_values,
                             method = method,
                             metric = metric,
                             trControl = train_ctrl)

    pred_results <- pred_mod$pred %>% dplyr::select(-rowIndex)

    if (is.factor(pred_results$obs)) {
      resample_loc <- which(colnames(pred_results) == "Resample")
      pred_results <- dplyr::select(pred_results, obs, pred, resample_loc-2, resample_loc-1, Resample)
      colnames(pred_results)[3] <- "Y"
      pred_results <- dplyr::mutate(pred_results,
                                    actual = as.numeric(obs),
                                    actual = ifelse(actual == 2, 0, actual))

      pred_results <- pred_results %>%
        dplyr::group_by(Resample) %>%
        dplyr::summarize(AUROC = InformationValue::AUROC(actual, Y)) %>%
        dplyr::ungroup()

      pred_results <- dplyr::pull(pred_results, AUROC)
      t_test_res <- t.test(pred_results, null_results, alternative = "greater", paired = TRUE)

      improve_results <- dplyr::data_frame(predictor = pred_name,
                                           improvement = t_test_res$estimate,
                                           significance = t_test_res$p.value)

    } else{

      pred_results <- pred_results %>%
        dplyr::group_by(Resample) %>%
        dplyr::summarize(RMSE = caret::RMSE(pred = pred, obs = obs)) %>%
        dplyr::ungroup()

      pred_results <- dplyr::pull(pred_results, RMSE)
      t_test_res <- t.test(pred_results, null_results, alternative = "less", paired = TRUE)

      improve_results <- dplyr::data_frame(predictor = pred_name,
                                           improvement = -t_test_res$estimate,
                                           significance = t_test_res$p.value)

    }
    return(improve_results)
  }

  all_improve_results <- furrr::future_imap_dfr(select(data, -!!outcome_var), single_pred_improve) %>%
    dplyr::mutate(significance = p.adjust(significance, method = "bonferroni")) %>%
    dplyr::arrange(dplyr::desc(improvement), significance)

  if (isTRUE(categorical))
    all_improve_results <- rename(all_improve_results, "auroc_improvement" = "improvement")
  else
    all_improve_results <- rename(all_improve_results, "rmse_improvement" = "improvement")

  return(all_improve_results)
}
