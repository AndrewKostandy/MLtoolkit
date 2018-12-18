library(tidyverse)

get_perc <- function(data) {
  data <- select_if(data, is.numeric)

  percentiles <- data %>% map_dfc(~ quantile(.x, probs = c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm = TRUE))
  iqr <- data %>% map_dfc(~ IQR(.x, na.rm = TRUE))

  key <- data_frame(Key = c("Perc 1", "Perc 25", "Perc 50", "Perc 75", "Perc 99", "IQR"))

  percentiles <- bind_rows(percentiles, iqr)
  percentiles <- bind_cols(key, percentiles)
}
