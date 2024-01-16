# FAIRE TOURNER SUR AUS

library(dplyr)
library(rtauargus)

loc_tauargus <- "Y:/Logiciels/TauArgus/TauArgus4.2.3/TauArgus.exe"
options(rtauargus.tauargus_exe = loc_tauargus)

data("turnover_act_size")

turnover_act_size_detect <-  turnover_act_size %>%
  rename(FREQ = N_OBS, VALUE = TOT) %>% 
  mutate(
    is_secret_freq = FREQ > 0 & FREQ < 3,
    is_secret_dom = (VALUE != 0) & (MAX > 0.85*VALUE)
  ) %>% 
  mutate(
    is_secret_prim = is_secret_freq | is_secret_dom
  )

turnover_act_size_ns <- turnover_act_size_detect %>%
  mutate(cost = ifelse(SIZE == "tr1", 1, VALUE))
str(turnover_act_size_ns)

res_ns <- tab_rtauargus(
  turnover_act_size_ns,
  files_name = "couts",
  dir_name = "tauargus_files/couts",
  explanatory_vars = c("ACTIVITY","SIZE"),
  totcode = c("Total","Total"),
  freq = "FREQ",
  value = "VALUE",
  secret_var = "is_secret_prim",
  cost_var = "cost",
  verbose = FALSE
)

saveRDS(res_ns,"tauargus_files/couts/res_ns.rds")

synthese_ns <- res_ns %>% group_by(Status) %>%
  mutate(
    statut_final = case_when(
      is_secret_freq ~ "A",
      is_secret_dom ~ "B",
      TRUE ~ Status,
    )
  ) %>% 
  group_by(statut_final) %>% 
  summarise(
    nb_cellules = n(),
    effectif = sum(FREQ),
    valeur = sum(VALUE)
  )
synthese_ns

