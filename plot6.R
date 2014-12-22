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

## Plot 6
## Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources in Los Angeles County, 
## California (fips == "06037"). Which city has seen greater changes 
## over time in motor vehicle emissions?
## get just vehicle sources
vehicle_scc = SCC[grep("Vehicle", SCC$EI.Sector) , ]
vehicle = NEI[NEI$SCC %in% vehicle_scc$SCC, ]

## get the data for the target cities
cities = vehicle[vehicle$fips %in% c("24510", "06037"), ]
cities$fips[which(cities$fips == "06037")] = "Los Angeles"
cities$fips[which(cities$fips == "24510")] = "Baltimore"
names(cities)[1] = "Cities"
cityEmissions = ddply(cities, c("year", "Cities"), summarize, sum = sum(Emissions))
cityEmissions$year = as.factor(cityEmissions$year)

## divert to bitmap device
png("plot6.png")
qplot(data = cityEmissions, 
      x = year, 
      y = sum, 
      ylab = expression('PM'[25]*' Emissions (Tons)'), 
      xlab = "Year",
      main = "Vehicle Emission Sources",
      fill = Cities, 
      geom = "bar", 
      stat="identity", 
      position = "dodge")


dev.off()
