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



########## DATA VIZ ##########

## create a heat map to visualize key variables by county
textcol <- "grey40"

heatmap <- ggplot(city_final, aes(x = factor(year), y = name, fill = rate)) +
  geom_tile(colour = "white", size = 0.2) +
  labs(x = "", y = "Cities",
       title = "Eviction Rates in Major Virginia Cities (2000-2016)") +
  scale_y_discrete(expand = c(0, 0)) +
  scale_x_discrete(expand = c(0, 0), breaks = c("2000", "2004", "2008", "2012", "2016")) +
  scale_fill_gradient(name = "Eviction Rate (%)", low = "#ffffcc", high = "#0c2c84", na.value = "grey90") +
  theme_grey(base_size = 10) +
  theme(legend.position = "right", legend.direction = "vertical",
        legend.title = element_text(colour = textcol),
        legend.margin = margin(grid::unit(0, "cm")),
        legend.text = element_text(colour = textcol, size = 7, face="bold"),
        legend.key.height = grid::unit(0.8, "cm"),
        legend.key.width = grid::unit(0.2, "cm"),
        axis.text.x = element_text(size = 10, colour = textcol),
        axis.text.y = element_text(vjust = 0.2, colour = textcol),
        axis.ticks = element_line(size = 0.4),
        plot.background = element_blank(),
        panel.border = element_blank(),
        plot.margin = margin(0.7, 0.4, 0.1, 0.2, "cm"),
        plot.title = element_text(colour = textcol, hjust=0, size=14, face="bold")
  )

## print heatmap
heatmap
