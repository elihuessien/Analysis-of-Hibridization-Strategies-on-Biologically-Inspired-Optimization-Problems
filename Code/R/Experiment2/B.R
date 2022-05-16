library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/B/AS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/B/MMAS.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/B/ACS.txt"

as.data <- read.table(path1, header=FALSE, sep=",", dec=".")
mmas.data <- read.table(path2, header=FALSE, sep=",", dec=".")
acs.data <- read.table(path3, header=FALSE, sep=",", dec=".")


# Analyzing Averages
as.avg <- colMeans(as.data)
mmas.avg <- colMeans(mmas.data)
acs.avg <- colMeans(acs.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(as.data)){
  ID <- c(ID, i)
  Value <- c(Value, as.avg[i])
  Class <- c(Class, "Ant System")
  
  ID <- c(ID, i)
  Value <- c(Value, mmas.avg[i])
  Class <- c(Class, "Max-Min Ant System")
  
  ID <- c(ID, i)
  Value <- c(Value, acs.avg[i])
  Class <- c(Class, "Ant Colony System")
}

AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "Algorithm")




# Analyzing AUC
as.auc <- trapezoidal(as.data)
mmas.auc <- trapezoidal(mmas.data)
acs.auc <- trapezoidal(acs.data)

mean(acs.auc)
sd(acs.auc)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(as.data)){
  ID <- c(ID, i)
  Value <- c(Value, as.auc[i])
  Class <- c(Class, "Ant System")
  
  ID <- c(ID, i)
  Value <- c(Value, mmas.auc[i])
  Class <- c(Class, "Max-Min Ant System")
  
  ID <- c(ID, i)
  Value <- c(Value, acs.auc[i])
  Class <- c(Class, "Ant Colony System")
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Algorithm")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Algorithm")



ggplot(filter(AUC.df, Class == "Ant System" | Class == "Ant Colony System"), aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Algorithm")

wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "Ant System" | Class == "Ant Colony System"))



# Clean Up
rm(path1, path2, path3, path4)
rm(as.data, mmas.data, acs.data, Benchmark)
rm(as.avg, mmas.avg, acs.avg, AVG.df)
rm(as.auc, mmas.auc, acs.auc, AUC.df)
rm(i, ID, Value, Class)
