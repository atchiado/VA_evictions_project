## setup
library(plyr)
library(tidyverse)
library(reshape)
library(scales)

## import data
city_evictions = read.csv(file = "~/Desktop/work/data/r/VA_evictions_project/cities.csv")
county_evictions = read.csv(file = "~/Desktop/work/data/r/VA_evictions_project/counties.csv")



########## DATA CLEANING ##########

## remove cities & counties with less than 1500 residents and more than 80% renter occupied housing
county_evictions <- filter(county_evictions, population >= 20000, pct.renter.occupied <= 80)
city_evictions <- filter(city_evictions, population >= 1500, pct.renter.occupied <= 80)

## subset the data frame to only include major cities
city1 <- city_evictions %>% filter(name %in% c("Virginia Beach", "Norfolk", "Chesapeake",
                                               "Arlington", "Richmond", "Newport News", "Hampton", 
                                               "Alexandria", "Portsmouth", "Roanoke", 
                                               "Charlottesville", "Lynchburg"))

## filter to only include the variables that we want to display
city2 <- city1 %>% select(year, name, eviction.rate)

## transform to long data structure
city3 <- pivot_longer(data = city2, cols = -c(1:2), names_to = 'var',
                      values_to = 'rate')

## convert name variable to a factor in order to sort the plot and rate variable to discrete
city_final <- city3 %>%
  mutate(name = factor(name, levels = rev(sort(unique(name)))))