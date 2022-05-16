library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/A/MMAS(0).txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/A/MMAS(0.5).txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/A/MMAS(0.05).txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/A/MMAS(0.005).txt"
path5 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 2/A/MMAS(0.0005).txt"

m1.data <- read.table(path1, header=FALSE, sep=",", dec=".")
m2.data <- read.table(path2, header=FALSE, sep=",", dec=".")
m3.data <- read.table(path3, header=FALSE, sep=",", dec=".")
m4.data <- read.table(path4, header=FALSE, sep=",", dec=".")
m5.data <- read.table(path5, header=FALSE, sep=",", dec=".")



# Analyzing Averages
m1.avg <- colMeans(m1.data)
m2.avg <- colMeans(m2.data)
m3.avg <- colMeans(m3.data)
m4.avg <- colMeans(m4.data)
m5.avg <- colMeans(m5.data)


ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(m1.data)){
  ID <- c(ID, i)
  Value <- c(Value, m1.avg[i])
  Class <- c(Class, "Pbest - 0")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m2.avg[i])
  Class <- c(Class, "Pbest - 0.5")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m3.avg[i])
  Class <- c(Class, "Pbest - 0.05")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m4.avg[i])
  Class <- c(Class, "Pbest - 0.005")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m5.avg[i])
  Class <- c(Class, "Pbest - 0.0005")
}


AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "MMAS Tmin Settings")




# Analyzing AUC
m1.auc <- trapezoidal(m1.data)
m2.auc <- trapezoidal(m2.data)
m3.auc <- trapezoidal(m3.data)
m4.auc <- trapezoidal(m4.data)
m5.auc <- trapezoidal(m5.data)

mean(m5.auc)
sd(m5.auc)


ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(m1.data)){
  ID <- c(ID, i)
  Value <- c(Value, m1.auc[i])
  Class <- c(Class, "Pbest - 0")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m2.auc[i])
  Class <- c(Class, "Pbest - 0.5")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m3.auc[i])
  Class <- c(Class, "Pbest - 0.05")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m4.auc[i])
  Class <- c(Class, "Pbest - 0.005")
  
  
  ID <- c(ID, i)
  Value <- c(Value, m5.auc[i])
  Class <- c(Class, "Pbest - 0.0005")
}

AUC.df <- data.frame(ID, Value, Class)
ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "MMAS Tmin Settings")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="MMAS Tmin Settings")



ggplot(filter(AUC.df, Class == "Pbest - 0.0005" | Class == "Pbest - 0"), aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "MMAS Tmin Settings")

wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "Pbest - 0.0005" | Class == "Pbest - 0.5"))



# Clean Up
x <- c()
y <- c()
z <- c()
j <- c()
for(i in seq(1,5)){
  x <- c(x, paste("m", i, ".data", sep = ""))
  y <- c(y, paste("m", i, ".avg", sep = ""))
  z <- c(z, paste("m", i, ".auc", sep = ""))
  j <- c(j, paste("path", i, sep = ""))
}
rm(list = x, x)
rm(list = y, y)
rm(list = z, z)
rm(list = j, j, i)
rm(ID, Value, Class, AVG.df, AUC.df)
