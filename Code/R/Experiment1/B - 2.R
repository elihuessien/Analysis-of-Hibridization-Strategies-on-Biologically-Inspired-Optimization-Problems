library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/B - 2/SS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/B - 2/LSS.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/B - 2/ELT.txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Benchmark/Size - 10/GreedyOptimizer.txt"

ss.data <- read.table(path1, header=FALSE, sep=",", dec=".")
lss.data <- read.table(path2, header=FALSE, sep=",", dec=".")
elt.data <- read.table(path3, header=FALSE, sep=",", dec=".")
benchmark <- read.table(path4, header=FALSE, sep=",", dec=".")




# Analyze averages
ss.avg <- colMeans(ss.data)
lss.avg <- colMeans(lss.data)
elt.avg <- colMeans(elt.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(sus.data)){
  ID <- c(ID, i)
  Value <- c(Value, elt.avg[i])
  Class <- c(Class, "GA-ELT(SUS)")
  
  ID <- c(ID, i)
  Value <- c(Value, ss.avg[i])
  Class <- c(Class, "GA-SS(SUS)")
  
  ID <- c(ID, i)
  Value <- c(Value, lss.avg[i])
  Class <- c(Class, "GA-LSS(SUS)")
  
  ID <- c(ID, i)
  Value <- c(Value, rowMeans(benchmark))
  Class <- c(Class, "Greedy Optimizer")
}

AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "Algorithm Enhancer")





# Analyzing AUC
ss.auc <- trapezoidal(ss.data)
elt.auc <- trapezoidal(elt.data)
lss.auc <- trapezoidal(lss.data)
ID <- c()
Value <- c()
Class <- c()
for(i in 1:length(ss.auc)){
  ID <- c(ID, i)
  Value <- c(Value, ss.auc[i])
  Class <- c(Class, "SS")
  
  ID <- c(ID, i)
  Value <- c(Value, lss.auc[i])
  Class <- c(Class, "LSS")
  
  ID <- c(ID, i)
  Value <- c(Value, elt.auc[i])
  Class <- c(Class, "ELT-10%")
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Algorithm Enhanser")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Algorithm Enhanser")

ggplot(AUC.df, aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Algorithm Enhanser")

wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "ELT-10%" | Class == "SS"))



# Clean Up
rm(path1, path2, path3, path4, path5)
rm(SUS.data, RBS.data, TS.data, Benchmark)
rm(SUS.avg, RBS.avg, TS.avg, AVG.df)
rm(SUS.auc, RBS.auc, AUC.df)
rm(ID, Value, Class, i)