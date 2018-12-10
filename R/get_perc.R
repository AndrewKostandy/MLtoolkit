library(tidyverse)

get_perc <- function(data){

  data <- select_if(data, is.numeric)

  perc1 <- data %>% map_dfc(~quantile(.x, probs = 0.01, na.rm = TRUE))
  perc25 <- data %>% map_dfc(~quantile(.x, probs = 0.25, na.rm = TRUE))
  perc50 <- data %>% map_dfc(~quantile(.x, probs = 0.50, na.rm = TRUE))
  perc75 <- data %>% map_dfc(~quantile(.x, probs = 0.75, na.rm = TRUE))
  perc99 <- data %>% map_dfc(~quantile(.x, probs = 0.99, na.rm = TRUE))
  iqr <- data %>% map_dfc(~IQR(.x, na.rm = TRUE))

  percentiles <- data_frame(Key = c("Percentile 1", "Percentile 25", "Percentile 50", "Percentile 75", "Percentile 99", "IQR"))
  percentiles <- bind_cols(percentiles, bind_rows(perc1, perc25, perc50, perc75, perc99, iqr))

  return(percentiles)
}
