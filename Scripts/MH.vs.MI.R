###Script to make the plots and run the correlation for the Lancet Psychiatry Letter
#by Adam Chekroud and Hieronimus Loho

#Load the necessary libs
libs <- c("tidyverse", "RColorBrewer","stringr", "foreach", "forcats", "dplyr")
invisible(lapply(libs, require, character.only = TRUE))

setwd("/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes")


###Set up the DFs
#Load the main RDS with all of the hits for all terms
all <- readRDS(file = "Processed_Data/all_terms_hits.RDS")

#Filter out for just mental health hits and just mental illness hits
mhmi <- all %>%
  filter(term == "mental health" | term == "mental illness")

#Group by year, creating a separate data frame for percentage by year
mhmi.yearly <- mhmi %>%
  group_by(term, year) %>%
  summarise(yearly_percentage = sum(hits)/sum(baserate) *100) %>%
  ungroup()

#Group by year, creating a separate data frame for percentage by year
mhmi.yearly <- mhmi %>%
  group_by(term, year) %>%
  summarise(yearly_percentage = sum(hits)/sum(baserate) *100) %>%
  ungroup()

#Filter out for just 'mental health or mental illness or behavioral health' 
mhmibh.vs.cancer.diabetes.hypertension <- all %>%
  filter(term == "mental health OR mental illness OR behavioral health" |
           term == "cancer" |
           term == "diabetes" |
           term == "hypertension")
#Group hits by year
mhmibh.vs.cancer.diabetes.hypertension.yearly <- mhmibh.vs.cancer.diabetes.hypertension %>%
  group_by(term, year) %>%
  summarise(yearly_percentage = sum(hits)/sum(baserate) *100) %>%
  ungroup()



###Graphs
#Plot percentage by year, since 1940
mhmi.yearly.1940.plot <- mhmi.yearly %>%
  filter(year %in% 1940:2016) %>%
  ggplot(aes(x = year, y = yearly_percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per year") +
  xlab("Year") +
  ggtitle(paste("Use of word in popular media"),
          subtitle = "NYT, Reuters, and AP sources, 1940-2016")
ggsave(mhmi.yearly.1940.plot, 
       file = "Figures/mental health vs. mental illness/mental_health_vs_illness.1940.yearly.pdf",
       height = 7.07, width = 11)
ggsave(mhmi.yearly.1940.plot, 
       file = "Figures/mental health vs. mental illness/mental_health_vs_illness.1940.yearly.eps",
       height = 7.07, width = 11)

#Plot percetage by quarter since 1960
mhmi.quarterly.1960.plot <- mhmi %>%
  filter(year %in% 1960:2016) %>%
  ggplot(aes(x = timept, y = percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per quarter") +
  xlab("Year") +
  ggtitle(paste("Use of word in popular media"),
          subtitle = "NYT, Reuters, and AP sources, 1960-2016")
ggsave(mhmi.quarterly.1960.plot, 
       file = "Figures/mental health vs. mental illness/mental_health_vs_illness.1960.quarterly.pdf",
       height = 7.07, width = 11)
#Plot percentage by year, since 1960
mhmi.yearly.1960.plot <- mhmi.yearly %>%
  filter(year %in% 1960:2016) %>%
  ggplot(aes(x = year, y = yearly_percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per year") +
  xlab("Year") +
  ggtitle(paste("Use of word in popular media"),
          subtitle = "NYT, Reuters, and AP sources, 1960-2016")
ggsave(mhmi.yearly.1960.plot, 
  file = "Figures/mental health vs. mental illness/mental_health_vs_illness.1960.yearly.pdf",
  height = 7.07, width = 11)

#Plot the Mental Health/Mental Illness/Behavioral Health vs Cancer vs Diabetes vs Hypertension graph 
#by quarter since 1960
mhmibh.vs.cancer.diabetes.hypertension.quarterly.1960.plot <- mhmibh.vs.cancer.diabetes.hypertension %>%
  filter(year %in% 1960:2016) %>%
  ggplot(aes(x = timept, y = percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per quarter") +
  xlab("Year") +
  theme(legend.position = "bottom") +
  ggtitle(paste("Use of word in popular media"),
          subtitle = "NYT, Reuters, and AP sources, 1960-2016")
ggsave(mhmibh.vs.cancer.diabetes.hypertension.quarterly.1960.plot, 
       file = "Figures/mental health vs. mental illness/mhmibh.vs.cancer.diabetes.hypertension.quarterly.1960.pdf",
       width = 11, height = 7.07)
#Plot the Mental Health/Mental Illness/Behavioral Health vs Cancer vs Diabetes vs Hypertension graph 
#by year since 1960
mhmibh.vs.cancer.diabetes.hypertension.yearly.1960.plot <- mhmibh.vs.cancer.diabetes.hypertension.yearly %>%
  filter(year %in% 1960:2016) %>%
  ggplot(aes(x = year, y = yearly_percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per year") +
  xlab("Year") +
  theme(legend.position = "bottom") +
  ggtitle(paste("Use of word in popular media by year"),
          subtitle = "NYT, Reuters, and AP sources, 1960-2016")
ggsave(mhmibh.vs.cancer.diabetes.hypertension.yearly.1960.plot, 
       file = "Figures/mental health vs. mental illness/mhmibh.vs.cancer.diabetes.hypertension.yearly.1960.pdf",
       width = 11, height = 7.07)

#Plot the Mental Health/Mental Illness/Behavioral Health vs Diabetes vs Hypertension graph 
#by year since 1940
mhmibh.vs.diabetes.hypertension.yearly.1940.plot <- mhmibh.vs.cancer.diabetes.hypertension.yearly %>%
  filter(year %in% 1940:2016) %>%
  filter(term != "cancer") %>%
  ggplot(aes(x = year, y = yearly_percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per quarter") +
  xlab("Year") +
  # theme(legend.position = "bottom") +
  ggtitle(paste("Use of word in popular media by year"),
          subtitle = "NYT, Reuters, and AP sources, 1940-2016")
ggsave(mhmibh.vs.diabetes.hypertension.yearly.1940.plot, 
       file = "Figures/mental health vs. mental illness/mhmibh.vs.diabetes.hypertension.yearly.1940.pdf",
       width = 11, height = 7.07)
ggsave(mhmibh.vs.diabetes.hypertension.yearly.1940.plot, 
       file = "Figures/mental health vs. mental illness/mhmibh.vs.diabetes.hypertension.yearly.1940.eps",
       width = 11, height = 7.07)

#Plot the Mental Health/Mental Illness/Behavioral Health vs Diabetes vs Hypertension graph 
#by year since 1960
mhmibh.vs.diabetes.hypertension.yearly.1960.plot <- mhmibh.vs.cancer.diabetes.hypertension.yearly %>%
  filter(year %in% 1960:2016) %>%
  filter(term != "cancer") %>%
  ggplot(aes(x = year, y = yearly_percentage, colour = term)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, lty = 2, alpha = 0.4) + 
  theme_bw() +
  scale_x_continuous(breaks = seq(1900,2010,10)) +
  ylab("% of total articles per quarter") +
  xlab("Year") +
  # theme(legend.position = "bottom") +
  ggtitle(paste("Use of word in popular media by year"),
          subtitle = "NYT, Reuters, and AP sources, 1960-2016")
ggsave(mhmibh.vs.diabetes.hypertension.yearly.1960.plot, 
       file = "Figures/mental health vs. mental illness/mhmibh.vs.diabetes.hypertension.yearly.1960.pdf",
       width = 11, height = 7.07)

#Stats analysis
#Correlation of 'mental health' and 'mental illness' hits since 1940
mhmi.yearly.spread.1940 <- mhmi.yearly %>%
  spread(term, yearly_percentage) %>%
  filter(year %in% 1940:2016) 
mhmi.yearly.spread.1940.cor <- cor.test(mhmi.yearly.spread.1940$"mental health", mhmi.yearly.spread.1940$"mental illness")

#Correlation of 'mental health' and 'mental illness' hits since 1960
mhmi.yearly.spread.1960 <- mhmi.yearly %>%
  spread(term, yearly_percentage) %>%
  filter(year %in% 1960:2016) 
mhmi.yearly.spread.1960.cor <- cor.test(mhmi.yearly.spread.1960$"mental health", mhmi.yearly.spread.1960$"mental illness")

