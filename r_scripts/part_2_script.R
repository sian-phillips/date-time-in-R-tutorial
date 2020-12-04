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

ufo <- ufo %>%
  mutate(datetime_51 = with_tz(datetime, tz = "America/Los_Angeles"))


edinburgh <- filter(ufo, city == "edinburgh (uk/scotland)" & shape == "sphere")

(ed_datetime <- ymd_hms(edinburgh$datetime))
(tokyo_datetime <- with_tz(ed_datetime, tz = "Asia/Tokyo"))

# Time spans ----

ufo <- ufo %>%
  mutate(time_interval = date %--% date_posted,
         time_duration = as.duration(time_interval),
         time_period = as.period(time_interval))

# Arithmetic ----

ufo <- ufo %>%
  mutate(end_time = datetime + seconds(duration_sighting_s))

ufo_clean <- ufo %>%
  mutate(datetime = (datetime - (days(5) + minutes(5) + seconds(5))))

# Visualisations ----

year(ufo$date) <- 0

ufo %>% 
  ggplot(aes(date)) + 
  geom_freqpoly(binwidth = 1)


ufo %>%
  mutate(wday = wday(datetime, label = TRUE)) %>% 
  ggplot(aes(x = wday, fill = wday)) +
  geom_bar() +
  theme_bw()+
  xlab("Day of the Week") +
  ylab("Count")
