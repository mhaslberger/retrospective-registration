## Analysis of the reporting of retrospective registration in clinical trial publications

----------------------------------------------------
### Project description

__Objective__: Prospective registration of clinical research has been widely implemented and advocated for many reasons: to detect and mitigate publication bias, selective reporting, and undisclosed changes in the determination of primary and secondary outcomes. Prospective registration allows for public scrutiny of trials, facilitates the identification of gaps in research, and supports the coordination of efforts by preventing unnecessary duplication. Retrospective registration undermines many of these reasons but is commonly found. We provide a comprehensive analysis of retrospective registration and the reporting thereof in publications, as well as factors associated with these practices.
__Design__: For this cross-sectional study, we used a validated dataset (1,2) of trials registered on ClinicalTrials.gov or DRKS, with a German University Medical Center as the lead center, completed between 2009 and 2017, and with at least one peer-reviewed results publication. We extracted all registration statements from all results publications of retrospectively registered trials, including mentions and justifications of retrospective registration. We analyzed associations between key trial variables and different registration and reporting practices.
__Results__: In our dataset of 1927 trials with a corresponding results publication, 956 (53.7%) were retrospectively registered. Of those, 2.2% (21) explicitly report the retrospective registration in the abstract and 3.5% (33) in the full text. In 2.1% (20) of publications, authors provide a justification/explanation for the retrospective registration in the full text. Registration numbers were significantly underreported in abstracts of retrospectively registered trials (p < 0.001). Publications in ICMJE member journals had higher rates of both prospective registration and disclosure of retrospective registration, although not statistically significant. Publications in journals claiming to follow ICMJE recommendations showed lower rates compared to non-ICMJE-following journals. 
__Conclusions__: In contrast to ICMJE guidance, retrospective registration is disclosed and explained only in a small number of retrospectively registered studies. Lack of disclosure might lead readers to wrongly interpret the registration as a quality criterion that, in the case of a retrospective registration, rather describes a concern. Disclosure of the retrospective nature of the registration would require 1-2 additional sentences in the manuscript and could be easily implemented by publishers. 
 
#### References:

1. [Riedel N, Wieschowski S, Bruckner T, Holst MR, Kahrass H, Nury E, et al. Results dissemination from completed clinical trials conducted at German university medical centers remained delayed and incomplete. The 2014 –2017 cohort. J Clin Epidemiol. 2022 Apr;144:1–7.](https://www.sciencedirect.com/science/article/pii/S0895435621004145)

2. [Wieschowski S, Riedel N, Wollmann K, Kahrass H, Müller-Ohlraun S, Schürmann C, et al. Result dissemination from clinical trials conducted at German university medical centers was delayed and incomplete. J Clin Epidemiol. 2019 Nov;115:37–45.](https://www.jclinepi.com/article/S0895-4356(21)00414-5/fulltext)

----------------------------------------------------
### Associated publications and presentations

* [Open access journal publication in BMJ Open](https://bmjopen.bmj.com/content/13/4/e069553)

* [Preprint published on MedRxiv](https://doi.org/10.1101/2022.10.09.22280784) 

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
|`icmje_journals.csv`| csv containing all journals and listed on the icmje page as member journals or journals following the icmje recommendations - moved to https://github.com/mhaslberger/icmje-journals|

#### Scripts (in the `analysis` folder)
|File|Description|
|------|------|
|`01-sample-generation.R`| import and filter the IntoValue dataset, make files for analysis, piloting and rating|
|`02-merge-ratings.R`| clean and merge the ratings with the overall dataset, annotate the dataset with data from Web of Science, EudraCT dates, and ICMJE data|
|`03-analysis.R`| main analysis |
