library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/A - 2/SUS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/A - 2/RBS.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/A - 2/TS(60).txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Benchmark/Size - 10/GreedyOptimizer.txt"

SUS.data <- read.table(path1, header=FALSE, sep=",", dec=".")
RBS.data <- read.table(path2, header=FALSE, sep=",", dec=".")
TS.data  <- read.table(path3, header=FALSE, sep=",", dec=".")
Benchmark <- read.table(path4, header=FALSE, sep=",", dec=".")


# Analyzing averages
SUS.avg <- colMeans(SUS.data)
RBS.avg <- colMeans(RBS.data)
TS.avg <- colMeans(TS.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(SUS.data)){
  ID <- c(ID, i)
  Value <- c(Value, SUS.avg[i])
  Class <- c(Class, "GA-SUS")
  
  ID <- c(ID, i)
  Value <- c(Value, RBS.avg[i])
  Class <- c(Class, "GA-RBS")
  
  ID <- c(ID, i)
  Value <- c(Value, TS.avg[i])
  Class <- c(Class, "GA-TS")
  
  ID <- c(ID, i)
  Value <- c(Value, rowMeans(Benchmark))
  Class <- c(Class, "Greedy Optimizer")
}

AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "Algorithm")





# Analysing AUC
SUS.auc <- trapezoidal(SUS.data)
RBS.auc <- trapezoidal(RBS.data)
ID <- c()
Value <- c()
Class <- c()
for(i in 1:length(SUS.auc)){
  ID <- c(ID, i)
  Value <- c(Value, SUS.auc[i])
  Class <- c(Class, "SUS")
  
  ID <- c(ID, i)
  Value <- c(Value, RBS.auc[i])
  Class <- c(Class, "RBS")
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Fitness Function")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Fitness Function")

ggplot(AUC.df, aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Fitness Function")

wilcox.test(Value ~ Class, data = AUC.df)



# Clean Up
rm(path1, path2, path3, path4, path5)
rm(SUS.data, RBS.data, TS.data, Benchmark)
rm(SUS.avg, RBS.avg, TS.avg, AVG.df)
rm(SUS.auc, RBS.auc, AUC.df)
rm(ID, Value, Class, i)
