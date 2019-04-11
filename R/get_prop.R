get_prop <- function(data, predictor, outcome){

  predictor <- dplyr::enquo(predictor)
  outcome <- dplyr::enquo(outcome)

  if (!is.factor(dplyr::pull(data, !!predictor)))
    data <- dplyr::mutate(data, !!predictor := factor(!!predictor))

  if (anyNA(dplyr::pull(data, !!predictor)))
    data <- dplyr::mutate(data, !!predictor := forcats::fct_explicit_na(!!predictor, na_level = "NA"))

  if (!is.factor(dplyr::pull(data, !!outcome)))
    data <- dplyr::mutate(data, !!outcome := factor(!!outcome))

  if (anyNA(dplyr::pull(data, !!outcome)))
    data <- dplyr::mutate(data, !!outcome := forcats::fct_explicit_na(!!outcome, na_level = "NA"))

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
