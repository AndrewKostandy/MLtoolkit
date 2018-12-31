plot_prop <- function(data, predictor, outcome, ref_level, ref_value = 0.5){

  predictor <- dplyr::enquo(predictor)
  outcome <- dplyr::enquo(outcome)

  label_x <- rlang::quo_text(predictor)

  results <- get_prop(data, !!predictor, !!outcome)

  results <- dplyr::filter(results, !!outcome == ref_level)

  ggplot2::ggplot(results, aes(!!predictor, prop, ymin = low_95ci, ymax = high_95ci)) +
    ggplot2::geom_point() +
    ggplot2::geom_errorbar(width = 0.8) +
    ggplot2::geom_hline(yintercept = ref_value, color = "red", linetype = "dashed") +
    ggplot2::labs(x = stringr::str_to_title(label_x),
                  y = paste0("Proportion of ", ref_level)) +
    ggplot2::theme_light()
}
