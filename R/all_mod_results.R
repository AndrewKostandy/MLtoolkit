library(tidyverse)

all_mod_results <- function(mod_list, mod_names){

  all_results <- map2_dfr(mod_list, mod_names, create_mod_results)

  return(all_results)
}
