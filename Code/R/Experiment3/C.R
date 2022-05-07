library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/PSO.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/MPSO.txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Benchmark/Size - 10/GreedyOptimizer.txt"

pso.data <- read.table(path1, header=FALSE, sep=",", dec=".")
mpso.data <- read.table(path2, header=FALSE, sep=",", dec=".")
benchmark <- read.table(path3, header=FALSE, sep=",", dec=".")




# Analyzing Averages
