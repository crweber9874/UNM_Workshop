# UNM Workshop: AI as a Research Tool

Hands-on workshop using GitHub, Copilot, and Claude Code on a shared R project.
**Website & slides:** https://crweber9874.github.io/UNM_Workshop/

**Question:** Did Latino voters in the Western states shift toward Trump between 2020 and 2024? Does authoritarianism condition it?

## Quick start
```bash
git clone https://github.com/crweber9874/UNM_Workshop.git
cd UNM_Workshop
Rscript R/01_recode.R && Rscript R/02_analysis.R
Rscript -e 'shiny::runApp("app")'
```
No local R? Click **Code → Codespaces → Create codespace on main**. You'll get R, RStudio (port 8787), Quarto, Copilot, and Claude Code.

## Structure
```
data/        wss_2020_2024.csv (joined 2020 + 2024 Western States Survey)
codebooks/   original survey codebooks (PDF)
R/           00_build_data.R → 01_recode.R → 02_analysis.R
app/         Shiny explorer
output/      figures/tables (git-ignored)
slides/      workshop slides (Quarto revealjs)
AGENTS.md    instructions any AI agent reads; CLAUDE.md imports it
```

## Data
Western States Survey, 2020 (n = 3,600) and 2024 (n = 4,000), AZ/CO/NV/NM/UT; fielded by YouGov. Variables and coding: see `AGENTS.md` and `codebooks/`. Pared down to vote choice, demographics, partisanship/ideology, and the four-item child-rearing authoritarianism battery.

## Contributing
Pull first, work on a branch, open a pull request. See the [git workflow](https://crweber9874.github.io/UNM_Workshop/git.html).

## Updating the website
`quarto publish gh-pages` (renders and pushes to the gh-pages branch).
