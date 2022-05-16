install.packages("ggplot2")
install.packages("pracma")
install.packages("dplyr")
library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)


path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment 1/A - 1/TS(",x,").txt", sep = ""))
}


# Dynamic global variable creation
for (i in seq(50,100,10)){
  assign(paste("TS",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}




# Analysing the averages
for (i in seq(50,100,10)){
  assign(paste("TS", i, ".avg", sep = ""), colMeans(get(paste("TS",i, sep = ""))))
}


ID <- c()
Value <- c()
Class <- c()

for(i in 1:length(TS50.avg)){
  for(j in seq(50,100,10)){
    ID <- c(ID, i)
    Value <- c(Value, get(paste("TS", j, ".avg", sep = ""))[i])
    Class <- c(Class, paste("", j/100, "", sep = ""))
  }
}

AVG.df <- data.frame(ID, Value, Class)
  
ggplot(AVG.df, mapping = aes(x = ID, y = Value, colour = Class)) +
  geom_line(size = 1) +
  labs(title = "Average GBest per Iteration",
       x="Iteration", colour = "delta percentage")






# Analysing the AUC
# variables for column based averages
trapezoidal <- function(data){ 
  results <- c()
  
  for (ID in 1:nrow(data)){
    results <- c(results, trapz(1:ncol(data), unlist(data[ID, ])))
  }
  
  return(results)
}


for (i in seq(50,100,10)){
  assign(paste("TS", i, ".auc", sep = ""), trapezoidal(get(paste("TS",i, sep = ""))))
}


ID <- c()
Value <- c()
Class <- c()

for(i in 1:length(TS50.auc)){
  for(j in seq(50,100,10)){
    ID <- c(ID, i)
    Value <- c(Value, get(paste("TS", j, ".auc", sep = ""))[i])
    Class <- c(Class, paste("", j/100, "", sep = ""))
  }
}

AUC.df <- data.frame(ID, Value, Class)

ggplot(AUC.df, aes(x = ID, y = Value, colour = Class)) +
  geom_point() +
  labs(title = "Learning Rate (AUC)", x="Map IDs", colour = "delta percentage")

ggplot(AUC.df, aes(x = Class, y = Value, colour = Class)) +
  geom_boxplot(outlier.shape = NA, ) +
  guides(color ="none") +
  labs(title = "Learning Rate (AUC)", x="Delta Percentage")

AUC.df %>%
  filter(Class == "1" | Class == "0.9") %>%
  ggplot(aes(x = Value, fill = Class, alpha = 1)) +
    geom_histogram(position = "identity") +
    guides(alpha ="none") +
    labs(title = "Learning Rate (AUC)", x="Value", fill = "delta percentage")


wilcox.test(Value ~ Class, data = filter(AUC.df, Class == "1" | Class == "0.7"))






# Clean up
x <- c()
y <- c()
z <- c()
for(i in seq(50,100,10)){
  x <- c(x, paste("TS", i, sep = ""))
  y <- c(y, paste("TS", i, ".avg", sep = ""))
  z <- c(z, paste("TS", i, ".auc", sep = ""))
}
rm(list = x, x)
rm(list = y, y)
rm(list = z, z, i, j, path)
rm(ID, Value, Class, AVG.df, AUC.df)
rm(trapezoidal)
