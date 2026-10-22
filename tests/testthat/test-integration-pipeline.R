# INTEGRATION. The artifact R/01_recode.R actually produced, from the real CSV.
library(tidyverse)

rds <- repo_path("data/wss_clean.rds")
if (!file.exists(rds)) skip("data/wss_clean.rds not built; run Rscript R/01_recode.R")
wss <- read_rds(rds)

test_that("the recode keeps every respondent", {
  expect_equal(nrow(wss), 7600)
  expect_setequal(levels(wss$year), c("2020", "2024"))
})

test_that("every derived variable the recode promises is present", {
  expect_true(all(c("authoritarianism", "auth_group", "age_group",
                    "party3", "race4", "latino") %in% names(wss)))
})

test_that("authoritarianism is a 0-1 mean of four items", {
  expect_true(all(wss$authoritarianism >= 0 & wss$authoritarianism <= 1, na.rm = TRUE))
  expect_setequal(levels(wss$auth_group), c("Low", "Middle", "High"))
})

test_that("trump_vote is coded only for two-party voters", {
  expect_setequal(unique(na.omit(wss$trump_vote)), c(0, 1))
  expect_equal(sum(!is.na(wss$trump_vote)), 6495)
})

test_that("latino and party3 take the documented values", {
  expect_setequal(levels(wss$latino), c("Non-Latino", "Latino"))
  expect_setequal(na.omit(unique(wss$party3)), c("Democrat", "Independent", "Republican"))
})

test_that("weights are positive where a vote is observed", {
  voters <- wss[!is.na(wss$trump_vote), ]
  expect_true(all(voters$weight > 0))
  expect_equal(sum(is.na(voters$weight)), 0)
})

test_that("the recode is reproducible from the CSV it documents", {
  csv <- repo_path("data/wss_2020_2024.csv")
  skip_if_not(file.exists(csv))
  raw <- read_csv(csv, show_col_types = FALSE)
  expect_equal(nrow(raw), nrow(wss))
  expect_true(all(c("auth1", "auth2", "auth3", "auth4", "pid7") %in% names(raw)))
})
