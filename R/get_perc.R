get_perc <- function(data) {
  data <- dplyr::select_if(data, is.numeric)

  percentiles <- data %>% furrr::future_map_dfc(~ quantile(.x, probs = c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm = TRUE))
  iqr <- data %>% furrr::future_map_dfc(~ IQR(.x, na.rm = TRUE))

  key <- tibble::tibble(Key = c("Perc 1", "Perc 25", "Perc 50", "Perc 75", "Perc 99", "IQR"))

  percentiles <- dplyr::bind_rows(percentiles, iqr)
  percentiles <- dplyr::bind_cols(key, percentiles)
  return(percentiles)
}
