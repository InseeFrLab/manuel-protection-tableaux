# FAIRE TOURNER SUR AUS

library(dplyr)
library(rtauargus)

loc_tauargus <- "Y:/Logiciels/TauArgus/TauArgus4.2.3/TauArgus.exe"
options(rtauargus.tauargus_exe = loc_tauargus)


data("turnover_act_size")
data("activity_corr_table")

write_hrc2(activity_corr_table, file_name = "hrc/NAF_principale.hrc")

alt_corr_table <- tibble::tibble(
  niv0 = "AGREG",
  niv1 = c("B","AZ")
)
write_hrc2(alt_corr_table %>% select(-niv0), file_name = "hrc/AGREG_alt.hrc")

turnover_act_size_detect <-  turnover_act_size %>%
  rename(FREQ = N_OBS, VALUE = TOT) %>% 
  mutate(
    is_secret_freq = FREQ > 0 & FREQ < 3,
    is_secret_dom = (VALUE != 0) & (MAX > 0.85*VALUE)
  ) %>% 
  mutate(
    is_secret_prim = is_secret_freq | is_secret_dom
  )

trunover_act_size_alt <- turnover_act_size_detect %>% 
  filter(ACTIVITY %in% c("AZ","B"))

masq_nonemb <- tab_multi_manager(
  list_tables = list(
    tab = turnover_act_size_detect,
    tab_alt = trunover_act_size_alt
    ),
  list_explanatory_vars = list(
    tab = c("ACTIVITY","SIZE"),
    tab_alt = c("ACTIVITY","SIZE")
    ),
  dir_name = "tauargus_files/hrc_nonemb",
  hrc = list(ACTIVITY = "hrc/NAF_principale.hrc"),
  alt_hrc = list(
    tab_alt = c(ACTIVITY = "hrc/AGREG_alt.hrc")
    ),
  totcode = "Total",
  alt_totcode = list(
    tab_alt = c(ACTIVITY = "AGREG")
    ),
  value = "VALUE",
  freq = "FREQ",
  secret_var = "is_secret_prim"
)

saveRDS(masq_nonemb,"tauargus_files/hrc_nonemb/masq_nonemb.rds")

masq_nonemb <- masq_nonemb %>% 
  purrr::map(
    function(tab){
      tab %>% 
        rename_with(~"is_secret_final", last_col()) %>% 
        mutate(
          statut_final = case_when(
            is_secret_freq ~ "A",
            is_secret_dom ~ "B",
            is_secret_final ~"D",
            TRUE ~ "V"
          )
        )
    }
  )

masq_nonemb %>% 
  purrr::imap_dfr(
    function(tab, nom){
      tab %>% 
        count(statut_final) %>% 
        mutate(
          part = n/sum(n)*100,
          table = nom
        ) %>% 
        relocate(table)
    }
  )










