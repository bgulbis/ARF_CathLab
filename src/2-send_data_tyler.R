# basic tidying and create csv files

library(tidyverse)
library(stringr)
library(edwr)

dir_raw <- "data/raw"

raw_demographics <- read_data(dir_raw, "demographics") %>%
    as.demographics() %>%
    select(pie.id:race, length.stay)

raw_diagnosis <- read_data(dir_raw, "diagnosis") %>%
    as.diagnosis()

raw_identifiers <- read_data(dir_raw, "identifiers") %>%
    as.id()

raw_labs <- read_data(dir_raw, "labs") %>%
    as.labs() %>%
    tidy_data() %>%
    filter(lab == "creatinine lvl")

raw_measures <- read_data(dir_raw, "measures") %>%
    as.measures()

raw_meds_sched <- read_data(dir_raw, "meds-sched") %>%
    as.meds_sched()

ref_cont <- tibble(
    name = c("dopamine", "norepinephrine", "phenylephrine", "epinephrine",
             "vasopressin", "dobutamine", "milrinone"),
    type = "med",
    group = "cont"
)

raw_meds_cont <- read_data(dir_raw, "meds-cont") %>%
    as.meds_cont() %>%
    tidy_data(ref_cont, raw_meds_sched)

ref_sched <- tibble(
    name = c(
        "nonsteroidal anti-inflammatory agents",
        "cox-2 inhibitors",
        "diuretics",
        "angiotensin converting enzyme inhibitors",
        "angiotensin II inhibitors",
        "non-ionic iodinated contrast media"
    ),
    type = "class",
    group = "sched"
)

raw_meds_sched <- raw_meds_sched %>%
    tidy_data(ref_sched)

raw_vitals <- read_data(dir_raw, "vitals") %>%
    as.vitals() %>%
    filter(str_detect(vital, "pressure|arterial"))

write_csv(raw_demographics, "data/external/demographics.csv")
write_csv(raw_diagnosis, "data/external/diagnosis_codes.csv")
write_csv(raw_identifiers, "data/external/linking_log.csv")
write_csv(raw_labs, "data/external/labs_scr.csv")
write_csv(raw_measures, "data/external/height_weight.csv")
write_csv(raw_meds_cont, "data/external/meds_continuous.csv")
write_csv(raw_meds_sched, "data/external/meds_intermittent.csv")
write_csv(raw_vitals, "data/external/blood_pressure.csv")
