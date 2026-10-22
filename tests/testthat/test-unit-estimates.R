# UNIT. trump_share() against a toy frame whose answer is known by hand.
library(tidyverse)
source(repo_path("R/functions.R"))

toy <- tibble(
  year       = factor(c(2020, 2020, 2020, 2024, 2024)),
  latino     = factor(c("Latino", "Latino", "Non-Latino", "Latino", "Latino")),
  trump_vote = c(1, 0, 1, 1, NA),
  weight     = c(3, 1, 1, 1, 1)
)

test_that("unweighted share is the plain mean of observed votes", {
  out <- trump_share(toy, "latino", weighted = FALSE) |> filter(year == "2020", latino == "Latino")
  expect_equal(out$trump, 0.5)
})

test_that("weights shift the share as specified", {
  out <- trump_share(toy, "latino", weighted = TRUE) |> filter(year == "2020", latino == "Latino")
  expect_equal(out$trump, 0.75)
})

test_that("n_obs and n_miss are reported and sum to the cell size", {
  out <- trump_share(toy, "latino") |> filter(year == "2024", latino == "Latino")
  expect_equal(out$n_obs, 1L)
  expect_equal(out$n_miss, 1L)
})

test_that("rows missing the grouping variable are dropped, not silently pooled", {
  with_na <- toy |> mutate(latino = factor(c(NA, "Latino", "Non-Latino", "Latino", "Latino")))
  expect_false(any(is.na(trump_share(with_na, "latino")$latino)))
})

test_that("an unknown grouping column fails loudly", {
  expect_error(trump_share(toy, "not_a_column"))
})
