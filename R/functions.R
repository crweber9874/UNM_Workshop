# Pure helpers shared by R/01_recode.R, R/02_analysis.R, and app/app.R.
# No file I/O here: everything takes data in and returns data out, which is
# what makes these unit-testable without the survey file.
library(tidyverse)

# Mean of the four child-rearing items, on 0-1. NA only when all four are missing.
auth_scale <- function(items) {
  stopifnot(is.data.frame(items), ncol(items) == 4)
  m <- rowMeans(items, na.rm = TRUE)
  ifelse(is.nan(m), NA_real_, m)
}

bin_auth <- function(x) {
  cut(x, c(-Inf, .25, .75, Inf), labels = c("Low", "Middle", "High"))
}

bin_age <- function(x) {
  cut(x, c(17, 29, 44, 64, Inf), labels = c("18-29", "30-44", "45-64", "65+"))
}

# pid7: 1-3 Democrat, 4 Independent, 5-7 Republican (WSS codebooks, 2020 & 2024).
pid_to_party3 <- function(pid7) {
  case_when(pid7 <= 3 ~ "Democrat", pid7 == 4 ~ "Independent", pid7 >= 5 ~ "Republican")
}

# Two-party Trump share by year within `by`, with n_obs and n_miss alongside.
trump_share <- function(data, by, weighted = TRUE) {
  stopifnot(is.character(by), length(by) == 1L, by %in% names(data))
  data |>
    mutate(w = if (weighted) weight else 1) |>
    summarise(
      trump  = weighted.mean(trump_vote[!is.na(trump_vote)], w[!is.na(trump_vote)]),
      n_obs  = sum(!is.na(trump_vote)),
      n_miss = sum(is.na(trump_vote)),
      .by = c(year, all_of(by))
    ) |>
    filter(!is.na(.data[[by]]))
}
