library(tidyverse)

plot_mod_results <- function(data, mod_names = NULL, plot_cols = NULL, plot_rows = NULL, conf_int95 = FALSE) {
  if (class(data)[1] == "list") {
    if (is.null(mod_names)) {
      stop("Please provide the model names.")
    }

    data <- all_mod_results(data, mod_names)
  }

  if ("Resample" %in% colnames(data)) {
    data <- select(data, -Resample)
  }

  data <- gather(data, Metric, Value, -Model)
  data$Metric <- fct_inorder(data$Metric)
  data$Model <- fct_inorder(data$Model)

  if (conf_int95 == FALSE) {
    ggplot(data, aes(Model, Value)) + geom_boxplot(fill = "lightgray") +
      facet_wrap(~Metric, scales = "free_y", ncol = plot_cols, nrow = plot_rows) +
      stat_summary(fun.y = "mean", geom = "point", shape = 23, fill = "red") +
      labs(title = "Model Performance Comparison") +
      theme_light() +
      theme(axis.title.x = element_blank())
  } else if (conf_int95 == TRUE) {
    ggplot(data, aes(Model, Value)) + geom_boxplot(fill = "lightgray") +
      facet_wrap(~Metric, scales = "free_y", ncol = plot_cols, nrow = plot_rows) +
      stat_summary(
        fun.data = mean_se, geom = "errorbar",
        color = "red", width = 0.33, fun.args = list(mult = 1.96)
      ) +
      stat_summary(fun.y = "mean", geom = "point", shape = 23, fill = "red") +
      labs(title = "Model Performance Comparison") +
      theme_light() +
      theme(axis.title.x = element_blank())
  } else {
    stop("The argument conf_int95 can take the values TRUE or FALSE only.")
  }
}
