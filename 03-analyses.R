library(tidyverse)
library(lubridate)

# Import datasets

starrr <- read_rds(file = "./data/starrr_dataset.Rds")
# make a dataset of the retrospectively registered studies only - 
# this will be used in some of the descriptive analyses
retro <- starrr %>% filter(!(is_prospective))

# Prevalence of retrospective registration

# ------------------------------------------------
# make plot to show the prevalence of reporting of retrospective registration per publication year 

over_time1 <- starrr %>% 
  group_by(lubridate::year(starrr$publication_date)) %>% 
  summarize(retro = sum(!is_prospective), 
            total = length(is_prospective), 
            perc_retro = retro/total*100) %>% 
  rename(year = `lubridate::year(starrr$publication_date)`)

over_time2 <- retro %>%
  group_by(lubridate::year(retro$publication_date)) %>% 
  summarize(rr_date = sum(rr_date_total), 
            rr_reported = sum(rr_addressed_total), 
            rr_justified = sum(rr_justified_total), 
            rr_any = sum(rr_justified_total | rr_addressed_total), 
            perc_rr_any = rr_any / sum(!is_prospective)*100) %>% 
  rename(year = `lubridate::year(retro$publication_date)`)

pub_over_time <- over_time1 %>% 
  left_join(over_time2, by = "year")

add_years_tab1 <- data.frame(year = 2007,
                             retro = 0,
                             total = 0,
                             perc_retro = NA, 
                             rr_date = NA, 
                             rr_reported = 0, 
                             rr_justified = 0, 
                             rr_any = 0, 
                             perc_rr_any = NA)
pub_over_time <- pub_over_time %>%
  rbind(add_years_tab1) %>%
  arrange(year)

p2 <- pub_over_time %>% 
  ggplot() + 
  geom_point(aes(x = year, y = perc_rr_any, size = total)) + 
  geom_smooth(aes(x = year, y = perc_rr_any), method = "gam") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(), 
        panel.background=element_rect(fill = "white", colour = "lightgrey"), 
        panel.grid.major=element_line(colour="lightgrey", linetype = "dotted")) + 
  labs(y = "% retrospective registration reported (RRR)", size = "n trials") + 
  coord_cartesian(ylim = c(0, 20))
p22 <- pub_over_time %>% 
  ggplot() +
  theme_void() + 
  geom_text(aes(x = c(1:nrow(pub_over_time)), y = "Year (Pub.)", label = year), size = 3) + 
  geom_text(aes(x = c(1:nrow(pub_over_time)), y = "n", label = total), size = 3) + 
  geom_text(aes(x = c(1:nrow(pub_over_time)), y = " % RRR", label = round(perc_rr_any, 1)), size = 3) + 
  geom_text(aes(x = c(1:nrow(pub_over_time)), y = " RRR", label = rr_any), size = 3) + 
  theme(axis.text.y = element_text(size = 8, margin = margin(r = 0)),
        panel.spacing = unit(0, "mm"),
        strip.text = element_blank())
comb <- cowplot::plot_grid(p2, p22, align = "v", axis = "lr",
                           ncol = 1, rel_heights = c(1, 0.2))

ggsave("RRR-per-pubyear.pdf",
       comb,
       scale = 1.25,
       width = 8,
       height = 5
)

# ------------------------------------------------
# make plot for the percentage of retrospectively registered studies per start year 

start_over_time <- starrr %>% 
  group_by(lubridate::year(starrr$start_date)) %>% 
  summarize(retro = sum(!is_prospective), 
            total = length(is_prospective), 
            perc_retro = retro/total*100) %>% 
  rename(year = `lubridate::year(starrr$start_date)`)

add_years2 <- c(1993, 1994, 1995, 1996, 1997, 1999)
add_years_tab2 <- data.frame(year = add_years2,
                            retro = rep(0, length(add_years2)),
                            total = rep(0, length(add_years2)),
                            perc_retro = rep(NA, length(add_years2)))
start_over_time <- start_over_time %>%
  rbind(add_years_tab2) %>%
  arrange(year)

p3 <- start_over_time %>% 
  ggplot() + 
  geom_point(aes(x = year, y = perc_retro, size = total)) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.x=element_blank(), 
        panel.background=element_rect(fill = "white", colour = "lightgrey"), 
        panel.grid.major=element_line(colour="lightgrey", linetype = "dotted")) + 
  labs(y = "% retrospectively registered (RR)", size = "n trials") + 
  xlab("Start year") + 
  scale_y_continuous(limits = c(0,100)) + 
  geom_smooth(aes(x = year, y = perc_retro), method = "gam") 

p32 <- start_over_time %>% 
  ggplot() +
  theme_void() + 
  geom_text(aes(x = c(1:nrow(start_over_time)), y = "Year (Start)", label = year), size = 2.2) + 
  geom_text(aes(x = c(1:nrow(start_over_time)), y = "n", label = total), size = 2.2) + 
  geom_text(aes(x = c(1:nrow(start_over_time)), y = " RR", label = retro), size = 2.2) + 
  geom_text(aes(x = c(1:nrow(start_over_time)), y = " % RR", label = round(perc_retro, 1)), size = 2.2) + 
  theme(axis.text.y = element_text(size = 8, margin = margin(r = 0)),
        panel.spacing = unit(0, "mm"),
        strip.text = element_blank())
comb2 <- cowplot::plot_grid(p3, p32, align = "v", axis = "lr",
                            ncol = 1, rel_heights = c(1, 0.2))

ggsave("RR-per-startyear.pdf",
       comb2,
       scale = 1.25,
       width = 8,
       height = 5
)

# ------------------------------------------------
# ASSOCIATIONS WITH RR
# ------------------------------------------------
# the relationship between TRN reporting and retrospective registration:

# after_2005 <- starrr %>% filter(start_date > "2005-07-01")
testtable <- table(starrr$is_prospective, starrr$has_iv_trn_abstract)
testtable[1,2] # number of trn in retrospective
testtable[1,2]/(testtable[1,2]+testtable[1,1]) # percentage of trn in retrospective
testtable[2,2] # number of trn in prospective 
testtable[2,2]/(testtable[2,2]+testtable[2,1]) # percentage of trn in prospective
test <- chisq.test(testtable)
test
# ------------------------------
# The relationship between ICMJE membership/following and retrospective registration:
# first, fisher test for ICMJE membership 
testtable <- table(starrr$is_prospective, starrr$icmje_member)
testtable
test <- fisher.test(testtable)
test
# next, chisq. test for ICMJE member/following
testtable <- table(starrr$is_prospective, starrr$icmje_member|starrr$icmje_following)
testtable
test <- chisq.test(testtable)
test

# ------------------------------
# The relationship between industry sponsorship and retrospective registration:
testtable <- table(starrr$is_prospective, starrr$main_sponsor == "Industry")
testtable
test <- chisq.test(testtable)
test



# -----------

## Numbers for Table 2: 

### reg reported
sum(retro$reg_reported) # number of trials reporting registration
round(sum(retro$reg_reported)/nrow(retro)*100, 1) # percentage 

### trn reported
sum(retro$trn_reported) # number of trials reporting trn
round(sum(retro$trn_reported)/nrow(retro)*100, 1) # percentage
sum(retro$reg_reported)-sum(retro$trn_reported) # number of trials reporting reg. but not trn
round((1-((sum(retro$reg_reported)-sum(retro$trn_reported))/sum(retro$reg_reported)))*100, 1) # percentage

### trn locations
sum(retro$has_iv_trn_abstract) 
round(sum(retro$has_iv_trn_abstract)/nrow(retro)*100, 1)
sum(retro$has_iv_trn_ft)
round(sum(retro$has_iv_trn_ft)/nrow(retro)*100, 1)
sum(retro$trn_reported & !(retro$has_iv_trn_abstract) & !(retro$has_iv_trn_ft))
round(sum(retro$trn_reported & !(retro$has_iv_trn_abstract) & !(retro$has_iv_trn_ft))/nrow(retro)*100, 1)

### reg date reported
sum(retro$rr_date_total)
round(sum(retro$rr_date_total)/ nrow(retro)*100, 1)
sum(retro$ab_date)
round(sum(retro$ab_date)/ nrow(retro)*100, 1)
sum(retro$ft_date, na.rm = T)
round(sum(retro$ft_date, na.rm = T)/ nrow(retro)*100, 1)

#### date but not retro
sum(retro$rr_date_total & !(retro$rr_addressed_total))
round(sum(retro$rr_date_total & !(retro$rr_addressed_total))/nrow(retro)*100, 1)

### rr addressed
sum(retro$rr_addressed_total)
round(sum(retro$rr_addressed_total)/ nrow(retro)*100, 1)
sum(retro$ab_addressed)
round(sum(retro$ab_addressed)/ nrow(retro)*100, 1)
sum(retro$ft_addressed)
round(sum(retro$ft_addressed)/ nrow(retro)*100, 1)

### rr justified
sum(retro$rr_justified_total)
round(sum(retro$rr_justified_total)/ nrow(retro)*100, 1)
sum(retro$ab_justified)
round(sum(retro$ab_justified)/ nrow(retro)*100, 1)
sum(retro$ft_justified)
round(sum(retro$ft_justified)/ nrow(retro)*100, 1)

# ------------------------------------------------
# ASSOCIATIONS WITH RRR
# ------------------------------------------------
# The relationship between ICMJE membership/following and retrospective registration:
# first, fisher test for ICMJE membership 
testtable <- table(retro$rr_addressed_total, retro$icmje_member)
testtable
test <- fisher.test(testtable)
test
# next, chisq. test for ICMJE member/following
testtable <- table(retro$rr_addressed_total, retro$icmje_member|retro$icmje_following)
testtable
test <- chisq.test(testtable)
test



# ------------------------------
# The relationship between industry sponsorship and retrospective registration:
testtable <- table(retro$rr_addressed_total, retro$main_sponsor == "Industry")
testtable
test <- chisq.test(testtable)
test

