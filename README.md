# Mental Health vs. Mental Illness Lancet Paper
### Project examining the frequency of mental health terms in news media using the New York Times Article Search API
### Adam Chekroud and Hieronimus Loho, [Yale University]

----------------------------------------


- This repository contains the python scraping scripts, raw data, processed data, and figures for our mental health in the media project. 

Folders:

1.**Scripts**:  
* benchmarker.py: Main scraping script that takes in a list of terms, searches the NYT Article Search API, and saves a CSV of each term,     stating the number of articles (hits) per quarter per year since 1900. 
* MH.vs.MI.R: Does the data manipulation, visualization, and some statistics for the terms relevant to our article. 
* plot_all.R: Plots all of the terms in a very basic way and combines them into a single PDF. Does this for data since 1900, since 1960,   since 1966, since 1996, since 2006, and since 2011, with a separate PDF for each timeframe. 
* PreProcess.R: Takes the raw CSVs created by benchmarker.py, calculates the percentage of articles containing the term, binds data for     all the terms into one big RDS file.
* total_articles.py: Scrapes the NYT API Article Search for the total number of articles written by the NYT per quarter per year, just as   a reference point so that we can calculate the percentage (in the PreProcess.R script).

2.**CSVs** : Contains all of the CSVs created by benchmarker.py and total_articles.py.

3.**Processed Data** : Contains the aggregate RDS made by PreProcess.R that contains all terms. 

4.**Figures** 
* All_basic: Very basic figures created by the plot_all.R script.
* Mental health vs. mental illness: Figures shown in the article, created by the MH.vs.MI.R script.

Please feel free to email me if you have any questions, or if you spot anything that isn't working: hieronimus.loho@yale.edu
    
