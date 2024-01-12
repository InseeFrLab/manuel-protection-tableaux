# FAIRE TOURNER SUR AUS

library(dplyr)
library(rtauargus)

loc_tauargus <- "Y:/Logiciels/TauArgus/TauArgus4.2.3/TauArgus.exe"
options(rtauargus.tauargus_exe = loc_tauargus)

data("turnover_act_size")
data("turnover_act_cj")
data("turnover_nuts_size")
data("turnover_nuts_cj")

str(turnover_act_size)
str(turnover_act_cj)
str(turnover_nuts_size)
str(turnover_nuts_cj)

data("activity_corr_table")
data("nuts23_fr_corr_table")

act_hrc_file <- write_hrc2(activity_corr_table, 
                           file_name = "tauargus_files/hrc/activity.hrc")

nuts_hrc_file <- write_hrc2(nuts23_fr_corr_table, 
                           file_name = "tauargus_files/hrc/nuts23.hrc")

liste_4tabs <- list(
  act_size = turnover_act_size,
  act_cj = turnover_act_cj,
  nuts_size = turnover_nuts_size,
  nuts_cj = turnover_nuts_cj
)
str(liste_4tabs)

liste_vars_4tabs <- purrr::map(
  liste_4tabs,
  function(data) colnames(data)[1:2]
)
str(liste_vars_4tabs)

liste_4tabs <- liste_4tabs %>%
  purrr::map(
    function(df){
      df %>%
        mutate(
          is_secret_freq = N_OBS > 0 & N_OBS < 3,
          is_secret_dom = (MAX != 0) & (MAX > TOT*0.85),
          is_secret_prim = is_secret_freq | is_secret_dom
        )
    }
  )
str(liste_4tabs)

liste_4tabs %>% purrr::walk(function(tab) count(tab, is_secret_prim) %>% print())

masq_4tabs <- tab_multi_manager(
  list_tables = liste_4tabs,
  list_explanatory_vars = liste_vars_4tabs,
  dir_name = "tauargus_files/4tabs",
  hrc = list(ACTIVITY = act_hrc_file, NUTS = nuts_hrc_file),
  totcode = "Total",
  value = "TOT",
  freq = "N_OBS",
  secret_var = "is_secret_prim"
)

saveRDS(masq_4tabs,"tauargus_files/4tabs/masq_4tabs.rds")