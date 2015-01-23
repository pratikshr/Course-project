library(ggplot2)
# Read the dataset
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
NEIsub <- NEIsub[NEIsub$fips == "24510" | NEIsub$fips == "06037", c("fips", "year", "Emissions")]

#Cleaning up the dataset for plotting
dat <- aggregate(NEIsub$Emissions, by = list(fips = NEIsub$fips, year = NEIsub$year), sum)
dat <- dat[order(dat$fips), ]
colnames(dat)[3] <- "Emissions"
dat$fips[which(dat$fips == "24510")] <- 'Baltimore'
dat$fips[which(dat$fips == "06037")] <- 'Los Angeles County'

#Drawing and storing the plot using ggplot package
png('plot6.png', width = 700)
g <- ggplot(dat, aes(year, Emissions)) 
g <- g + geom_line() + geom_point() +facet_grid(. ~ fips ) + ggtitle("Emissions Baltimore City and Los Angeles County")
print(g)
dev.off()