library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - 10/GA-SS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - 10/AS.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - 10/MPSO.txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - 10/ACO_GA_Hybrid.txt"
path5 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - 10/PSO_ACO_Hybrid.txt"
path6 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 4/Size - 10/PSO_GA_Hybrid.txt"
path7 <- "C:/Users/C14460702/Dissertation/Data/Results/Benchmark/Size - 10/GreedyOptimizer.txt"

ga.data <- read.table(path1, header=FALSE, sep=",", dec=".")
aco.data <- read.table(path2, header=FALSE, sep=",", dec=".")
pso.data <- read.table(path3, header=FALSE, sep=",", dec=".")
aco_ga.data <- read.table(path4, header=FALSE, sep=",", dec=".")
aco_pso.data <- read.table(path5, header=FALSE, sep=",", dec=".")
pso_ga.data <- read.table(path6, header=FALSE, sep=",", dec=".")
Benchmark <- read.table(path7, header=FALSE, sep=",", dec=".")



# Analyzing Averages
ga.avg <- colMeans(ga.data)
aco.avg <- colMeans(aco.data)
pso.avg <- colMeans(pso.data)
aco_ga.avg <- colMeans(aco_ga.data)
aco_pso.avg <- colMeans(aco_pso.data)
pso_ga.avg <- colMeans(pso_ga.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(ga.data)){
  ID <- c(ID, i)
  Value <- c(Value, ga.avg[i])
  Class <- c(Class, "GA - SUS")
  
  ID <- c(ID, i)
  Value <- c(Value, aco.avg[i])
  Class <- c(Class, "ACO - AS")
  
  ID <- c(ID, i)
  Value <- c(Value, pso.avg[i])
  Class <- c(Class, "PSO - MPSO")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_ga.avg[i])
  Class <- c(Class, "ACO/GA Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_pso.avg[i])
  Class <- c(Class, "ACO/PSO Hybrid")
  
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
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "Algorithm")




# Analyzing AUC
ga.auc <- trapezoidal(ga.data)
aco.auc <- trapezoidal(aco.data)
pso.auc <- trapezoidal(pso.data)
aco_ga.auc <- trapezoidal(aco_ga.data)
aco_pso.auc <- trapezoidal(aco_pso.data)
pso_ga.auc <- trapezoidal(pso_ga.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(ga.data)){
  ID <- c(ID, i)
  Value <- c(Value, ga.auc[i])
  Class <- c(Class, "GA - SUS")
  
  ID <- c(ID, i)
  Value <- c(Value, aco.auc[i])
  Class <- c(Class, "ACO - AS")
  
  ID <- c(ID, i)
  Value <- c(Value, pso.auc[i])
  Class <- c(Class, "PSO - MPSO")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_ga.auc[i])
  Class <- c(Class, "ACO/GA Hybrid")
  
  ID <- c(ID, i)
  Value <- c(Value, aco_pso.auc[i])
  Class <- c(Class, "ACO/PSO Hybrid")
  
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
