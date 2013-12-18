parsePeakFile <- function(file, start_column = 2, end_column = 0, score_column = 0) {
  peaks <- read.table(file, sep = "\t", header = FALSE)
  # detect header line if it exists
  if (is.factor(peaks[, start_column])) { 
    peaks <- read.table(file, sep = "\t", header = TRUE)
  }

  pdata <- data.frame(as.factor(peaks[, 1]), peaks[, start_column])

  if (end_column && !score_column) { 
    pdata <- cbind(pdata, peaks[, end_column] - peaks[, start_column]) 
  } else if (!end_column && score_column) {
    pdata <- cbind(pdata, peaks[, score_column])
  } else if (end_column && score_column) {
    pdata <- cbind(pdata, 
                  (peaks[, end_column] - peaks[, start_column]) * peaks[, score_column])
  } else {
    pdata <- cbind(pdata, rep(1, nrow(pdata)))
  }

  names(pdata) <- c("Chromosome", "loc", "size")
  return(pdata)
}

checkSpecies <- function(pdata) {
  if ("chr20" %in% pdata$Chromosome | 
      "chr21" %in% pdata$Chromosome | 
      "chr22" %in% pdata$Chromosome) {
    return("human")
  } else if ("chr19" %in% pdata$Chromosome | 
             "chr18" %in% pdata$Chromosome | 
             "chr17" %in% pdata$Chromosome) {
    return("mouse")
  } else {
    return("unknown")
  }
}

fetchChromosomeLengths <- function(species) {
  if (species == "human") {
    return(read.table("./Data/HumanChromosomeLengths.txt", sep = "\t", header = TRUE))
  } else if (species == "mouse") {
    return(read.table("./Data/MouseChromosomeLengths.txt", sep = "\t", header = TRUE))
  } else {
    return()
  }
}

fetchCentromeres <- function(species) {
  if (species == "human") {
    centromeres <- read.table("./Data/HumanCentromerePositions.txt", sep = "\t")
  } else {
    #all mouse chromosomes are telocentric, so it's pointless to plot the centromeres.
    centromeres <- data.frame("chr1", 0, 0) 
  }
  names(centromeres) <- c("Chromosome", "start", "end")
  return(centromeres)
}