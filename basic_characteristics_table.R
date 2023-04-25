library(tidyverse)
setwd("~/repos/retrospective-registration")

starrr <- read_rds(file = "data/starrr_dataset.Rds")

table(starrr$is_prospective)

table(starrr$main_sponsor, starrr$is_prospective)
table(starrr$registry, starrr$is_prospective)
starrr <- starrr %>% 
  mutate(
    phase_recoded = case_when(
      phase == 'Early Phase 1' | phase ==  'I' | phase == 'Phase 1' ~ 'Phase 1',
      phase == 'II' | phase ==  'IIa' | phase ==  'IIb' | phase ==  'Phase 1/Phase 2' | phase ==  'Phase 2' ~ 'Phase 2',
      phase == 'II-III' | phase ==  'III' | phase ==  'IIIb' | phase == 'Phase 2/Phase 3' | phase ==  'Phase 3' ~ 'Phase 3',
      phase == 'IV' | phase ==  'Phase 4' ~ 'Phase 4',
      TRUE ~ 'No phase'
      )
    )
table(starrr$phase_recoded, starrr$is_prospective)

table(starrr$intervention_type, starrr$is_prospective)
