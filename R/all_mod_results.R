all_mod_results <- function(mod_list, mod_names) {
  all_results <- purrr::map2_dfr(mod_list, mod_names, compute_mod_results)
  return(all_results)
}
