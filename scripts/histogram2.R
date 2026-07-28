library(here)
library(dplyr)
library(ggplot2)
library(ggrepel)

source(here("R", "functions.R"))

fish_list <- c(
  "Grass Carp",
  "Silver Carp",
  "Bighead Carp",
  "Lionfish",
  "Goldfish",
  "Snakehead",
  "Common Carp"
)

combined_consumption <- lapply(fish_list, function(current_fish) {
  
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

fish_means <- combined_consumption %>%
  group_by(fish) %>%
  summarize(
    mean_consumption = mean(total_consumption, na.rm = TRUE),
    .groups = "drop"
  )

dens <- density(combined_consumption$total_consumption)

fish_means$y <- approx(
  x = dens$x,
  y = dens$y,
  xout = fish_means$mean_consumption
)$y

plot <- ggplot(combined_consumption, aes(x = total_consumption)) +
  geom_density(alpha = 0.4, fill = "steelblue") +
  geom_point(
    data = fish_means,
    aes(x = mean_consumption, y = y, color = fish),
    size = 3
  ) +
  geom_text_repel(
    data = fish_means,
    aes(x = mean_consumption, y = y, label = fish, color = fish),
    size = 3,
    box.padding = 0.6,
    point.padding = 0.4,
    segment.color = "grey50",
    show.legend = FALSE
  ) +
  labs(
    title = "Pooled Distribution of Fish Export Totals",
    x = "Annual Export Total (Live Tons)",
    y = "Density"
  ) +
  theme_minimal()

print(plot)