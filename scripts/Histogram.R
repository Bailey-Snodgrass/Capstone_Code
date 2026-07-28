library(here)
source(here("R", "functions.R"))

fish_list <- c(
  "Grass Carp",
  "Silver Carp",
  "Bighead Carp",
  "Lionfish",
  "Goldfish",
  #"Snakehead"
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
}) %>% bind_rows()

plot <- ggplot(
  combined_trends,
  aes(
    x = total_consumption,
    fill = fish,
    color = fish
  )
) +
  geom_density(alpha = 0.4) +
  labs(
    title = "Distribution of Fish Export Totals",
    x = "Export Total (Live Tons)",
    y = "Density"
  ) +
  theme_minimal()

print(plot)