library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Find indices that match coal combustion in the SCC dataset

indices <- grep("comb.*coal", SCC$EI.Sector , ignore.case = TRUE, value = FALSE, fixed = FALSE)

#Get the SCC Code for the respective indices
sccCodes <- SCC[indices, c(1)]

# Find indices for the respective SCC Code in NEI dataset
indicesNEI <- NEI$SCC %in% sccCodes

#Subset NEI Dataset based on the above indices, extracting only the required columns
NEIsub <- NEI[indicesNEI, c("Emissions", "year")]

dat <- aggregate(NEIsub$Emissions, by = list(year = NEIsub$year), sum)

#drawing the plot
png("plot4.png")
plot(dat$year, dat$x, type="o", xlab="Year", ylab="Total PM 2.5 emitted [tons]", main = "PM 2.5 Emissions (ALL Coal Combustion Sources)")
dev.off()