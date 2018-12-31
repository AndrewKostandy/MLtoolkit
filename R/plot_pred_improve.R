plot_pred_improve <- function(data, outcome, seed, folds = 10, repeats = 3){

  outcome <- enquo(outcome)

  if(is.factor(dplyr::pull(data, !!outcome)))
    x_label <- "AUROC Improvement"
  else
    x_label <- "RMSE Improvement"

  res <- pred_improve(data, !!outcome, seed, folds, repeats)
  names(res)[2] <- "improvement"

  ggplot2::ggplot(res, aes(x = improvement, y = -log10(significance), label = predictor)) +
    ggplot2::geom_point() +
    ggplot2::labs(x = x_label,
                  y = expression(-log[10](Pvalue))) +
    ggplot2::geom_vline(xintercept = 0, color = "red", linetype = "dashed") +
    ggplot2::geom_hline(yintercept = -log10(0.05), color = "red", linetype = "dashed") +
    ggrepel::geom_text_repel() +
    ggplot2::theme_light()

}
