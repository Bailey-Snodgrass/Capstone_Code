library(tidyverse)
library(exploreARTIS)
library(ggbreak)

current_fish <- "Silver_Carp"

fish_data <- read.csv(paste0("C:/Users/Bailey New PC/Capstone/Capstone_Project/Csv_Data/", current_fish, "_Consumption.csv"))


data <- read.csv("C:\\Users\\Bailey New PC\\Capstone\\Capstone_Project\\Csv_Data\\Invasive species lists\\Silver_Carp_Nativity.csv")

invasive_iso <- data %>%
  filter(Occurrence == "introduced") %>%
  pull(ISO_Code)


native_iso <- data %>%
  filter(Occurrence == "native") %>%
  pull(ISO_Code)

fish_data <- fish_data %>% mutate(Nativity = case_when(
  consumer_iso3c %in% native_iso ~ "Native",
  consumer_iso3c %in% invasive_iso ~ "Introduced",
  TRUE ~ "Not present"))

write.csv(fish_data, paste0("C:/Users/Bailey New PC/Capstone/Capstone_Project/Csv_Data/", current_fish, "_Consumption_Extra.csv"))

fish_data_filtered <- fish_data %>%
  filter(source_country_iso3c == "USA",
         method == "capture",
         consumer_iso3c != "USA")

fish_graph <- plot_ts(fish_data_filtered, artis_var = "Nativity", value = "consumption_live_t", prop_flow_cutoff = .01, plot.type = "stacked")

print(fish_graph)