library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

map_size = 50


path1 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - ", map_size,"/GA.txt", sep = "")
path2 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - ", map_size,"/ACO.txt", sep = "")
path3 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - ", map_size,"/PSO.txt", sep = "")
path4 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - ", map_size,"/ACO_GA_Hybrid.txt", sep = "")
path5 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - ", map_size,"/PSO_ACO_Hybrid.txt", sep = "")
path6 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - ", map_size,"/PSO_GA_Hybrid.txt", sep = "")
path7 <- paste("C:/Users/C14460702/Dissertation/Data/Results/Benchmark/Size - ", map_size,"/GreedyOptimizer.txt", sep = "")


ga.data <- read.table(path1, header=FALSE, sep=",", dec=".")
aco.data <- read.table(path2, header=FALSE, sep=",", dec=".")
pso.data <- read.table(path3, header=FALSE, sep=",", dec=".")
aco.ga.data <- read.table(path4, header=FALSE, sep=",", dec=".")
aco.pso.data <- read.table(path5, header=FALSE, sep=",", dec=".")
pso.ga.data <- read.table(path6, header=FALSE, sep=",", dec=".")
Benchmark <- read.table(path7, header=FALSE, sep=",", dec=".")


# Analyzing Averages
ga.avg <- colMeans(ga.data)
aco.avg <- colMeans(aco.data)
pso.avg <- colMeans(pso.data)
aco.ga.avg <- colMeans(aco_ga.data)
aco.pso.avg <- colMeans(aco_pso.data)
pso.ga.avg <- colMeans(pso_ga.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(ga.data)){
  ID <- c(ID, i)
  Value <- c(Value, ga.avg[i])
  Class <- c(Class, "GA")
  
  ID <- c(ID, i)
  Value <- c(Value, aco.avg[i])
  Class <- c(Class, "ACO")
  
  ID <- c(ID, i)
  Value <- c(Value, pso.avg[i])
  Class <- c(Class, "PSO")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_ga.avg[i])
  Class <- c(Class, "ACO/GA Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_pso.avg[i])
  Class <- c(Class, "PSO/ACO Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, pso_ga.avg[i])
  Class <- c(Class, "PSO/GA Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, rowMeans(Benchmark))
  Class <- c(Class, "Greedy Optimizer")
}


AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = paste("Average GBest per Iteration (Maps with city count ", map_size, ")", sep = ""),
       x="Iteration", y = "Score", colour = "Algorithm")




# Analyzing AUC
ga.auc <- trapezoidal(ga.data)
aco.auc <- trapezoidal(aco.data)
pso.auc <- trapezoidal(pso.data)
aco_ga.auc <- trapezoidal(aco_ga.data)
aco_pso.auc <- trapezoidal(aco_pso.data)
pso_ga.auc <- trapezoidal(pso_ga.data)

mean(aco_pso.auc)
sd(aco_pso.auc)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(ga.data)){
  ID <- c(ID, i)
  Value <- c(Value, ga.auc[i])
  Class <- c(Class, "GA")
  
  ID <- c(ID, i)
  Value <- c(Value, aco.auc[i])
  Class <- c(Class, "ACO")
  
  ID <- c(ID, i)
  Value <- c(Value, pso.auc[i])
  Class <- c(Class, "PSO")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_ga.auc[i])
  Class <- c(Class, "ACO/GA Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_pso.auc[i])
  Class <- c(Class, "PSO/ACO Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, pso_ga.auc[i])
  Class <- c(Class, "PSO/GA Hybrid")
}


AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Algorithm")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Algorithm")


ggplot(filter(AUC.df, Class == "ACO/PSO Hybrid" | Class == "ACO - AS"), aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Algorithm")

wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "ACO/PSO Hybrid" | Class == "ACO - AS"))


# Clean Up
rm(path1, path2, path3, path4, path5, path6, path7)
rm(aco.data, pso.data, ga.data, aco.ga.data, pso.ga.data, pso.aco.data)
rm(aco.avg, pso.avg, ga.avg, aco.ga.avg, pso.ga.avg, pso.aco.avg, AVG.df)
rm(aco.auc, pso.auc, ga.auc, aco.ga.auc, pso.ga.auc, pso.aco.auc, AUC.df)
rm(size, ID, Value, Class, i, Benchmark, map_size)
