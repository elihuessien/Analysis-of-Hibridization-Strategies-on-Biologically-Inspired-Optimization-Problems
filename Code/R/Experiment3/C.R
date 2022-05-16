library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/C/PSO.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/C/MPSO.txt"

pso.data <- read.table(path1, header=FALSE, sep=",", dec=".")
mpso.data <- read.table(path2, header=FALSE, sep=",", dec=".")




# Analyzing Averages
pso.avg <- colMeans(pso.data)
mpso.avg <- colMeans(mpso.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(pso.data)){
  ID <- c(ID, i)
  Value <- c(Value, pso.avg[i])
  Class <- c(Class, "PSO")
  
  ID <- c(ID, i)
  Value <- c(Value, mpso.avg[i])
  Class <- c(Class, "MPSO")
}



AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "Algorithm")




# Analyze AUC
pso.auc <- trapezoidal(pso.data)
mpso.auc <- trapezoidal(mpso.data)
ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(pso.data)){
  ID <- c(ID, i)
  Value <- c(Value, pso.auc[i])
  Class <- c(Class, "PSO")
  
  ID <- c(ID, i)
  Value <- c(Value, mpso.auc[i])
  Class <- c(Class, "MPSO")
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Algorithm")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Algorithm")

ggplot(AUC.df, aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Algorithm")

wilcox.test(Value ~ Class, data = AUC.df)


mean(mpso.auc)
sd(mpso.auc)


# Clean Up
rm(path1, path2, path3)
rm(pso.data, mpso.data, benchmark)
rm(pso.avg, mpso.avg, AVG.df)
rm(pso.auc, mpso.auc, AUC.df)
rm(ID, i, Value, Class)

