# get encounter list

library(tidyverse)
library(readxl)
library(edwr)

nm <- "data/external/2016-12-27_cathlab_patients.xlsx"
raw_pts16 <- read_excel(nm, "2016")
raw_pts15 <- read_excel(nm, "2015")
raw_pts <- bind_rows(raw_pts15, raw_pts16) %>%
    filter(!is.na(FIN)) %>%
    dmap_at("FIN", as.character)

edw_fin <- concat_encounters(raw_pts$FIN)

# run EDW query: Identifiers - by FIN

ids <- read_data("data/raw", "identifiers") %>%
    as.id()

edw_pie <- concat_encounters(ids$pie.id)

# run EDW queries:
#   * Demographics
#   * Diagnosis Codes (ICD-9/10-CM) - All
#   * Labs - Renal
#   * Measures (Height and Weight)
#   * Medications - Inpatient Continuous - All
#   * Medications - Inpatient Intermittent - All
#   * Vitals
