# Builds data/wss_2020_2024.csv from the raw Western States Survey Stata files.
# Raw files are not distributed; set WSS_RAW to their folder. Codebooks in codebooks/.
library(tidyverse)
library(haven)

raw <- Sys.getenv("WSS_RAW", "data/raw")
lab <- \(x) as.numeric(zap_labels(x))
valid <- \(x, k) if_else(lab(x) %in% k, lab(x), NA)
bin <- \(x, yes) if_else(lab(x) %in% 1:2, as.numeric(lab(x) == yes), NA)
st  <- c(`4` = "AZ", `8` = "CO", `32` = "NV", `35` = "NM", `49` = "UT")

common <- function(d) {
  d |>
    mutate(
      state   = st[as.character(lab(inputstate))],
      female  = valid(gender, 1:2) - 1,
      race    = as_factor(race) |> fct_drop() |> as.character(),
      race    = if_else(race %in% c("skipped", "not asked"), NA, race),
      latino  = as.numeric(race == "Hispanic"),
      educ    = valid(educ, 1:6),
      college = as.numeric(educ >= 4),
      faminc  = valid(faminc_new, 1:16),
      pid7    = valid(pid7, 1:7),
      ideo5   = valid(ideo5, 1:5)
    )
}

auth <- function(d, a, b, c, e) {
  d |>
    mutate(
      auth1 = bin({{ a }}, 2),
      auth2 = bin({{ b }}, 1),
      auth3 = bin({{ c }}, 2),
      auth4 = bin({{ e }}, 2)
    )
}

w20 <- read_dta(file.path(raw, "2020 WSS.dta")) |>
  common() |>
  auth(WSS07_1a, WSS07_1b, WSS07_1c, WSS07_1d) |>
  mutate(year = 2020, age = 2020 - lab(birthyr), weight = weight,
         vote = coalesce(valid(WSS36_b, 1:4), valid(WSS36_c, 1:4)),
         vote_type = if_else(is.na(valid(WSS36_b, 1:4)), "intended", "reported"))

w24 <- read_dta(file.path(raw, "2024 WSS.dta")) |>
  common() |>
  auth(WSS013_a, WSS013_b, WSS013_c, WSS013_d) |>
  mutate(year = 2024, age = lab(age), weight = weight_all,
         vote = coalesce(valid(WSS007_b, 1:4), valid(WSS007_c, 1:4), valid(WSS007_l, 1:4)),
         vote_type = if_else(is.na(valid(WSS007_b, 1:4)), "intended", "reported"))

wss <- bind_rows(w20, w24) |>
  mutate(
    vote_choice = c("Trump", "Democrat", "Other", "Did not vote")[vote],
    vote_type   = if_else(is.na(vote), NA, vote_type),
    trump_vote  = if_else(vote %in% 1:2, as.numeric(vote == 1), NA),
    id = paste0(year, "_", row_number(), .by = year)
  ) |>
  select(id, year, state, weight, vote_choice, vote_type, trump_vote, age, female, race,
         latino, educ, college, faminc, pid7, ideo5, auth1:auth4)

write_csv(wss, "data/wss_2020_2024.csv")
