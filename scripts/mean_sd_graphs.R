library(here)

#source function file
source(here("R", "functions.R"))

current_fish <- "Grass_Carp"
fish_df <- load_csv_from_folder(paste0(current_fish, "_Consumption"))

make_graph_of_sums <- function(df) {
    df <- df %>%
        filter(source_country_iso3c == "USA") %>%
        filter(method == "capture") %>%
        filter(year >= 2016 & year <= 2020) %>%
        group_by(year) %>%
        summarize(
            sum_consumption_live_t = sum(consumption_live_t, na.rm = TRUE),
            mean_consumption_live_t = mean(consumption_live_t, na.rm = TRUE)
        )
    return(df)
}

graph_sums <- make_graph_of_sums(fish_df)
view(graph_sums)