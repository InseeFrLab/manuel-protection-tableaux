# FAIRE TOURNER SUR AUS

library(dplyr)
library(rtauargus)

loc_tauargus <- "Y:/Logiciels/TauArgus/TauArgus4.2.3/TauArgus.exe"
options(rtauargus.tauargus_exe = loc_tauargus)


T0 <- turnover_act_size %>% rename(FREQ = N_OBS, VALUE = TOT)

T0_detect <- T0 %>% 
  mutate(
    is_secret_freq = FREQ > 0 & FREQ < 3,
    is_secret_dom = (VALUE != 0) & (MAX > 0.85*VALUE)
  ) %>% 
  mutate(
    is_secret_prim = is_secret_freq | is_secret_dom
  )

T0_masq <- tab_rtauargus(
  T0_detect,
  dir_name = "tauargus_files/ex_T0",
  files_name = "T0",
  explanatory_vars = c("ACTIVITY","SIZE"),
  secret_var = "is_secret_prim",
  value = "VALUE",
  freq = "FREQ",
  totcode = c(ACTIVITY="Total",SIZE="Total"),
  verbose = FALSE
)

saveRDS(T0_masq,"tauargus_files/ex_T0/T0_masq.rds")






