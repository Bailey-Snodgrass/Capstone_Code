library(here)
source(here("R", "functions.R"))

current_fish <- "Silver_Carp"

# nativity is raw data manually created from fishbase
nativity_df <- read.csv(here("raw_data", "fish_nativity", paste0(current_fish, "_Nativity.csv")))
fish_df <- read.csv(here("csv", paste0(current_fish, "_Consumption.csv")))


invasive_isos <- nativity_df %>%
    filter(Occurrence == "introduced") %>%
    pull(ISO_Code)

native_isos <- nativity_df %>%
    filter(Occurrence == "native") %>%
    pull(ISO_Code)

fish_df <- fish_df %>%
    mutate(Nativity = case_when(
        consumer_iso3c %in% native_isos ~ "Native",
        consumer_iso3c %in% invasive_isos ~ "Introduced",
        TRUE ~ "Not present"
    ))

# be sure that consumption_with_nativity folder exists in csv folder
write.csv(fish_df, here("csv", "consumption_with_nativity", paste0(current_fish, "_Consumption_with_Nativity.csv")))