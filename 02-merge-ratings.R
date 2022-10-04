library(tidyverse)

# ---------------------------------------------------
# Load and prepare files  
# ---------------------------------------------------

# read in the files from the rating 
ratings <- read_tsv(file = "./data/final_rating/starrr_ratings_final.txt") %>% 
  select(id,
         trn_reported, 
         trn_location, 
         reg_reported, 
         reg_location, 
         reg_wording, 
         ab_addressed, 
         ab_justified, 
         ab_date, 
         ab_wording, 
         ft_addressed, 
         ft_justified, 
         ft_date, 
         ft_wording, 
         rr_addressed_total, 
         rr_justified_total, 
         rr_date_total, 
         comment, 
         exclude, 
         pub_eudra_nr)

## re-format EUCTR numbers as they are not in a consistent format 
for (i in nrow(ratings$pub_eudra_nr)) {
  if (ratings$pub_eudra_nr[i]=="NA") next 
  else (paste0(substr(ratings$pub_eudra_nr[i], 1,4), "-", 
               substr(ratings$pub_eudra_nr[i], 6,11), "-", 
               substr(ratings$pub_eudra_nr[i], 13,15)))
}


# check structure
ratings %>% 
  as.data.frame() %>% 
  head()
# View(ratings)

# read in the full dataset
iv_sel <- read_rds(file = "./data/raw_data/01_starrr_full.Rds") %>% 
  select(id, 
         registry, 
         main_sponsor,
         intervention_type, 
         phase, 
         masking, 
         allocation, 
         is_randomized, 
         is_prospective, 
         has_summary_results, 
         registration_date, 
         start_date, 
         completion_date, 
         completion_year, 
         publication_date, 
         doi, 
         pmid, 
         pub_title, 
         epub_date, 
         journal_pubmed, 
         journal_unpaywall, 
         has_iv_trn_abstract,
         has_iv_trn_ft, 
         has_crossreg_eudract,            
         is_publication_2y,  
         is_publication_5y, 
         color,                           
         issn,
         publisher,      
         is_oa
         )


# ---------------------------------------------------
# Merge ratings with the full dataset
# ---------------------------------------------------

# check if all ids match 
table(iv_sel$id %in% ratings$id)

# merge
starrr <- iv_sel %>% 
  left_join(ratings, 
            by = "id") %>% 
  mutate_at(vars("exclude"), ~replace_na(.,0))


# ---------------------------------------------------
# Add ICMJE status 
# ---------------------------------------------------

icmje <- read_csv(url("https://raw.githubusercontent.com/mhaslberger/icmje-journals/main/icmje_journals.csv"))

starrr <- starrr %>% 
  mutate(icmje_member = toupper(journal_pubmed) %in% icmje$journal[icmje$icmje == "ICMJE member"] | 
           toupper(journal_unpaywall) %in% icmje$journal[icmje$icmje == "ICMJE member"], 
         icmje_following = toupper(journal_pubmed) %in% icmje$journal[icmje$icmje == "ICMJE following"] | 
           toupper(journal_unpaywall) %in% icmje$journal[icmje$icmje == "ICMJE following"])


# # ---------------------------------------------------
# # Add registry-based crossregistration numbers from Maia Salholz-Hillel's project
# # ---------------------------------------------------
# 
# # Downlaod the TRNs of EUCTR-cross-registered trials
# # crossreg <- readRDS(url("https://github.com/maia-sh/intovalue-data/blob/main/data/processed/registries/registry-crossreg.rds"))
# crossreg <- read_csv("data/registry-crossreg.csv") %>%
#   filter(crossreg_registry == "EudraCT")
# 
# starrr <- starrr %>%
#   left_join(select(crossreg, c(id, crossreg_trn)), by = "id") %>% 
#   rename(reg_eudra_nr = crossreg_trn)
# 
# # check the overlap between reported crossregistrations in publication and registry 
# table(!is.na(starrr$reg_eudra_nr), !is.na(starrr$pub_eudra_nr)) 
# # --> only about 60% of publication-reported crossregs were also reported in the registry

# # ---------------------------------------------------
# # Check cross-registrations in EUCTR for publications in retrospective set 
# # ---------------------------------------------------
# # 
# # Commented out because we're not looking whether the EUCTR entries are prospective, only if they exist, then assume that they are prospective
# # 
# library(euctrscrape)
# 
# # Check the euctr for studies that were registered prospectively there, 
# # based on registration numbers reported in ... 
# #   a) the publication
# #   b) the DRKS or ClinicalTrials.gov registry entry 
# 
# # ---------------------------------------------------
# 
# 
# ## take all the entries in the dataset of publications that reported  a EudraCT number 
# eudra <- starrr %>% 
#   filter(!(pub_eudra_nr == "NA")) %>% 
#   select(id, pub_eudra_nr) %>% 
#   rename(trn = pub_eudra_nr)
# 
# ## make an empty dataframe for registration dates
# eudradates <- tribble(
#   ~trn,
#   ~first_reg_date
# )
# 
# ## download the registration dates for each trial
# for (trn in eudra$trn) {
#   frdate <- euctr_reg_dates(trn)[1]
#   
#   if (is.null(frdate)) {
#     frdate <- NA
#   }
#   
#   rdates <- tribble(
#     ~trn, ~first_reg_date,
#     trn, frdate
#   )
#   
#   eudradates <- eudradates %>%
#     bind_rows(rdates)
# }
# 
# trialdetails <- tribble(
#   ~trn,
#   ~start_date,
#   ~trial_results,
#   ~pub_date,
#   ~global_completion_date
# )
# 
# ## Download the trial details for each trial
# for (trn in eudra$trn) {
#   
#   details <- euctr_details(trn) %>%
#     as_tibble()
#   
#   trialdetails <- trialdetails %>%
#     bind_rows(details)
#   
# }
# 
# ## Combine the registration dates and the other trial details into a single data frame
# eudra <- eudradates %>%
#   left_join(trialdetails, by = "trn") %>% 
#   unique()
# 
# # add a binary variable to the dataset whether the eudra registration was prospective
# library(lubridate)
# dateCols <- c("first_reg_date", "start_date", "pub_date", "global_completion_date")
# eudra[dateCols] <- lapply(eudra[dateCols], lubridate::ymd)
# eudra$prospective <- ifelse(
#   eudra$first_reg_date < eudra$start_date, 1, 0)
# 
# eudra <- eudra %>% 
#   rename(pub_eudra_nr = trn, 
#   pub_eudra_prospective = prospective)
# starrr <- starrr %>%
#   left_join(select(eudra, c(pub_eudra_nr, pub_eudra_prospective)), by = "pub_eudra_nr")  %>% 
#   mutate_at(vars("pub_eudra_prospective"), ~replace_na(.,0))
# 
# ## Write results
# eudra %>%
#   write_csv("./data/raw_data/starrr-euctr-publication-crossregistrations.csv")
# # eudra <- tibble(read.csv("./data/raw_data/starrr-euctr-publication-crossregistrations.csv"))
# 
# 
# 
# # ---------------------------------------------------
# # Add cross-registration data from the registries
# # ---------------------------------------------------
# # b) Load files for the registry rating
# 
# # Downlaod the TRNs of EUCTR-cross-registered trials
# # crossreg <- readRDS(url("https://github.com/maia-sh/intovalue-data/blob/main/data/processed/registries/registry-crossreg.rds"))
# crossreg <- read_csv("data/registry-crossreg.csv") %>%
#   filter(crossreg_registry == "EudraCT")
# 
# # take the TRNs of cross-registrations that were added before
# eudra <- starrr %>%
#   filter(!is.na(reg_eudra_nr)) %>% 
#   select(id, start_date, reg_eudra_nr)
# 
# ## make an empty dataframe for registration dates
# eudradates <- tribble(
#   ~trn,
#   ~first_reg_date
# )
# 
# ## download the registration dates for each trial
# for (trn in eudra$reg_eudra_nr) {
#   frdate <- euctr_reg_dates(trn)[1]
# 
#   if (is.null(frdate)) {
#     frdate <- NA
#   }
# 
#   rdates <- tribble(
#     ~trn, ~first_reg_date,
#     trn, frdate
#   )
# 
#   eudradates <- eudradates %>%
#     bind_rows(rdates)
# }
# 
# eudradates <- eudradates %>% 
#   rename("reg_eudra_nr" = "trn")
# 
# ## Combine the registration dates and the other trial details into a single data frame
# eudra <- eudra %>%
#   left_join(eudradates, by = "reg_eudra_nr") %>% 
#   unique()
# 
# # add a binary variable to the dataset whether the eudra registration was prospective
# dateCols <- c("first_reg_date", "start_date")
# eudra[dateCols] <- lapply(eudra[dateCols], lubridate::ymd)
# eudra$prospective <-
#   ifelse(eudra$first_reg_date < eudra$start_date, 1, 0)
# 
# eudra <- eudra %>% rename(reg_eudra_prospective = prospective)
# 
# # add to the dataset 
# starrr <- starrr %>%
#   left_join(select(eudra, c(reg_eudra_nr, reg_eudra_prospective)), by = "reg_eudra_nr")
# 
# 
# ## Write results
# eudra %>%
#   write_csv("./data/raw_data/starrr-euctr-registry-crossregistrations.csv")
# # eudra <- tibble(read.csv("./data/raw_data/starrr-euctr-registry-crossregistrations.csv"))
# 


# ---------------------------------------------------
# Exclude studies that need to be filtered out from the retro set 
# ---------------------------------------------------
table(starrr$is_prospective, starrr$exclude)
table(starrr$is_prospective, is.na(starrr$pub_eudra_nr))
table(starrr$is_prospective, is.na(starrr$reg_eudra_nr))

# remove entries that are not results publications 
starrr_ex <- starrr %>% 
  filter(!(exclude == 1)) %>% 
  select(-exclude) 

# count all trials that point to a euctr registration in the publication as prospectively registered
starrr_ex[!is.na(starrr_ex$pub_eudra_nr),]$is_prospective <- TRUE  



# ---------------------------------------------------
# Save the dataset
# ---------------------------------------------------


starrr_ex %>% 
  write_csv(file = "./data/starrr_dataset.csv") %>% 
  write_rds(file = "./data/starrr_dataset.Rds")




