plot_prop <- function(data, predictor, outcome, ref_level, ref_value = 0.5, add_n = TRUE){

  predictor <- dplyr::enquo(predictor)
  outcome <- dplyr::enquo(outcome)

  label_x <- rlang::quo_text(predictor)
  label_x <- stringr::str_to_title(label_x)

  results <- get_prop(data, !!predictor, !!outcome)

  results <- dplyr::filter(results, !!outcome == ref_level)

  if (isTRUE(add_n)){
  results <- results %>%
    mutate(sum_n = str_c("(n=",sum_n),
           sum_n = str_c(sum_n, ")")) %>%
    unite(!!predictor, !!predictor, sum_n, sep = "\n", remove = FALSE)
  }

  ggplot2::ggplot(results, aes(!!predictor, prop, ymin = low_95ci, ymax = high_95ci)) + # !!predictor
    ggplot2::geom_point() +
    ggplot2::geom_errorbar(width = 0.8) +
    ggplot2::geom_hline(yintercept = ref_value, color = "red", linetype = "dashed") +
    ggplot2::labs(x = label_x,
                  y = paste0("Proportion of ", ref_level)) +
    ggplot2::theme_light()
}
