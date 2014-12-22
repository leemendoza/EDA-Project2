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


## Plot 1
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.
## Get aggregate totals for each year
totalEmissions = aggregate(Emissions ~ year, data = NEI, sum)
## Show 'em
## divert to bitmap device
png("plot1.png")
barplot(totalEmissions$Emissions, 
        names.arg = totalEmissions$year, 
        main = "US Total Emissions",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )

dev.off()
