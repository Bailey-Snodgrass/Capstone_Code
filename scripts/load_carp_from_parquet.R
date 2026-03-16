library(here)

#source function file
source(here("R", "functions.R"))

trade_ds <- load_from_trade_parquet()
consumption_ds <- load_from_consumption_parquet()

list_of_carp <- list(
    "cyprinus carpio" = "Common_Carp",
    "ctenopharyngodon idella" = "Grass_Carp",
    "hypophthalmichthys molitrix" = "Silver_Carp",
    "hypophthalmichthys nobilis" = "Bighead_Carp"
)

make_csv_by_species_list_fast(list_of_carp, consumption_ds, trade_ds)