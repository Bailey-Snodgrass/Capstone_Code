library(here)
source(here("R", "functions.R"))

current_fish <- "Bighead_Carp"

fish_df <- read.csv(here("csv", paste0(current_fish, "_Consumption.csv")))

fish_df <- fish_df %>%
  filter(source_country_iso3c == 'USA') %>%
  filter(method == 'capture') %>%
  mutate(consumer_group = ifelse(consumer_iso3c == 'USA', 'USA', 'OTHER'))

fish_graph <- plot_ts(fish_df, artis_var = "consumer_group", value = "consumption_live_t", prop_flow_cutoff = .01, plot.type = "stacked") +
  geom_vline(xintercept = 1972, linetype = "dotted", color = "red")

print(fish_graph)