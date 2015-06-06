#####################################################################################################
## 0. Prerequisites
#####################################################################################################
library(dplyr)
library(lubridate)

#If the files are not in the current working folder, display a message
if (!file.exists("./household_power_consumption.txt")) {
      stop(paste("The file 'household_power_consumption.txt' does not exist in ", getwd()))
}

#####################################################################################################
## 1. Reading data
#####################################################################################################
measurements <- read.table('./household_power_consumption.txt', header=TRUE, sep=';', na.strings='?',
                           colClasses=c(rep('character', 2), 
                                        rep('numeric', 7)))

#Convert date and time to a Date object and store it into a new column named DateTime
measurements <- mutate(measurements, DateTime = as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")))

#Include only the measurements over the period 2007-02-01 and 2007-02-02
measurements <- subset(measurements, 
                       year(DateTime) == 2007 &  
                       month(DateTime) == 2 & 
                       (day(DateTime) == 1 | day(DateTime) == 2))

#####################################################################################################
## 2. Plotting
#####################################################################################################
# Generate histogram
png("./plot1.png", width = 480, height = 480)
title <- "Global Active Power"
xlab <- "Global Active Power (kilowatts)"
ylab <- "Frequency"
color <- "red"
hist(as.numeric(as.character(measurements$Global_active_power)), xlab = xlab, ylab = ylab, main=title, col = color)
dev.off()