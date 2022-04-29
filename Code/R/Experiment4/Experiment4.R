library(pracma)
library(dplyr)
library(datasets)
library(ggplot2)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment4/Size - 50/ACO.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment4/Size - 50/PSO.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment4/Size - 50/GA.txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment4/Size - 50/ACO_GA_Hybrid.txt"
path5 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment4/Size - 50/PSO_GA_Hybrid.txt"
path6 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment4/Size - 50/PSO_ACO_Hybrid.txt"


aco.data <- read.table(path1, header=FALSE, sep=",", dec=".")
pso.data <- read.table(path2, header=FALSE, sep=",", dec=".")
ga.data <- read.table(path3, header=FALSE, sep=",", dec=".")
aco.ga.data <- read.table(path4, header=FALSE, sep=",", dec=".")
pso.ga.data <- read.table(path5, header=FALSE, sep=",", dec=".")
pso.aco.data <- read.table(path6, header=FALSE, sep=",", dec=".")

AVG.df <- data.frame(ID <- 1:ncol(aco.data),
                     aco.avg  <- colMeans(aco.data),
                     pso.avg <- colMeans(pso.data),
                     ga.avg <- colMeans(ga.data),
                     aco.ga.avg  <- colMeans(aco.ga.data),
                     pso.ga.avg  <- colMeans(pso.ga.data),
                     pso.aco.avg  <- colMeans(pso.aco.data))


ggplot(AVG.df, aes(x=ID)) +
  geom_line(aes(y = aco.avg), color="red", size = 1.2) +
  geom_line(aes(y = pso.avg), color="blue", size = 1.2) +
  geom_line(aes(y = ga.avg), color="yellow", size = 1.2) +
  geom_line(aes(y = aco.ga.avg), color="orange", size = 1.2) +
  geom_line(aes(y = pso.ga.avg), color="green", size = 1.2) +
  geom_line(aes(y = pso.aco.avg), color="violet", size = 1.2) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "MapSize:10, MapCount:100")





#---------AUC Statistical Tests------------#
AUC.df <- data.frame(ID <- 1:ncol(aco.data),
                     aco.auc  <- trapezoidal(aco.data),
                     pso.auc <- trapezoidal(pso.data),
                     ga.auc <- trapezoidal(ga.data),
                     aco.ga.auc  <- trapezoidal(aco.ga.data),
                     pso.ga.auc  <- trapezoidal(pso.ga.data),
                     pso.aco.auc  <- trapezoidal(pso.aco.data))



# Making composit dataframe for Statistics
value <- c()
class <- c()
for (row in 1:nrow(AUC.df)){
  value <- c(value, AUC.df$pso.auc[row])  # Add SUS column
  class <- c(class, "PSO")
  
  value <- c(value, AUC.df$pso.ga.auc[row])  # Add RBS column
  class <- c(class, "PSO-GA")
}
Stat.df <- data.frame(value, class)
wilcox.test(value ~ class, data = Stat.df)


# Clean Up
rm(path1, path2, path3, path4, path5, path6)
rm(aco.data, pso.data, ga.data, aco.ga.data, pso.ga.data, pso.aco.data)
rm(AVG.df, ID, aco.avg, pso.avg, ga.avg, aco.ga.avg, pso.ga.avg, pso.aco.avg)
rm(AUC.df, ID, aco.auc, pso.auc, ga.auc, aco.ga.auc, pso.ga.auc, pso.aco.auc)
rm(value, class, row, Stat.df)
