# Recode: data/wss_2020_2024.csv -> data/wss_clean.rds
library(tidyverse)
source("R/functions.R")

wss <- read_csv("data/wss_2020_2024.csv", show_col_types = FALSE)
stopifnot(all(c("auth1", "auth2", "auth3", "auth4", "pid7", "age") %in% names(wss)))

wss <- wss |>
  mutate(
    authoritarianism = auth_scale(pick(auth1:auth4)),
    auth_group = bin_auth(authoritarianism),
    age_group  = bin_age(age),
    party3     = pid_to_party3(pid7),
    race4      = fct_lump_n(race, 3, other_level = "Other") |> fct_infreq(),
    latino     = factor(latino, 0:1, c("Non-Latino", "Latino")),
    year       = factor(year)
  )

stopifnot(all(between(wss$authoritarianism, 0, 1), na.rm = TRUE))
write_rds(wss, "data/wss_clean.rds")
