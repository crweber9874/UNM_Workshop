# AGENTS.md — instructions for AI coding agents

Read by Claude Code (via CLAUDE.md), GitHub Copilot, Codex, Cursor, and others.

## Project
This is an AI workshop for a largely quantitative political psychology conference. The goal of this workshop is understand an agentic, largely claude and copilot assisted workflow. The project follows strict reproducibility standards and follows an open science framework. 

## Layout
- `data/wss_2020_2024.csv` — analysis file (read-only; never modify or edit by hand)
- `data/wss_clean.rds` — this is produced by `R/01_recode.R` (regenerate, never edit)
- `codebooks/` — 2020 and 2024 Western States Survey codebooks (PDF). Cite these when describing a variable.
- `R/00_build_data.R` — builds the CSV from raw Stata files (not distributed)
- `R/functions.R` — pure helpers (no file I/O) shared by the recode, the analysis, and the app; unit-tested
- `R/01_recode.R` — all recoding lives here
- `R/02_analysis.R` — models and figures; writes to `output/`
- `app/app.R` — Shiny explorer; holds no analysis logic, calls `R/functions.R`
- `tests/testthat/` — `test-unit-*.R` (pure functions, synthetic input) and `test-integration-*.R` (built artifact, live Shiny server)

## Variables (data/wss_2020_2024.csv)
`year`, `state` (AZ CO NV NM UT), `weight` (2020: `weight`; 2024: `weight_all`), `vote_choice`, `vote_type` (reported/intended), `trump_vote` (1 Trump, 0 Biden/Harris, NA otherwise), `age`, `female`, `race`, `latino`, `educ` (1–6), `college`, `faminc` (1–16), `pid7`, `ideo5`, `auth1`–`auth4` (child-rearing items, 1 = authoritarian response).

## Rules
- R + tidyverse, native pipe `|>`. Minimal comments.
- Boilerplate template, never generate substantive interpretation of results, unless prompted. Text written by AI should be flagged
- New recodes go in `R/01_recode.R`, not in analysis scripts. Logic reused in more than one place goes in `R/functions.R` with a unit test.
- Always report n_obs and n_miss with any model.
- Use survey weights for population estimates; say when you don't.
- Don't commit raw data, secrets, or anything in `output/` ever.
- Don't push to `main` without the user's say-so; prefer a branch + pull request.
- Work from this repository only: no data from other repositories or files on this computer
- Minimize overlapping functions and write human readable code, that is concise with useful but 
minimal comments.
- Cite from the codebook rather than inferring from data.
