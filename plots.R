library(lattice)
library(ggplot2)
library(plyr)

## set working directory
setwd(".\\Github\\EDA-Project2")

## assumes that the source data files are in a subfolder named 'data'

## NEI will contain all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. 
## For each year, the table contains number of tons of PM2.5 emitted from a specific 
## type of source for the entire year. 
NEI <- readRDS("data\\summarySCC_PM25.rds")
SCC <- readRDS("data\\Source_Classification_Code.rds")


## Plot 1
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.
## Get aggregate totals for each year
totalEmissions = aggregate(Emissions ~ year, data = NEI, sum)
## Show 'em
barplot(totalEmissions$Emissions, 
        names.arg = totalEmissions$year, 
        main = "US Total Emissions",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )

## Plot 2
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system 
## to make a plot answering this question.

## filter the dataframe for only the Baltimore data
balt = NEI[which(NEI$fips == "24510"), ]
## convert the 'year' variable to a factor
balt$year = as.factor(balt$year)
## aggregate the Baltimore results
baltEmissions = aggregate(Emissions ~ year, data = balt, sum)
## plot 'em
barplot(baltEmissions$Emissions, 
        names.arg = baltEmissions$year, 
        main = "Baltimore Total Emissions",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )


## Plot 3
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
## variable, which of these four sources have seen decreases in emissions from 
## 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? 
## Use the ggplot2 plotting system to make a plot answer this question.

## filter the dataframe for only the Baltimore data
balt = NEI[which(NEI$fips == "24510"), ]
## convert the 'year' variable to a factor
balt$year = as.factor(balt$year)
## get the summary data
baltEmissions = ddply(balt, c("year", "type"), summarize, sum = sum(Emissions))
qplot(data = baltEmissions, 
      x = year, 
      y = sum, 
      ylab = expression('PM'[25]*' Emissions (Tons)'), 
      xlab = "Year",
      main = "Baltimore Emission Sources",
      fill = type, 
      geom = "bar", 
      stat="identity", 
      position = "dodge")


## Plot 4
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999-2008?
## find the coal combustion related sources
coal_scc = SCC[grep("Coal", SCC$EI.Sector) , ]
## subset the coal combustion sources found in coal_scc
coal = NEI[NEI$SCC %in% coal_scc$SCC, ]
## aggregate by year
coalEmissions = aggregate(Emissions ~ year, data = coal, sum)

barplot(coalEmissions$Emissions, 
        names.arg = coalEmissions$year, 
        main = "US Coal Combustion-Related Emission Sources",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )

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
barplot(vehicleEmissions$Emissions, 
        names.arg = vehicleEmissions$year, 
        main = "Baltimore Vehicle Emission Sources",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )

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