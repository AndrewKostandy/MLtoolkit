library(tidyverse)

trim_df <- function(data, type, perc = NULL){

  data <- select_if(data, is.numeric)

  if (is.null(perc)){
    perc <- get_perc(data = data)
  }

  if(type=="iqr"){

    trim_action_iqr <- function(x, y, perc){

      perc25 <- perc %>% select(y) %>% slice(2) %>% pull()
      perc75 <- perc %>% select(y) %>% slice(4) %>% pull()
      iqr <- perc %>% select(y) %>% slice(6) %>% pull()

      x <- ifelse(x<perc25-(1.5*iqr), perc25-(1.5*iqr), x)
      x <- ifelse(x>perc75+(1.5*iqr), perc75+(1.5*iqr), x)

      return(x)
    }

    data <- data %>% imap_dfr(trim_action_iqr, perc)
  }

  else if (type=="1_99"){

    trim_action_199 <- function(x, y, perc){

      perc1 <- perc %>% select(y) %>% slice(1) %>% pull()
      perc99 <- perc %>% select(y) %>% slice(5) %>% pull()

      x <- ifelse(x<perc1, perc1, x)
      x <- ifelse(x>perc99, perc99, x)

      return(x)
    }

    data <- data %>% imap_dfr(trim_action199, perc)

  }

  else
    stop("The type argument must be either \"iqr\" or \"1_99\".")

  return(data)
}
