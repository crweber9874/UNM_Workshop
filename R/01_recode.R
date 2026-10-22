# Recode: data/wss_2020_2024.csv -> data/wss_clean.rds
library(tidyverse)

wss <- read_csv("data/wss_2020_2024.csv", show_col_types = FALSE) |>
  mutate(
    authoritarianism = rowMeans(pick(auth1:auth4), na.rm = TRUE),
    auth_group = cut(authoritarianism, c(-Inf, .25, .75, Inf),
                     labels = c("Low", "Middle", "High")),
    age_group  = cut(age, c(17, 29, 44, 64, Inf), labels = c("18-29", "30-44", "45-64", "65+")),
    party3     = case_when(pid7 <= 3 ~ "Democrat", pid7 == 4 ~ "Independent", pid7 >= 5 ~ "Republican"),
    race4      = fct_lump_n(race, 3, other_level = "Other") |> fct_infreq(),
    latino     = factor(latino, 0:1, c("Non-Latino", "Latino")),
    year       = factor(year)
  )

stopifnot(all(between(wss$authoritarianism, 0, 1), na.rm = TRUE))
write_rds(wss, "data/wss_clean.rds")
