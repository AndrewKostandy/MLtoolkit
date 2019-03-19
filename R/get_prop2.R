get_prop2 <- function(data, predictor1, predictor2, outcome){

  predictor1 <- dplyr::enquo(predictor1)
  predictor2 <- dplyr::enquo(predictor2)
  outcome <- dplyr::enquo(outcome)

  data <- data %>%
    dplyr::group_by(!!predictor1, !!predictor2) %>%
    dplyr::count(!!outcome) %>%
    dplyr::mutate(sum_n = sum(n),
                  prop = n / sum_n) %>%
    dplyr::group_by(!!predictor1, !!predictor2, !!outcome) %>%
    dplyr::mutate(low_95ci = prop.test(x = n, n = sum_n)$conf.int[1],
                  high_95ci = prop.test(x = n, n = sum_n)$conf.int[2]) %>%
    dplyr::ungroup()

  return(data)
}
