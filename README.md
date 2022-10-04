## Analysis of the reporting of retrospective registration in clinical trial publications

----------------------------------------------------
### Project description

__Objective__: Preregistration of clinical research has been widely implemented and advocated for many reasons: to detect and mitigate publication bias, selective reporting, and undisclosed changes in determination of primary and secondary outcomes. Prospective registration allows for public scrutiny of trials, identify research gaps and to support the coordination of efforts by preventing unnecessary duplication. Retrospective registration undermines many of these reasons but is commonly found. We provide a comprehensive analysis of retrospective registration and the reporting thereof in publications, as well as factors associated with these practices. 

__Design__: From an analysis conducted previously in the [Strech Group](https://www.bihealth.org/de/translation/innovationstreiber/quest-center/teams/ag-strech), I use a validated and previously published dataset (1,2) of trials registered on ClinicalTrials.gov or DRKS, with a German University Medical Center as the lead center, completed between 2009 and 2017, and with at least one peer-reviewed results publication. From all results publications of retrospectively registered trials, I extracted all registration statements, including mentions and justifications of retrospective registration. I analyze associations between key trial variables and different registration and reporting practices.

__Results__: Based on our analysis of 1030 retrospectively registered CTs, 2,0% (21) explicitly report the retrospective registration in the abstract and 3.3% (34) in the full text. In 2.3% (24) of publications, a justification/explanation is provided in the full text. Analyses are ongoing – we will present full results at the conference, including a qualitative analysis of the reasons given for retrospective registration, as well as trends over time and exploratory analyses of the associations between retrospective registration and other reporting practices such as registration number reporting and cross-registration practices between different registries.  

__Conclusions__: Disclosure of retrospective registration would be a positive signal for rigor as the registrants would feel it critical to transparently report this limitation. However, only a small number of retrospectively registered studies report the retrospective nature of the registration. Lack of disclosure might lead readers to wrongly interpret the registration as a quality criterion that, in the case of a retrospective registration, rather describes a concern. Our study provides a detailed analysis of this issue.
 
#### References:

1. [Riedel N, Wieschowski S, Bruckner T, Holst MR, Kahrass H, Nury E, et al. Results dissemination from completed clinical trials conducted at German university medical centers remained delayed and incomplete. The 2014 –2017 cohort. J Clin Epidemiol. 2022 Apr;144:1–7.](https://www.sciencedirect.com/science/article/pii/S0895435621004145)

2. [Wieschowski S, Riedel N, Wollmann K, Kahrass H, Müller-Ohlraun S, Schürmann C, et al. Result dissemination from clinical trials conducted at German university medical centers was delayed and incomplete. J Clin Epidemiol. 2019 Nov;115:37–45.](https://www.jclinepi.com/article/S0895-4356(21)00414-5/fulltext)

----------------------------------------------------
### Associated publications and presentations

* Publication coming soon... 

* Poster presentation at the [_9th International Congress on Peer Review and Scientific Publication_](https://peerreviewcongress.org) in Chicago, 08-10 Sep 2022

----------------------------------------------------
### Repository structure

#### Data (in the `data` folder)
|File|Description|
|------|------|
|raw_data/`IntoValue-2020-02-22.csv`| static copy of the [IntoValue dataset provided by `maia-sh`](https://github.com/maia-sh/intovalue-data)|
|raw_data/`01_starrr_full.*`|csv and Rds file of all selected entries of IntoValue after the filtering (prospective and retrospective) |
|raw_data/`02_starrr_coding_pilot.csv`| csv of a pilot sample of 20 used to test the rater agreement during the publication screening|
|raw_data/`03_starrr_coding_sample.csv`| csv of the full sample of retrospectively registered trials for which publications were assessed in this study|
|final_rating/`starrr_ratings_final.csv`| csv of the ratings (ratings were orignally done in a xlsx file, which was exported to csv|
|`starrr_dataset.*`| csv and Rds file of the __FINAL DATASET__, annotated with EudraCT dates, WoS metadata and ICMJE data|
|`icmje_journals.csv`| csv containing all journals and listed on the icmje page as member journals or journals following the icmje recommendations |

#### Scripts (in the `analysis` folder)
|File|Description|
|------|------|
|`01-sample-generation.R`| import and filter the IntoValue dataset, make files for analysis, piloting and rating|
|`02-merge-ratings.R`| clean and merge the ratings with the overall dataset, annotate the dataset with data from Web of Science, EudraCT dates, and ICMJE data|
|`get-eudract-data.R`| scrape the EudraCT database for key trial metadata|
|`get-icmje-journals.R`| scrape the contents of the ICMJE page to get a list of journals following the recommendations and member journals (see `icmje_journals.csv`)|
|`03-analysis.Rmd`| main analysis and report generation |
