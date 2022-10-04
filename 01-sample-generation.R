library(tidyverse)
library(lubridate)

iv_full <- read_csv("https://raw.githubusercontent.com/maia-sh/intovalue-data/main/data/processed/trials.csv")

# save a file of the full dataset as MSH might make changes to the dataset hosted on GitHub
iv_full %>% 
  write.csv(paste0(file = "./data/raw_data/IntoValue-", format(Sys.time(), "%F"), ".csv"), row.names = FALSE)

# iv_full <- read_csv("./data/raw_data/IntoValue-2020-02-22.csv")


# ---------------------------------------------------
# Filter database entries and format the dataset 
# ---------------------------------------------------

# filter the dataset - only keep entries that...  
# * have a full-text journal publication, 
# * have a German university medical center as the lead center, 
# * are not "NA" in the "is_prospective" variable (which would mean that either start date or registration date are missing), 
# * and only keep IV2 versions of duplicated entries (that were included in both IV1 and IV2)

iv_sel <- iv_full %>% 
  filter(has_ft == TRUE & 
           publication_type == "journal publication" & 
           has_german_umc_lead == TRUE & 
           !is.na(is_prospective) & 
           !(is_dupe == TRUE & iv_version == 1)) 


# convert all columns containing dates (but after import saved as strings) to date data type 
dateCols <- c("registration_date", 
              "start_date", 
              "completion_date", 
              "primary_completion_date", 
              "results_search_start_date", 
              "results_search_end_date", 
              "publication_date", 
              "epub_date", 
              "publication_date_unpaywall")
iv_sel[dateCols] <- lapply(iv_sel[dateCols], as.Date, origin="%Y-%m-%d")

# make additional indicator variables to mark entries that were ...
  ## registered after completion, 
  ## registered after publication, 
  ## registered >= 1 year after study start. 
iv_sel <- iv_sel %>% 
  mutate(
    reg_after_cd = iv_sel$days_reg_to_cd < 0, 
    reg_after_pub = iv_sel$days_reg_to_publication < 0, 
    reg_1y_after_start = iv_sel$start_date + 365 < iv_sel$registration_date
  )

# ---------------------------------------------------
# Create files for analysis 
# ---------------------------------------------------

# create a dataset with all trials that passed the filtering step
# this will be used for comparative analyses 
iv_sel %>% 
  write_csv(file = "./data/raw_data/01_starrr_full.csv") %>% 
  write_rds(file = "./data/raw_data/01_starrr_full.Rds")


# create a dataset with only the trials that passed the filtering step AND are retrospective (as defined in IntoValue)
# these entries will be hand-coded to assess the reporting of retrospective registration
set.seed(947)
iv_sel %>% 
  filter(is_prospective == FALSE) %>% 
  select(id, 
         pub_title, 
         doi, 
         pmid,
         registration_date, 
         start_date, 
         completion_date, 
         has_iv_trn_abstract, 
         has_iv_trn_ft, 
         has_reg_pub_link, 
         reg_1y_after_start, 
         reg_after_cd, 
         reg_after_pub, 
         has_crossreg_eudract, 
         has_crossreg_isrctn 
         ) %>% 
  write_excel_csv(file = "./data/raw_data/03_starrr_coding_sample.csv") %>% 

  # also create a sample with publications that were registered >= 1 year after study start for a pilot screening 
  
  filter(reg_1y_after_start == TRUE) %>% 
  sample_n(replace = F, size = 20) %>%
  write_excel_csv(file = "./data/raw_data/02_starrr_coding_pilot.csv")



