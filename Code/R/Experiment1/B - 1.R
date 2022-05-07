library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/B - 1/",x,"%.txt", sep = ""))
}


# Dynamic global variable creation
for (i in seq(0,50,10)){
  assign(paste("elt",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}




# Analysing Averages
for (i in seq(0,50,10)){
  assign(paste("elt", i, ".avg", sep = ""), colMeans(get(paste("elt",i, sep = ""))))
}

ID <- c()
Value <- c()
Class <- c()
for(i in 1:length(elt0.avg)){
  for(j in seq(0,50,10)){
    ID <- c(ID, i)
    Value <- c(Value, get(paste("elt", j, ".avg", sep = ""))[i])
    Class <- c(Class, paste("ELT - ", j, "%", sep = ""))
  }
}

AVG.df <- data.frame(ID, Value, Class)

ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration", x="Iteration", colour = "Elite Percentage")






# Analysing AUC
for (i in seq(0,50,10)){
  assign(paste("elt", i, ".auc", sep = ""), trapezoidal(get(paste("elt",i, sep = ""))))
}


ID <- c()
Value <- c()
Class <- c()

for(i in 1:length(elt0.auc)){
  for(j in seq(0,50,10)){
    ID <- c(ID, i)
    Value <- c(Value, get(paste("elt", j, ".auc", sep = ""))[i])
    Class <- c(Class, paste("ELT - ", j, "%", sep = ""))
  }
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "Elite Percentage")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Elite Percentage")

AUC.df %>%
  filter(Class == "ELT - 0%" | Class == "ELT - 10%") %>%
  ggplot(aes(x = Value, fill = Class, alpha = 1)) +
  geom_histogram(position = "identity") +
  guides(alpha ="none") +
  labs(title = "Learning Rate (AUC)", x="Value", fill = "Elite Percentage")


wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "ELT - 10%" | Class == "ELT - 0%"))





# clean Up
x <- c()
y <- c()
z <- c()
for(i in seq(0,50,10)){
  x <- c(x, paste("elt", i, sep = ""))
  y <- c(y, paste("elt", i, ".avg", sep = ""))
  z <- c(z, paste("elt", i, ".auc", sep = ""))
}
rm(list = x, x, i, j, path)
rm(list = y, y)
rm(list = z, z)
rm(ID, Value, Class, AVG.df, AUC.df)
