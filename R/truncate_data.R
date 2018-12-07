library(tidyverse)

truncate_data <- function(data, quartiles=NULL){

  data <- select_if(data, is.numeric)

  truncate_action <- function(x, y, quartiles){

    quart1 <- quartiles %>% select(y) %>% slice(1) %>% pull()
    quart3 <- quartiles %>% select(y) %>% slice(3) %>% pull()
    iqr <- quartiles %>% select(y) %>% slice(4) %>% pull()

    x <- ifelse(x<quart1-(1.5*iqr), quart1-(1.5*iqr), x)
    x <- ifelse(x>quart3+(1.5*iqr), quart3+(1.5*iqr), x)

    return(x)
  }

  if (is.null(quartiles)){
    quartiles <- get_quartiles(data = data)
  }
  data <- data %>% imap_dfr(truncate_action, quartiles)

  return(data)
}
