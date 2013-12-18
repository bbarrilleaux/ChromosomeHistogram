args <- commandArgs(TRUE)
file <- toString(args[1])
start_column <- as.integer(args[2])
end_column <- as.integer(args[3])
score_column <- as.integer(args[4])
if(is.na(score_column)) {
  stop(paste("There are 4 mandatory arguments to use this script:",
    "filename, start column, end column, and score column. End column and/or score column can be 0 to ignore them.",
    " Try it like this: 'Rscript ChrHist.r mybedfile.bed 2 3 0'"))
}

library(ggplot2)
library(gtools) # for reordering chromosome names
source("./prepareData.r")    

pdata <- parsePeakFile(file, start_column, end_column, score_column)
species <- checkSpecies(pdata)
pdata <- rbind(pdata, fetchChromosomeLengths(species))
centromeres <- fetchCentromeres(species)
pdata$Chromosome <- factor(pdata$Chromosome, mixedsort(levels(pdata$Chromosome)))
theme_set(theme_gray(base_size = 18)) # make fonts bigger
png(paste(file, "-graph.png", sep = ""), type="cairo-png", width = 1800, height=1200)
  hist_results <- ggplot(pdata, aes(x = loc/1000000, weight = size)) +
    geom_freqpoly(size = 2) + xlab("Position along chromosome (Mbp)") + ylab("Intensity") 
  if (species == "human") { hist_results <- hist_results + geom_vline(aes(xintercept = start/1000000), data = centromeres) }
  hist_results <- hist_results + facet_wrap(~ Chromosome, drop = FALSE, scales = "free_x")
  suppressMessages(print(hist_results))
dev.off()