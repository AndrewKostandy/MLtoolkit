library(tidyverse)

plot_mod_results <- function(data, mod_names = NULL, plot_columns = NULL, plot_rows = NULL){

  if (class(data)[1] == "list"){

    if (is.null(mod_names))
      stop("Please provide the model names.")


    data <- all_mod_results(data, mod_names)
  }

  if ("Resample" %in% colnames(data))
    data <- select(data, -Resample)

  data <- gather(data, Metric, Value, -Model)
  data$Metric <- fct_inorder(data$Metric)

  ggplot(data, aes(Model, Value)) + geom_boxplot() +
    facet_wrap(~Metric, scales = "free_y", ncol = plot_columns, nrow = plot_rows) +
    stat_summary(fun.y = "mean", geom = "point", shape = 23, fill = "red") +
    labs(title="Model Performance Comparison") +
    theme_light() +
    theme(axis.title.x = element_blank())

}
