# AGENTS.md — instructions for AI coding agents

Read by Claude Code (via CLAUDE.md), GitHub Copilot, Codex, Cursor, and others.

## Project
Group workshop project. Question: did Latino voters in the Western states shift toward Trump from 2020 to 2024, and does authoritarianism condition that shift?

## Layout
- `data/wss_2020_2024.csv` — analysis file (read-only; never edit by hand)
- `data/wss_clean.rds` — produced by `R/01_recode.R` (regenerate, never edit)
- `codebooks/` — 2020 and 2024 Western States Survey codebooks (PDF). Cite these when describing a variable.
- `R/00_build_data.R` — builds the CSV from raw Stata files (not distributed)
- `R/01_recode.R` — all recoding lives here
- `R/02_analysis.R` — models and figures; writes to `output/`
- `app/app.R` — Shiny explorer

## Variables (data/wss_2020_2024.csv)
`year`, `state` (AZ CO NV NM UT), `weight` (2020: `weight`; 2024: `weight_all`), `vote_choice`, `vote_type` (reported/intended), `trump_vote` (1 Trump, 0 Biden/Harris, NA otherwise), `age`, `female`, `race`, `latino`, `educ` (1–6), `college`, `faminc` (1–16), `pid7`, `ideo5`, `auth1`–`auth4` (child-rearing items, 1 = authoritarian response).

## Rules
- R + tidyverse, native pipe `|>`. Minimal comments.
- New recodes go in `R/01_recode.R`, not in analysis scripts.
- Always report n_obs and n_miss with any model.
- Use survey weights for population estimates; say when you don't.
- Don't commit raw data, secrets, or anything in `output/`.
- Don't push to `main` without the user's say-so; prefer a branch + pull request.
