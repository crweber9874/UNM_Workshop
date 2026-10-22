# UNIT. Pure recode helpers, synthetic input, no survey file touched.
library(tidyverse)
source(repo_path("R/functions.R"))

test_that("auth_scale averages the four items onto 0-1", {
  items <- tibble(a = c(0, 1, 0.5), b = c(0, 1, 0.5), c = c(0, 1, 0), d = c(0, 1, 1))
  expect_equal(auth_scale(items), c(0, 1, 0.5))
})

test_that("auth_scale ignores partial missingness but keeps all-missing as NA", {
  items <- tibble(a = c(1, NA), b = c(NA, NA), c = c(1, NA), d = c(NA, NA))
  expect_equal(auth_scale(items), c(1, NA_real_))
})

test_that("auth_scale rejects anything that is not four items", {
  expect_error(auth_scale(tibble(a = 1, b = 0, c = 1)))
})

test_that("bin_auth cuts at .25 and .75, inclusive on the low side", {
  expect_equal(
    as.character(bin_auth(c(0, .25, .26, .75, .76, 1))),
    c("Low", "Low", "Middle", "Middle", "High", "High")
  )
})

test_that("bin_age uses the documented breaks and excludes under-18", {
  expect_equal(
    as.character(bin_age(c(18, 29, 30, 44, 45, 64, 65, 92))),
    c("18-29", "18-29", "30-44", "30-44", "45-64", "45-64", "65+", "65+")
  )
  expect_true(is.na(bin_age(17)))
})

test_that("pid_to_party3 follows the codebook's 1-7 scale", {
  expect_equal(
    pid_to_party3(1:7),
    c("Democrat", "Democrat", "Democrat", "Independent",
      "Republican", "Republican", "Republican")
  )
  expect_true(is.na(pid_to_party3(NA_real_)))
})
