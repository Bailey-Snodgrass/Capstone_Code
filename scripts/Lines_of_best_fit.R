library(here)
library(dplyr)
library(ggplot2)

fish_list <- c(
  "Grass Carp",
  "Silver Carp",
  "Bighead Carp",
  "Common Carp"
)

combined_trends <- lapply(fish_list, function(current_fish) {
  fish_df <- read.csv(
    here("csv", "invasive", paste0(current_fish, "_Consumption.csv"))
  )
  
  fish_df %>%
    filter(
      source_country_iso3c == "USA",
      method == "capture",
      consumer_iso3c != "USA"
    ) %>%
    group_by(year) %>%
    summarize(
      total_consumption = sum(consumption_live_t, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    mutate(fish = current_fish)
}) %>%
  bind_rows()

lines_of_best_fit <- ggplot(
  combined_trends,
  aes(
    x = year,
    y = total_consumption,
    color = fish
  )
) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linewidth = 1.2
  ) +
  labs(
    title = "Consumption Trends by Fish",
    y = "Total Consumption"
  ) +
  theme_minimal()

print(lines_of_best_fit)
