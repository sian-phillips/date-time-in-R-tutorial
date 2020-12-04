##################################################
## Title: Date-Time Tutorial - Part 2
## Script purpose: Learn how to work with dates and times 
##                 using the package `lubridate`.
## Date: 27/11/2020
## Author: Sian Phillips
##################################################

# Import packages 
library(lubridate)
library(ggplot2)
library(dplyr)

# Import our data
ufo_sightings <- read_csv("ufo.csv")

# View data
View(ufo_sightings)

# Remove latitude, longitude and comments from the data
# These columns are not relevent to this tutorial.
ufo <- ufo_sightings %>%
  select(-latitude,-longitude,-comments) %>%
  rename(date_posted = "date posted",
         duration_sighting_s = "duration (seconds)",
         duration_sighting_hm = "duration (hours/min)")  # Rename column names 
                                                        # that contain spaces.
  
# Inspect the data
summary(ufo)
glimpse(ufo)

# Check the class of 'datetime'
class(ufo$datetime)

# Convert 'datetime' into a dttm
ufo <- ufo %>%
  mutate(datetime = mdy_hm(datetime),
         date_posted = mdy(date_posted)) 

# Check that the character has been converted to a dttm
class(ufo$datetime)
class(ufo$date_posted)
glimpse(ufo)

# Extraction ----

ufo <- ufo %>%
  mutate(date = date(datetime))

# Time zones ----

# OlsonNames()

edinburgh <- filter(ufo, city == "edinburgh (uk/scotland)" & shape == "sphere")

(ed_datetime <- ymd_hms(edinburgh$datetime))
(tokyo_datetime <- with_tz(ed_datetime, tz = "Asia/Tokyo"))

ufo <- ufo %>%
  mutate(datetime_51 = with_tz(datetime, tz = "America/Los_Angeles"))

# Time spans ----

ufo <- ufo %>%
  mutate(time_interval = date %--% date_posted,
         time_duration = as.duration(time_interval),
         time_period = as.period(time_interval))

ufo %>% 
  count(day = floor_date(datetime, "day")) %>% 
  ggplot(aes(day, n)) +
  geom_line() 


ufo %>% 
  mutate(date = yday(date)) %>% 
  ggplot(aes(date)) +
  geom_freqpoly(binwidth = 1) +
  scale_colour_viridis_c() +
  labs(title = "",
       subtitle = "",
       x = "Day of year",
       y = "") +
  theme(text = element_text(size = 15))


           
ufo %>%
  mutate(wday = wday(datetime, label = TRUE)) %>% 
  ggplot(aes(x = wday, fill = wday)) +
  geom_bar() +
  theme_bw()+
  xlab("Day of the Week") +
  ylab("Count")
