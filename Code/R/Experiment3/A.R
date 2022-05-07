library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)


path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 3/A/w(0.",x,").txt", sep = ""))
}

# Dynamic global variable creation
for (i in seq(1,10,1)){
  assign(paste("w",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}





# Analysing Averages
for (i in seq(1,10,1)){
  assign(paste("w", i, ".avg", sep = ""), colMeans(get(paste("w",i, sep = ""))))
}


ID <- c()
Value <- c()
Class <- c()
for(i in 1:length(w1.avg)){
  for(j in seq(1,9,1)){
    ID <- c(ID, i)
    Value <- c(Value, get(paste("w", j, ".avg", sep = ""))[i])
    Class <- c(Class, paste("w - ", j, "0%", sep = ""))
  }
}

AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "Inertia Weight")





# Analysing AUC
for (i in seq(1,10,1)){
  assign(paste("w", i, ".auc", sep = ""), trapezoidal(get(paste("w",i, sep = ""))))
}


ID <- c()
Value <- c()
Class <- c()
for(i in 1:length(w1.auc)){
  for(j in seq(1,9,1)){
    ID <- c(ID, i)
    Value <- c(Value, get(paste("w", j, ".auc", sep = ""))[i])
    Class <- c(Class, paste("w - ", j, "0%", sep = ""))
  }
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Inertia Weight")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Inertia Weight")

AUC.df %>%
  filter(Class == "w - 80%" | Class == "w - 40%") %>%
  ggplot(aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Inertia Weight")


wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "w - 80%" | Class == "w - 40%"))






# Clean Up
x <- c()
y <- c()
z <- c()
for(i in seq(1,10,1)){
  x <- c(x, paste("w", i, sep = ""))
  y <- c(y, paste("w", i, ".avg", sep = ""))
  z <- c(z, paste("w", i, ".auc", sep = ""))
}
rm(list = x, x)
rm(list = y, y)
rm(list = z, z, i, j, path)
rm(ID, Value, Class, AVG.df, AUC.df)
rm(trapezoidal)