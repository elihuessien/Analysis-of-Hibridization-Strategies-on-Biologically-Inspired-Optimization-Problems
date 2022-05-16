library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(0% - 50%, 50%).txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(0% - 100%, 50%).txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(0% - 100%, 100%).txt"
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(20% - 80%, 50%).txt"
path5 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(20% - 80%, 100%).txt"
path6 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(30% - 70%, 50%).txt"
path7 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/B/(30% - 70%, 100%).txt"

# test data
t1.data <- read.table(path1, header=FALSE, sep=",", dec=".")
t2.data <- read.table(path2, header=FALSE, sep=",", dec=".")
t3.data <- read.table(path3, header=FALSE, sep=",", dec=".")
t4.data <- read.table(path4, header=FALSE, sep=",", dec=".")
t5.data <- read.table(path5, header=FALSE, sep=",", dec=".")
t6.data <- read.table(path6, header=FALSE, sep=",", dec=".")
t7.data <- read.table(path7, header=FALSE, sep=",", dec=".")





# Analysing Averages
t1.avg <- colMeans(t1.data)
t2.avg <- colMeans(t2.data)
t3.avg <- colMeans(t3.data)
t4.avg <- colMeans(t4.data)
t5.avg <- colMeans(t5.data)
t6.avg <- colMeans(t6.data)
t7.avg <- colMeans(t7.data)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(t1.data)){
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  
  Value <- c(Value, t1.avg[i])
  Value <- c(Value, t2.avg[i])
  Value <- c(Value, t3.avg[i])
  Value <- c(Value, t4.avg[i])
  Value <- c(Value, t5.avg[i])
  Value <- c(Value, t6.avg[i])
  Value <- c(Value, t7.avg[i])
  
  Class <- c(Class, "(0% - 50%, 50%)")
  Class <- c(Class, "(0% - 100%, 50%)")
  Class <- c(Class, "(0% - 100%, 100%)")
  Class <- c(Class, "(20% - 80%, 50%)")
  Class <- c(Class, "(20% - 80%, 100%)")
  Class <- c(Class, "(30% - 70%, 50%)")
  Class <- c(Class, "(30% - 70%, 100%)")
}

AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "(Alpha - Beta, IterationPercentage)")




# Analysing AUC
t1.auc <- trapezoidal(t1.data)
t2.auc <- trapezoidal(t2.data)
t3.auc <- trapezoidal(t3.data)
t4.auc <- trapezoidal(t4.data)
t5.auc <- trapezoidal(t5.data)
t6.auc <- trapezoidal(t6.data)
t7.auc <- trapezoidal(t7.data)

mean(t7.auc)
sd(t7.auc)

ID <- c()
Value <- c()
Class <- c()
for(i in 1:nrow(t1.data)){
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  ID <- c(ID, i)
  
  Value <- c(Value, t1.auc[i])
  Value <- c(Value, t2.auc[i])
  Value <- c(Value, t3.auc[i])
  Value <- c(Value, t4.auc[i])
  Value <- c(Value, t5.auc[i])
  Value <- c(Value, t6.auc[i])
  Value <- c(Value, t7.auc[i])
  
  Class <- c(Class, "(0-5,5)")
  Class <- c(Class, "(0-10,5)")
  Class <- c(Class, "(0-10,10)")
  Class <- c(Class, "(2-8,5)")
  Class <- c(Class, "(2-8,10)")
  Class <- c(Class, "(3-7,5)")
  Class <- c(Class, "(3-7,10)")
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "(Alpha - Beta, IterationPercentage)")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="(Alpha - Beta, IterationPercentage)")

AUC.df %>%
  filter(Class == "(30% - 70%, 100%)" | Class == "(30% - 70%, 50%)") %>%
  ggplot(aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "(Alpha - Beta, IterationPercentage)")


wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "(2-8,5)" | Class == "(0-10,10)"))




  # Clean up
x <- c()
y <- c()
z <- c()
p <- c()
for(i in seq(1,7)){
  x <- c(x, paste("t", i, ".data", sep = ""))
  y <- c(y, paste("t", i, ".avg", sep = ""))
  z <- c(z, paste("t", i, ".auc", sep = ""))
  p <- c(p, paste("path", i, sep = ""))
}
rm(list = x, x)
rm(list = y, y)
rm(list = z, z)
rm(list = p, p, i, j)
rm(ID, Value, Class, AVG.df, AUC.df)
