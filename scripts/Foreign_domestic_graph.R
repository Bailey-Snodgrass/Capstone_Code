library(tidyverse)
library(exploreARTIS)
library(ggbreak)

current_fish <- "Bighead_Carp"

fish_data <- read.csv(paste0("C:/Users/Bailey New PC/Capstone/Capstone_Project/Csv_Data/", current_fish, "_Consumption.csv"))


fish_data_filtered <- fish_data %>%
  filter(source_country_iso3c == 'USA') %>%
  filter(method == 'capture') %>%
  mutate(consumer_group = ifelse(consumer_iso3c == 'USA', 'USA', 'OTHER'))

fish_graph <- plot_ts(fish_data_filtered, artis_var = "consumer_group", value = "consumption_live_t", prop_flow_cutoff = .01, plot.type = "stacked") +
  geom_vline(xintercept = 1972, linetype = "dotted", color = "red")

print(fish_graph)
