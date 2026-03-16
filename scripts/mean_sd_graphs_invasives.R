library(here)

#source function file
source(here("R", "functions.R"))

make_graph_of_sums <- function(df) {
  df <- df %>%
    filter(source_country_iso3c == "USA") %>%
    filter(method == "capture") %>%
    filter(year >= 2016 & year <= 2020) %>%
    group_by(fish, year) %>%
    summarize(
      sum_consumption_live_t = sum(consumption_live_t, na.rm = TRUE)
    )
  return(df)
}

make_graph_of_sums_invasive_collection <- function(fish_name_list) {
  df_list <- list()
  for (fish in fish_name_list) {
    file_path <- file.path(csv_folder_path, "invasive", paste0(fish, "_Consumption.csv"))
    if (file.exists(file_path)) {
      df <- read.csv(file_path)
      df$fish <- fish
      df_list[[length(df_list) + 1]] <- df
      print(paste("Processed:", fish))
    } else {
      print(paste("File not found for:", fish))
    }
  }
  combined_df <- bind_rows(df_list)
  return(make_graph_of_sums(combined_df))
}

fishbase_df <- load_from_fishbase_csv()

fish_name_list <- trimws(fishbase_df$Common_names)

graph <- make_graph_of_sums_invasive_collection(fish_name_list)

write.csv(graph, here("csv", "sums_of_invasive_fish_consumption.csv"), row.names = FALSE)