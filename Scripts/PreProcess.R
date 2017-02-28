## Script to plot trends in use of word "Mental health" in the last 20 years
## AM Chekroud & H Loho

# Housekeeping
libs <- c("tidyverse", "RColorBrewer","stringr", "foreach", "forcats", "dplyr")
invisible(lapply(libs, require, character.only = TRUE))

# # Figure out the user and choose the data path accordingly
user = system("whoami",intern=TRUE)
if(user == "adamchekroud"){
  dat_path <- "/Users/adamchekroud/Documents/Phd/Projects/NYT/NYT_Mental_Health_Trends"
} else {
  save_path <- "/Users/hieronimusloho/Box Sync/Research Stuff/NYT/Processed_Data"
  hits_path <- "/Users/hieronimusloho/Box Sync/Research Stuff/NYT/CSVs/"
}

setwd(hits_path)
wd <- getwd()

#Read in the CSV of total articles per quarter, our baserate
total.raw <- read.csv("total_per_quarter(no_oldest_sort)_1900to2016.csv", as.is = TRUE)

total <- total.raw 

#Change 'Hits' to 'baserate'
colnames(total)[1:3] <- c("baserate", "quarter", "year")

#Code variable for year and quarter as Q1 = .0, Q2=0.25, Q3=0.5,Q4=0.75
total$timept <- total$year + 0.25*(total$quarter - 1)

#Read in and bind all my CSVs into the massive df
all.raw <- lapply(list.files()[which(list.files() != "total_per_quarter(no_oldest_sort)_1900to2016.csv")],
                  function(x) read.csv(x, as.is=TRUE)) %>% 
  bind_rows() 
#Process to get the date from string into a numeric value
all <- all.raw %>% 
  distinct() 
all$timept <- all$year + 0.25*(all$quarter - 1)

#Process the data to just get the term, timept, art_count, baserate, and percentage variables
all <- all %>% 
  left_join(., total[,c("timept", "baserate")], by = "timept") %>%
  mutate(percentage = 100*(hits/baserate))

setwd(save_path) 
saveRDS(all, file = "all_terms_hits.RDS" )