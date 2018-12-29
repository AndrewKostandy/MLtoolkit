get_prop <- function(data, predictor, outcome){

  predictor <- dplyr::enquo(predictor)
  outcome <- dplyr::enquo(outcome)

  data <- data %>%
    dplyr::group_by(!!predictor) %>%
    dplyr::count(!!outcome) %>%
    dplyr::mutate(sum_n = sum(n),
                  prop = n / sum_n) %>%
    dplyr::group_by(!!predictor, !!outcome) %>%
    dplyr::mutate(low_95ci = prop.test(x = n, n = sum_n)$conf.int[1],
                  high_95ci = prop.test(x = n, n = sum_n)$conf.int[2]) %>%
    dplyr::ungroup()

  return(data)
}
