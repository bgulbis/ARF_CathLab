# calculate AUC

library(tidyverse)
library(lubridate)
library(MESS)

sbp <- read_csv("data/external/BP_filtered_timedelta_systolic.csv") %>%
    select(pie.id, Cathlab_time, vital.datetime, vital.result) %>%
    dmap_at(c("vital.datetime", "Cathlab_time"), mdy_hm) %>%
    dmap_at("pie.id", as.character)

sbp_auc <- sbp %>%
    group_by(pie.id) %>%
    arrange(pie.id, vital.datetime) %>%
    mutate(duration = as.numeric(difftime(vital.datetime, first(vital.datetime), units = "hours"))) %>%
    summarize(sbp_auc = auc(duration, vital.result),
              duration = max(duration)) %>%
    mutate(sbp_time_wt_avg = sbp_auc / duration)

write_csv(sbp_auc, "data/external/sbp_auc.csv")
