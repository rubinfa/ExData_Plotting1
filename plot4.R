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
#Open device to store the plot as png
png(filename='./plot4.png', width = 480, height = 480)

#Generate plot
par(mfrow=c(2,2))

#Top left plot
plot(measurements$DateTime, measurements$Global_active_power, ylab='Global Active Power', xlab='', type='l')

#Top right plot
plot(measurements$DateTime, measurements$Voltage, xlab='datetime', ylab='Voltage', type='l')

#Bottom left plot
plot(measurements$DateTime, measurements$Sub_metering_1, ylab='Energy sub metering', xlab='', type='l')
#Add red line for sub metering 2
lines(measurements$DateTime, measurements$Sub_metering_2, col = "red")
#Add blue line for sub metering 3
lines(measurements$DateTime, measurements$Sub_metering_3, col = "blue")
#Add legend
legend(x="topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"),lty='solid',bty="n")

#Bottom right plot
plot(measurements$DateTime, measurements$Global_reactive_power, xlab='datetime', ylab='Global_reactive_power', type='l')

#Shut down device
dev.off()