# "Mental Health" vs. "Mental Illness" - Lancet Correspondence
### Project examining the frequency of mental health terms in news media using the New York Times Article Search API
### Adam Chekroud & Hieronimus Loho [Yale University]

----------------------------------------


- This repository contains the python scraping scripts, raw data, processed data, and figures for our mental health in the media project. 

- It is maintained by HL, who can be reached at {hieronimus.loho@yale.edu}

Folders:

1.**Scripts**:  
* check_hits_by_term.py: Main script that you give a list of specific queries, and it will: search the NYT Article Search API, and saves a CSV for each term that states the number of articles (hits) per quarter per year since 1900.
* check_total_hits.py: This script will calculate the total number of articles in the database per quarter per year. You can use these values as a reference point to correct for the upward trend over time whereby more articles are published now than they used to.
* PreProcess.R: Takes the raw CSVs created by benchmarker.py, corrects the query hit rates for the total number of articles published, and binds all the data for your search terms into one big binary (RDS) file.
* Data_Vis_Stats.R: Does the data manipulation, visualization, and basic statistics for the terms presented in our article. 

2.**CSVs** : Folder will contain all of the CSVs created by check_hits_by_term.py and check_total_hits.py.

3.**Processed Data** : Folder will contain preprocessed data (in RDS form).

4.**Figures**  : Folder will contain the figures that we included in the article, e.g. trend in "Mental health" vs. "mental illness".

5.**terms**  : Folder will contain two .txt files: the syntactically correct search terms that get fed into the HTTP request, and the display search terms that are shortened for ease. Both are used in check_hits_by_terms.py.

Please feel free to email me {hieronimus.loho@yale.edu} if you have any questions, or if you spot anything that isn't working.
    
Please do not share or reuse these materials without permission.
We have no copyright, nor do we have money to pay lawyers to do anything about it,
but we will be sad, and [tweet](https://twitter.com/itschekkers) everyone we know to tell them you were naughty.

