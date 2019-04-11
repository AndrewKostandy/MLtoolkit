get_prop2 <- function(data, predictor1, predictor2, outcome){

  predictor1 <- dplyr::enquo(predictor1)
  predictor2 <- dplyr::enquo(predictor2)
  outcome <- dplyr::enquo(outcome)

  if (!is.factor(dplyr::pull(data, !!predictor1)))
    data <- dplyr::mutate(data, !!predictor1 := factor(!!predictor1))

  if (anyNA(dplyr::pull(data, !!predictor1)))
    data <- dplyr::mutate(data, !!predictor1 := forcats::fct_explicit_na(!!predictor1, na_level = "NA"))

  if (!is.factor(dplyr::pull(data, !!predictor2)))
    data <- dplyr::mutate(data, !!predictor2 := factor(!!predictor2))

  if (anyNA(dplyr::pull(data, !!predictor1)))
    data <- dplyr::mutate(data, !!predictor2 := forcats::fct_explicit_na(!!predictor2, na_level = "NA"))

  if (!is.factor(dplyr::pull(data, !!outcome)))
    data <- dplyr::mutate(data, !!outcome := factor(!!outcome))

  if (anyNA(dplyr::pull(data, !!outcome)))
    data <- dplyr::mutate(data, !!outcome := forcats::fct_explicit_na(!!outcome, na_level = "NA"))

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
