## Exploratory Data Analysis Project 2
## LMENDOZA

library(lattice)
library(ggplot2)
library(plyr)

## assumes that the source data files are in a subfolder named 'data'

## NEI will contain all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. 
## For each year, the table contains number of tons of PM2.5 emitted from a specific 
## type of source for the entire year. 
NEI <- readRDS("data\\summarySCC_PM25.rds")
SCC <- readRDS("data\\Source_Classification_Code.rds")

## Plot 5
## How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
vehicle_scc = SCC[grep("Vehicle", SCC$EI.Sector) , ]
## get just vehicle data 
vehicle = NEI[NEI$SCC %in% vehicle_scc$SCC, ]
## now just baltimore data
vehicle = vehicle[which(vehicle$fips == "24510"), ]
## aggregate by year
vehicleEmissions = aggregate(Emissions ~ year, data = vehicle, sum)
## plot 'em
## divert to bitmap device
png("plot5.png")

barplot(vehicleEmissions$Emissions, 
        names.arg = vehicleEmissions$year, 
        main = "Baltimore Vehicle Emission Sources",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )


dev.off()
