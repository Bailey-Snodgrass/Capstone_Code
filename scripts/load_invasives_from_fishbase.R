library(here)

#source function file
source(here("R", "functions.R"))

trade_ds <- load_from_trade_parquet()
consumption_ds <- load_from_consumption_parquet()
fishbase_df <- load_from_fishbase_csv()

species_list <- species_list <- setNames(
  trimws(fishbase_df$Common_names), 
  tolower(fishbase_df$Species)
)

make_csv_by_species_list_invasive_fast(species_list, consumption_ds, trade_ds)