library(ggplot2)
#Reading the datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subsetting the relevant fips code
NEIsub <- NEI[NEI$fips == "24510",]

#Making calculations necessary and cleaning up the data
NEIsub <- aggregate(NEIsub$Emissions, by = list(Year = NEIsub$year, type = NEIsub$type), sum)
NEIsub <- NEIsub[order(NEIsub$type), ]
NEIsub <- transform(NEIsub, type = factor(type))
colnames(NEIsub)[3] <- "Emissions"

#Drawing the plot using ggplot
png('plot3.png', width = 700)
g <- ggplot(NEIsub, aes(Year, Emissions)) 
g <- g + geom_line() + geom_point() +facet_grid(. ~ type ) + ggtitle("Total Emissions by Type in Baltimore City")
print(g)
dev.off()