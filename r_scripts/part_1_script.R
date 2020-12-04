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

online_exam <- ymd_hms("03-19-2006 20:30:10", tz = "Europe/London")
with_tz(online_exam, "Australia/Perth")

wrong_time <- force_tz(online_exam, "Australia/Perth")
with_tz(wrong_time, "Europe/London")

# Periods, durations and intervals: ----

# Create start and end times

start <- ymd_hms("20060120 20:30:10", tz = "Europe/London") # Create start time
end <- ymd_hms("20060316 05:05:05", tz = "Europe/London") # Create end time (after start time)

(interval <- start %--% end) 
# You could also use, 
# interval <- interval(start, end)
str(interval)

(duration <- as.duration(interval))
str(duration)

(period <- as.period(interval))
str(period)

# Date time inherent problems: ----

WT <- ymd_hms("20200328 20:00:00", tz = "Europe/London") # Start date and time in winter time
ST <- ymd_hms("20200329 20:00:00", tz = "Europe/London") # End date and time in summer time

(clocks_change <- WT %--% ST)
str(clocks_change)

(duration <- as.duration(clocks_change))
str(duration)

(period <- as.period(clocks_change))
str(period)

# Difftimes ----

ww1 <- dmy("11 November 1918") - dmy("28 July 1914")

as.duration(ww1)

# Duration and period constructors: ----

(d <- dyears(9:15) + dmonths(5:11))
(p <- minutes(c(20,30,40)) + hours(c(2, 14,23)) + seconds(c(59,1,5)))

# Explore intervals: ----

# Create an interval, set the start and end dates of each of their holidays 
jack_holiday <- ymd("2021-05-05") %--% ymd("2021-06-23")
jill_holiday <- ymd("2021-06-04") %--% ymd("2021-06-29")

# Let's check if Jill's holiday lies within Jack's?
jill_holiday %within% jack_holiday

# Change the start time of Jill's holiday
int_start(jill_holiday) <- ymd(20210505) # Opposite is 'int_end'

# Check whether if the holidays share a boundary
int_aligns(jack_holiday, jill_holiday)

# What is the length of Jack's holiday in seconds
int_length(jack_holiday)

# Shift Jack's whole holiday forward by 5 days
int_shift(jack_holiday, days(5)) # Her if we use a negative number the the dates will shift backwards

# Arithmetic with classes of timespans: ----

# 1.
ww1_end <- dmy("28 July 1914") 
ww1_end + days(10) + months(4) # Adding a date and two periods

# 2. 

4 * (years(2) + months(6) + days(1))
9 * dyears(1)

# 3.

dyears(1) / ddays(365)
years(1) / days(1)


