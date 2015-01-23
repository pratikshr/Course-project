#Reading the dataset
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subsetting the relevant bits and cleaning the dataset 
dat <- NEI[NEI$fips == "24510", c("year", "Emissions")]
dat <- aggregate(dat$Emissions, by = list(Year = dat$year), sum)
colnames(dat)[2] <- "Emissions"

#Drawing the plot
png("plot2.png")
plot(dat$Year, log(dat$Emissions), type="o", xlab="Year", ylab="Log of Total Amount of PM 2.5 emitted (tons)", main = "PM 2.5 Emissions in Baltimore, 24510")
dev.off()