##################################################
## Title: Date-Time Tutorial - Part 1
## Script purpose: Learn how to work with dates and times 
##                 using the package `lubridate`.
## Date: 27/11/2020
## Author: Sian Phillips
##################################################

# Load packages

# install.packages("lubridate")
# install.packages("ggplot2")
# install.packages("dplyr")

library(lubridate)
library(ggplot2)
library(dplyr)

# Parsing dates and times: ----

ymd("20060319")

mdy("03-19-2006")

dmy("19/03/2006")

hms("20:30:10")

mdy_hms("03-19-2006 20:30:10")

# Use an accessor function to get a component: ----

datetime <- mdy_hms("03-19-2006 20:30:10")

# Self explanatory date extractions.
date(datetime)
year(datetime)
month(datetime)
day(datetime)

# Self explanatory time extractions.
hour(datetime)
minute(datetime)
second(datetime)

# Some iteresting extractions, explore what they do, 
# use the help function in R studio to understand the parameters. 
week(datetime)
quarter(datetime)
semester(datetime)

# Assign into an accessor function to change a component in place: ----

# Examples of setting a component, explore the other options.
date(datetime) <- 5
hour(datetime) <- 14

# Time zones: ----

# OlsonNames()

online_exam <- ymd_hms("2020-12-15 13:00:00", tz = "Europe/London")
with_tz(online_exam, "Australia/Perth")

wrong_time <- force_tz(online_exam, "Australia/Perth")
with_tz(wrong_time, "Europe/London")

# Periods, durations and intervals: ----

# Create start and end times
start <- ymd_hms("20060120 20:30:10", tz = "Europe/London")
end <- ymd_hms("20060316 05:05:05", tz = "Europe/London")

interval <- start %--% end
interval
str(interval)

duration <- as.duration(interval)
duration
str(duration)

period <- as.period(interval)
period
str(period)

# Date time inherent problems: ----

WT <- ymd_hms("20200328 20:00:00", tz = "Europe/London")
ST <- ymd_hms("20200329 20:00:00", tz = "Europe/London")

(clocks_change <- WT %--% ST)
str(clocks_change)

(duration <- as.duration(clocks_change))
str(duration)

(period <- as.period(clocks_change))
str(period)

# Arithmetic with classes of timespans: ----

# 1. Durations

(ww1 <- dmy("11 November 1918") - dmy("28 July 1914"))

as.duration(ww1)

# 2. Periods

seconds(55)
minutes(c(15, 30, 45))
days(2:5)
weeks(3)

ww1_end <- dmy("28 July 1914") 
ww1_end + days(10) + months(4)

# Set the start and end dates of each of their holidays 
jack_holiday <- ymd("2021-05-05") %--% ymd("2021-06-23")
jill_holiday <- ymd("2021-06-04") %--% ymd("2021-06-29")

# 
jill_holiday %within% jack_holiday

int_start(jill_holiday) <- ymd(20210505)

int_aligns(jack_holiday, jill_holiday)

int_length(jack_holiday)

int_shift(jack_holiday, days(5))


