library(lattice)
library(ggplot2)

## set working directory
setwd(".\\Github\\EDA-Project2")

## assumes that the data files are in a subfolder named 'data'
NEI <- readRDS("data\\summarySCC_PM25.rds")
SCC <- readRDS("data\\Source_Classification_Code.rds")
boxplot(Emissions~year, data=NEI, ylab="Total Emmissions", xlab = "Year", ylim = c(0.0, 25000))
