library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Find indices that match motor vehicle sources in the SCC dataset

indices <- grep("Mobile - On-Road", SCC$EI.Sector , ignore.case = TRUE, value = FALSE, fixed = FALSE)

#Get the SCC Code for the respective indices
sccCodes <- SCC[indices, c(1)]

# Find indices for the respective SCC Code in NEI dataset
indicesNEI <- NEI$SCC %in% sccCodes

#Subset NEI Dataset based on the above indices, extracting only the required columns
NEIsub <- NEI[indicesNEI, c("fips", "Emissions", "year")]
NEIsub <- NEIsub[NEIsub$fips == "24510", c("year", "Emissions")]

dat <- aggregate(NEIsub$Emissions, by = list(year = NEIsub$year), sum)
png("plot5.png")
plot(dat$year, dat$x, type="o", xlab="Year", ylab="Total PM 2.5 emitted [tons]", main = "PM 2.5 Emissions from Motor Vehicles, Baltimore")
dev.off()