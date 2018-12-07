library(tidyverse)

get_quartiles <- function(data){

  data <- select_if(data, is.numeric)

  quart1 <- data %>% map_dfc(~quantile(.x, probs = 0.25, na.rm = TRUE))
  quart2 <- data %>% map_dfc(~quantile(.x, probs = 0.50, na.rm = TRUE))
  quart3 <- data %>% map_dfc(~quantile(.x, probs = 0.75, na.rm = TRUE))
  iqr <- data %>% map_dfc(~IQR(.x, na.rm = TRUE))

  quartiles <- tibble(Key = c("Quartile 1", "Quartile 2", "Quartile 3", "IQR"))
  quartiles <- bind_cols(quartiles, bind_rows(quart1, quart2, quart3, iqr))

  return(quartiles)
}
