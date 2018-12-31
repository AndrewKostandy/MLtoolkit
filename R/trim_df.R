trim_df <- function(data, type, perc = NULL) {
  data <- dplyr::select_if(data, is.numeric)

  if (is.null(perc)) {
    perc <- get_perc(data = data)
  }

  if (type == "iqr") {
    trim_action_iqr <- function(x, y, perc) {
      perc25 <- perc %>% dplyr::select(y) %>% dplyr::slice(2) %>% dplyr::pull()
      perc75 <- perc %>% dplyr::select(y) %>% dplyr::slice(4) %>% dplyr::pull()
      iqr <- perc %>% dplyr::select(y) %>% dplyr::slice(6) %>% dplyr::pull()

      x <- ifelse(x < perc25 - (1.5 * iqr), perc25 - (1.5 * iqr), x)
      x <- ifelse(x > perc75 + (1.5 * iqr), perc75 + (1.5 * iqr), x)
    }
    data <- data %>% furrr::future_imap_dfr(trim_action_iqr, perc)
  } else if (type == "1_99") {
    trim_action_199 <- function(x, y, perc) {
      perc1 <- perc %>% dplyr::select(y) %>% dplyr::slice(1) %>% dplyr::pull()
      perc99 <- perc %>% dplyr::select(y) %>% dplyr::slice(5) %>% dplyr::pull()

      x <- ifelse(x < perc1, perc1, x)
      x <- ifelse(x > perc99, perc99, x)
    }
    data <- data %>% furrr::future_imap_dfr(trim_action199, perc)
  } else {
    stop("The type argument must be either \"iqr\" or \"1_99\".")
  }
  return(data)
}
