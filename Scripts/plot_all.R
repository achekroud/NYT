## Script to plot trends in use of words in the NYT over time
## AM Chekroud & H Loho

# Housekeeping
libs <- c("tidyverse", "RColorBrewer","stringr", "foreach", "forcats", "dplyr")
invisible(lapply(libs, require, character.only = TRUE))

# # Figure out the user and choose the data path accordingly
user = system("whoami",intern=TRUE)
if(user == "adamchekroud"){
  dat_path <- "/Users/adamchekroud/Documents/Phd/Projects/NYT/NYT_Mental_Health_Trends"
} else {
  load_path <- "/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes/Processed_Data"
  save_path <- "/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes/Figures/All_basic"
}

setwd(load_path)
wd <- getwd()

all <- readRDS(file = "all_terms_hits.RDS")

#Make a plotting function
### Plot number of articles per quarter, Q1-2006 to Q3-2016
plotall <- function(query, start_year) {
  all %>%
    dplyr::filter(term == query) %>%
    dplyr::filter(!(year < start_year)) %>%
    ggplot(aes(x = timept, y = percentage)) + 
    geom_line() +
    stat_smooth(method = "loess", se = FALSE, lty = 2, alpha = 0.4) + 
    stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.1) + 
    theme_bw() +
    scale_x_continuous(breaks = seq(start_year,2010,10)) +
    ylab("% of total articles per quarter") +
    xlab("Year") +
    ggtitle(paste("Use of word '", query, "' in popular media", sep = ''),
            subtitle = paste("NYT, Reuters,and AP sources,", toString(start_year), "-2016", sep = ""))
}


#Graph with lapply and save all the graphs into the same pdf
setwd(save_path)
pdf("all.basic.1900-2016.pdf", width=11, height=7.07)
search_terms <- unique(all$term)
all.plots <- lapply(search_terms, function(x) plotall(x, 1900))
all.plots

dev.off()

#Adjust the timeframes for each term to 1960 and save a new set of graphs
pdf("all.basic.1960-2016.pdf", width=11, height=7.07)
all.1960 <- all %>% 
  filter(year %in% 1960:2016)
search_terms.1960 <- unique(all.1960$term)
all.1960.plots <- lapply(search_terms.1960, function(x) plotall(x, 1960))
all.1960.plots

dev.off()
  
#Adjust the timeframes for each term to 1980 and save graphs
pdf("all.basic.1980-2016.pdf", width=11, height=7.07)
all.1980 <- all %>% 
  filter(year %in% 1980:2016)
search_terms.1980 <- unique(all.1980$term)
all.1980.plots <- lapply(search_terms.1980, function(x) plotall(x, 1980))
all.1980.plots

dev.off()

#Adjust the timeframes for each term to 1986 and save graphs
pdf("all.basic.1986-2016.pdf", width=11, height=7.07)
all.1986 <- all %>% 
  filter(year %in% 1986:2016)
search_terms.1986 <- unique(all.1986$term)
all.1986.plots <- lapply(search_terms.1986, function(x) plotall(x, 1986))
all.1986.plots

dev.off()

#Adjust the timeframes for each term to 2006
pdf("all.basic.2006-2016.pdf", width=11, height=7.07)
all.2006 <- all %>% 
  filter(year %in% 2006:2016)
search_terms.2006 <- unique(all.2006$term)
all.2006.plots <- lapply(search_terms.2006, function(x) plotall(x, 2006))
all.2006.plots

dev.off()
