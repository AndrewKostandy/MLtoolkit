all_mod_results <- function(mod_list, mod_names) {

  all_results <- furrr::future_map2_dfr(mod_list, mod_names, compute_mod_results)

  return(all_results)
}
