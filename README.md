<h1>Cyclistic Bike-Share Project</h1>

<h2>Description</h2>
Project consisted of review data sets from Cyclistic bike share company, Q1 2019 & Q1 2020 to examine the differnet riding habits for casual riders and member riders. The business problem was to inform the marketing team about possible digital marketing targets to convert casual riders into members.
<br />


<h2>Languages and Utilities Used

- <b>'R'</b> 
- <b>RStudio</b>

<h2>Environments Used</h2>

- <b>Windows 10</b>

<h2>Program walk-through:</h2>

<p align="center">

#To work with data<br>
install.packages("tidyverse")<br>
library(tidyverse)<br>
library(conflicted)<br>

#Enable the read_csv function with this package<br>
install.packages("readr")<br>
library(readr)

#Set dplyr to allow dpylr and filter functions: lag as the default choices<br>
conflict_prefer("filter", "dplyr")<br>
conflict_prefer("lag", "dplyr")

#Enable the rename fuction in rstudio<br>
install.packages("dplyr")<br>
library(dplyr)

# STEP 1 - COLLECT DATA
# Data collection
#Upload Divvy_trips 2019 & 2020 data sets<br>
q1_2019 <- read_csv("Divvy_Trips_2019_Q1.csv")<br>
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")

# STEP 2 - MATCH COLUMNS AND COMBINE INTO SINGLE FILE
#Compare the column names each of the files
#Names don't need same order, but must match<br>
colnames(q1_2019)<br>
colnames(q1_2020)

#Rename columns to make cosistent with q1_2020<br>
(q1_2019 <-rename(q1_2019<br>
           ,ride_id = trip_id<br>
           ,rideable_type = bikeid<br>
           ,started_at = start_time<br>
           ,ended_at = end_time<br>
           ,start_station_name = from_station_name<br>
           ,start_station_id = from_station_id<br>
           ,end_station_name = to_station_name<br>
           ,end_station_id = to_station_id<br>
           ,member_casual = usertype<br>
            ))

#Inspect data frames for incongruencies<br>
str(q1_2019)<br>
str(q1_2020)

#Convert ride_id & rideable_type to character to stack correctly<br>
q1_2019<- mutate(q1_2019, ride_id=as.character(ride_id)<br>
          ,rideable_type=as.character(rideable_type))

#Stacke both data frames into single frame<br>
all_trips<-bind_rows(q1_2019, q1_2020)

#Remove lat, long, birthyear, and gender fields<br>
all_trips <-all_trips %>%<br> 
  select(-c(start_lat, start_lng, end_lat, end_lng, birthyear, gender, "tripduration"))

#Review new table<br>
colnames(all_trips)<br>
nrow(all_trips)<br>
dim(all_trips)<br>
head(all_trips)<br>
str(all_trips)<br>
summary(all_trips)

# Fixes for the data
# (1) two names for 'member_casual' column, ("member" and "Subscriber"0 and ("Customer" and "Casual")
# Consolidate from four to two names<br>
all_trips<- all_trips %>%<br> 
  mutate(member_casual = recode(member_casual<br>
                         ,"Subscriber"="member"<br>
                         ,"Customer" = "casual"))
#Review changes<br>
table(all_trips$member_casual)

# (2) Need to add columns for day, month, year
# Add columns that list date, month, day, and year of each ride<br>
all_trips$date <-as.Date(all_trips$started_at) #default format is yyyy-mm-dd<br>
all_trips$month <-format(as.Date(all_trips$date), "%m")<br>
all_trips$day <-format(as.Date(all_trips$date), "%d")<br>
all_trips$year <-format(as.Date(all_trips$date), "%Y")<br>
all_trips$day_of_week <-format(as.Date(all_trips$date), "%A")
    
# (3) Add calculated field for length of ride since 2020Q1 data did not have
# the trip duration column. 
# Add ride_length to the entire dataframe<br>
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)


# Inspect the structure of new columns<br>
str(all_trips)


# (4) Trip durations are showing as negative numbers due to quality control
# reasons, delete negative number rides
# Convert ride_length from Factor to numberic for calculations on data<br>
is.factor(all_trips$ride_length)<br>
all_trips$ride_length <-as.numeric(as.character(all_trips$ride_length))<br>
is.numeric(all_trips$ride_length)

#Remove bad data/remove negative trip_duration due to quality control check-out
#Create new version of data with removed bad data<br>
all_trips_v2 <-all_trips[!(all_trips$start_station_name == "HQ QR"|all_trips$ride_length<0),]

# STEP 4 CONDUCT DESCRIPTIVE ANALYSIS<br>
mean(all_trips_v2$ride_length)<br> 
median(all_trips_v2$ride_length)<br>
max(all_trips_v2$ride_length)<br>
min(all_trips_v2$ride_length)<br>
# Condensed version, one line using summary() on the specific attribute<br>
summary(all_trips_v2$ride_length)

# Compare members and casual users<br>
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)<br>
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)<br>
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)<br>
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# Average ride time by each day for members vs casual users<br>
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,
          FUN = mean)

# Reorder day of the week<br>
all_trips_v2$day_of_week <-ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday",<br>
"Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Analyze ridership data by type and weekday<br>
all_trips_v2 %>% 
  mutate(weekday=wday(started_at, label=TRUE) %>%<br>
           group_by(member_casual, weekday) %>%<br> 
           summarise(number_of_rides=n()<br>
           ,average_duration=mean(ride_length)) %>%<br>
           arrange(member_casual, weekday)
         
# tidyverse launch for ggplot<br>
library(tidyverse)    
# Visual for the number of rides per rider type<br>
library(scales)

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%<br> 
  group_by(member_casual, weekday) %>%<br> 
  summarise(number_of_rides = n(),<br> 
            average_duration = mean(ride_length)) %>%<br> 
  arrange(member_casual, weekday)  %>%<br> 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +<br>
  geom_col(position = "dodge") +<br>
  scale_y_continuous(labels = label_comma())  # Prevent scientific notation


# Visual for the average duration<br>
all_trips_v2 %>%<br>
  mutate(weekday = wday(started_at, label = TRUE)) %>%<br> 
  group_by(member_casual, weekday) %>%<br> 
  summarise(number_of_rides = n()<br>
            ,average_duration = mean(ride_length)) %>% <br>
  arrange(member_casual, weekday)  %>% <br>
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +<br>
  geom_col(position = "dodge")

# Export file for further analaysis & visualization<br>
counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)<br>
write.csv(counts, file = 'avg_ride_length.csv')

