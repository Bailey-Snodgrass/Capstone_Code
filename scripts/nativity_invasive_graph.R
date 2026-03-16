library(here)
source(here("R", "functions.R"))

current_fish <- "Silver_Carp"

fish_nativity_df <- read.csv(here("csv", "consumption_with_nativity", paste0(current_fish, "_Consumption_with_Nativity.csv")))

fish_nativity_df <- fish_nativity_df %>%
    filter(
        source_country_iso3c == "USA",
        method == "capture",
        consumer_iso3c != "USA"
    )

fish_graph <- plot_ts(fish_nativity_df, artis_var = "Nativity", value = "consumption_live_t", prop_flow_cutoff = .01, plot.type = "stacked")

print(fish_graph)