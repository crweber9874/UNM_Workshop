# Analysis: Did Latino voters shift toward Trump between 2020 and 2024?
library(tidyverse)

wss <- read_rds("data/wss_clean.rds")
voters <- wss |> filter(!is.na(trump_vote))
cat("n_obs =", nrow(voters), "| n_miss (no two-party vote) =", nrow(wss) - nrow(voters), "\n")

# 1. Weighted two-party Trump share by year x Latino
# CI uses Kish effective n; for design-based SEs use the survey package
shares <- voters |>
  summarise(trump = weighted.mean(trump_vote, weight),
            n = n(), n_eff = sum(weight)^2 / sum(weight^2),
            .by = c(year, latino)) |>
  mutate(se = sqrt(trump * (1 - trump) / n_eff),
         trump_low = trump - 1.96 * se, trump_upp = trump + 1.96 * se)
shares

ggplot(shares, aes(year, trump, colour = latino, group = latino)) +
  geom_pointrange(aes(ymin = trump_low, ymax = trump_upp)) +
  geom_line() +
  labs(x = NULL, y = "Two-party Trump share (weighted)", colour = NULL)
ggsave("output/trump_share_latino.png", width = 6, height = 4)

# 2. Does authoritarianism condition the shift?
fit <- glm(trump_vote ~ latino * year * authoritarianism + age + female + college,
           family = quasibinomial, weights = weight, data = voters)
summary(fit)
cat("n_obs =", nobs(fit), "| n_miss =", nrow(voters) - nobs(fit), "\n")

# 3. Bayesian version (slow to compile; run when time allows)
# library(brms)
# fit_b <- brm(trump_vote | weights(weight) ~ latino * year * authoritarianism + age + female + college,
#              family = bernoulli, data = voters, cores = 4, backend = "cmdstanr")
