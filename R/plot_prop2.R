plot_prop2 <- function(data, predictor1, predictor2, outcome, ref_level, ref_value = 0.5,
                       add_n = FALSE, width = 0, flip = FALSE){

  predictor1 <- dplyr::enquo(predictor1)
  predictor2 <- dplyr::enquo(predictor2)
  outcome <- dplyr::enquo(outcome)

  label_x <- rlang::quo_text(predictor1)
  label_x <- stringr::str_to_title(label_x)

  label_y <- paste0(rlang::quo_text(outcome),": ", ref_level)
  label_y <- stringr::str_to_title(label_y)
  label_y <- paste0("Proportion of ", label_y)

  results <- get_prop2(data, !!predictor1, !!predictor2, !!outcome)

  results <- dplyr::filter(results, !!outcome == ref_level)

  if (isTRUE(add_n)){
    results <- results %>%
      mutate(sum_n = str_c("(n=",sum_n),
             sum_n = str_c(sum_n, ")"))
  }

  g <- ggplot2::ggplot(results, aes(!!predictor1, prop, ymin = low_95ci, ymax = high_95ci,
                                    color = !!predictor2, shape = !!predictor2)) +
    ggplot2::geom_line(aes(group=!!predictor2)) +
    ggplot2::geom_point(size = 2.25) +
    ggplot2::geom_errorbar(width = width) +
    ggplot2::geom_hline(yintercept = ref_value, color = "red", linetype = "dashed") +
    ggplot2::labs(x = label_x,
                  y = label_y) +
    ggplot2::theme_light()

    if (isTRUE(add_n) & isFALSE(flip))
      g <- g + ggplot2::geom_text(aes(label = sum_n, !!predictor1, high_95ci), vjust=-0.7)
    else if(isTRUE(add_n) & isTRUE(flip)){
      g <- g +
           ggplot2::geom_text(aes(label = sum_n, !!predictor1, high_95ci), hjust=-0.1) +
           ggplot2::coord_flip()
    }
  g
}
