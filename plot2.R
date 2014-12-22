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
## divert to bitmap device
png("plot2.png")
barplot(baltEmissions$Emissions, 
        names.arg = baltEmissions$year, 
        main = "Baltimore Total Emissions",
        xlab = "Year", 
        ylab = expression('PM'[25]*' Emissions (Tons)') )
dev.off()
