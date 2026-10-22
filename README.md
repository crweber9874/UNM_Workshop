# UNM Workshop: AI as a Research Tool

Hands-on workshop using GitHub, Copilot, and Claude Code on a shared R project.
**Website & slides:** https://crweber9874.github.io/UNM_Workshop/

**Question:** Did Latino voters in the Western states shift toward Trump between 2020 and 2024? Does authoritarianism condition it?

## Quick start
```bash
git clone https://github.com/crweber9874/UNM_Workshop.git
cd UNM_Workshop
Rscript R/01_recode.R                             # csv -> data/wss_clean.rds
Rscript R/02_analysis.R                           # models, figures -> output/
Rscript -e 'testthat::test_dir("tests/testthat")' # checks on the recodes
Rscript -e 'shiny::runApp("app")'
```
No local R? Click **Code → Codespaces → Create codespace on main**. You'll get R, RStudio (port 8787), Quarto, Copilot, and Claude Code.

## Structure
```
data/        wss_2020_2024.csv (joined 2020 + 2024 Western States Survey)
codebooks/   original survey codebooks (PDF)
R/           functions.R (pure helpers) + 00_build_data.R → 01_recode.R → 02_analysis.R
app/         Shiny explorer
tests/       test-unit-*.R (functions, synthetic data) and test-integration-*.R (pipeline + Shiny server)
output/      figures/tables (git-ignored)
slides/      workshop slides (Quarto revealjs; nested project -> _site/slides/)
*.qmd        the workshop book: index + 00-resources, 01-framing … 11-verification
_freeze/     cached chunk output (committed, so the book rebuilds without the data)
AGENTS.md    instructions any AI agent reads; CLAUDE.md imports it
```

## Pipeline
`R/00_build_data.R` (instructor only; needs the raw Stata files) → `R/01_recode.R` → `R/02_analysis.R` → `app/app.R`. All recoding lives in `01_recode.R`; analysis scripts never recode. `tests/testthat/` splits unit tests (`R/functions.R`, synthetic input) from integration tests (the built `.rds`, and the Shiny server via `shiny::testServer()`).

## Data
Western States Survey, 2020 (n = 3,600) and 2024 (n = 4,000), AZ/CO/NV/NM/UT; fielded by YouGov. Variables and coding: see `AGENTS.md` and `codebooks/`. Pared down to vote choice, demographics, partisanship/ideology, and the four-item child-rearing authoritarianism battery.

Current baseline (`R/02_analysis.R`, weighted two-party Trump share): non-Latino .503 → .511, Latino .398 → .419; n_obs = 6,495, n_miss = 1,105 of 7,600.

## Contributing
The repository is public: clone it to read and run it — no access needed. To send something back, fork it and open a pull request. See the [git workflow](https://crweber9874.github.io/UNM_Workshop/git.html).

## The book
The website is a Quarto **book** (`project: type: book`) rendered to `_site/`, with the slides as a nested project that lands in `_site/slides/`. Chapters 06–10 execute real code against `data/wss_2020_2024.csv`, so their tables and figures are whatever the scripts currently produce.

```bash
quarto render                 # whole project: book + slides -> _site/
quarto preview                # live reload
quarto publish gh-pages       # render, then push to the gh-pages branch
rm -rf _freeze && quarto render   # prove it still reproduces from scratch
```

Render the **project**, not a single chapter — `quarto render 06-data.qmd` inside a book project writes stray HTML to the repo root (which `.gitignore` now ignores).
