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
## plot 'em
## divert to bitmap device
png("plot3.png")
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

dev.off()
