## setup
library(plyr)
library(tidyverse)
library(reshape)
library(scales)

## import data
city_evictions = read.csv(file = "~/Desktop/work/data/r/VA_evictions_project/cities.csv")
county_evictions = read.csv(file = "~/Desktop/work/data/r/VA_evictions_project/counties.csv")
