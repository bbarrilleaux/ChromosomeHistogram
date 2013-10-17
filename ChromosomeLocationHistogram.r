#Calculate distance from centromeres and telomeres as a fraction of the way across the chromosome and graph the results.

library("ggplot2")

#Load the data and keep only the chromosome, peak start location, and fold change columns.
Data = read.table("H3K4me3-downinKOpeaks.txt", header=TRUE, stringsAsFactors = FALSE)
Data <- data.frame(Data[,1], Data[,2], Data[,9])
names(Data) <- c("chr", "loc", "fold")

#Load chromosome lengths for the mm9 mouse genome.
Chromosomes = read.table("mm9ChromosomeLengths.txt", sep="\t", stringsAsFactors = FALSE)

#Append chromosome lengths to the data frame in a new column called ChromLength
Results <- cbind(Data, ChromLength=vector(mode="integer",length= nrow(Data)))
for (i in 1:nrow(Results))
{
  n = Chromosomes[which(Chromosomes$V1 == Data[i,1]),2]
  Results[i,"ChromLength"] = n[1]
}

#Append fractional distance along the centromere to the data frame in a new column called Dist
Results <- cbind(Results, Dist=vector(mode="integer",length= nrow(Data)))
Results[,"Dist"] <- (Results[,"loc"])/(Results[,"ChromLength"])

#Graph it using ggplot2:
theme_set(theme_gray(base_size = 18)) #make fonts bigger
hist_results <- ggplot(Results, aes(x=Dist, colour=chr, weight=fold))
hist_results + geom_freqpoly(binwidth=0.033) + xlab("Relative distance from centromere") + 
       facet_wrap("chr") + labs(title="H3K4me3 peaks significantly decreased in KO") + ylab("Fold change")

