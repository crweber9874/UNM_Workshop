# INTEGRATION. The Shiny server with the real data behind it: inputs in, table out.
library(shiny)
library(tidyverse)

app_dir <- repo_path("app")
if (!file.exists(repo_path("data/wss_clean.rds"))) {
  skip("data/wss_clean.rds not built; run Rscript R/01_recode.R")
}

test_that("the app reacts to its inputs and returns one row per year and group", {
  testServer(app_dir, {
    session$setInputs(state = c("AZ", "NM"), by = "latino", wt = TRUE)
    out <- est()
    expect_setequal(as.character(out$year), c("2020", "2024"))
    expect_setequal(as.character(out$latino), c("Latino", "Non-Latino"))
    expect_true(all(out$trump >= 0 & out$trump <= 1))
    expect_true(all(c("n_obs", "n_miss") %in% names(out)))
  })
})

test_that("the weights toggle changes the estimate it claims to change", {
  testServer(app_dir, {
    session$setInputs(state = c("AZ", "CO", "NV", "NM", "UT"), by = "latino", wt = TRUE)
    weighted <- est()$trump
    session$setInputs(wt = FALSE)
    expect_false(isTRUE(all.equal(weighted, est()$trump)))
  })
})

test_that("narrowing the state filter never grows the sample", {
  testServer(app_dir, {
    session$setInputs(state = c("AZ", "CO", "NV", "NM", "UT"), by = "auth_group", wt = TRUE)
    all_states <- sum(est()$n_obs)
    session$setInputs(state = "AZ")
    expect_lte(sum(est()$n_obs), all_states)
  })
})
