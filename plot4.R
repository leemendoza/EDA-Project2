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

## Plot 4
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999-2008?

## find the coal combustion related sources
coal_scc = SCC[grep("Coal", SCC$EI.Sector) , ]
## subset the coal combustion sources found in coal_scc
coal = NEI[NEI$SCC %in% coal_scc$SCC, ]
## aggregate by year
coalEmissions = aggregate(Emissions ~ year, data = coal, sum)

## divert to bitmap device
png("plot4.png")
barplot(coalEmissions$Emissions, 
        names.arg = coalEmissions$year, 
        main = "US Coal Combustion-Related Emission Sources",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )

dev.off()
