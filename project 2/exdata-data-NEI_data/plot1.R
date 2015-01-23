#Reading the data 
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#performing some caclculations prior to making the plot using aggregate()
dat <- aggregate(NEI$Emissions, by = list(Year = NEI$year), sum)

#Cleaing the data to make it presentable
colnames(dat)[2] <- "Emissions"

#Now plotting the cleaned dataset
png("plot1.png")
plot(dat$Year, log(dat$Emissions), type="o", xlab="Year", ylab="Log of Total PM 2.5 emitted (tons)", main = "PM 2.5 Emissions in USA")
dev.off()
