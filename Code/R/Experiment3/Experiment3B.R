library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment3/Size - 10/PSO.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment3/Size - 10/PSO(W 0.5).txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment3/Size - 10/PSO(W 0.9-0.4).txt"

PSO1.data <- read.table(path1, header=FALSE, sep=",", dec=".")
PSO2.data <- read.table(path2, header=FALSE, sep=",", dec=".")
PSO3.data  <- read.table(path3, header=FALSE, sep=",", dec=".")

AVG.df <- data.frame(ID <- 1:ncol(PSO1.data),
                     PSO1.avg  <- colMeans(PSO1.data),
                     PSO2.avg <- colMeans(PSO2.data),
                     PSO3.avg <- colMeans(PSO3.data))

# plot averages
ggplot(AVG.df, aes(x=ID)) +
  geom_line(aes(y = PSO1.avg), color="darkred", size = 1.2) +
  geom_line(aes(y = PSO2.avg), color="violet", size = 1.2) +
  geom_line(aes(y = PSO3.avg), color="steelblue", size = 1.2) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "mapSize:10, popSize:100")


# dataframe for plotting and further analysis
AUC.df <- data.frame(ID <- 1:ncol(PSO1.data),
                     PSO1.auc  <- trapezoidal(PSO1.data),
                     PSO2.auc <- trapezoidal(PSO2.data),
                     PSO3.auc <- trapezoidal(PSO3.data))

# quick point plot
ggplot(AUC.df, aes(x=ID)) +
  geom_point(aes(y = PSO1.auc), color="darkred", size = 1.2) +
  geom_point(aes(y = PSO2.auc), color="violet", size = 1.2) +
  geom_point(aes(y = PSO3.auc), color="steelblue", size = 1.2) +
  labs(title = "Learning Rate(AUC) per run",
       x="Map ID",
       y="AUC",
       subtitle = "mapSize:10, popSize:100")


# quick point plot
ggplot(AUC.df) +
  #geom_histogram(aes(x = PSO1.auc), color = "grey", fill="darkred") +
  #geom_histogram(aes(x = PSO2.auc), color = "grey", fill="violet") +
  geom_histogram(aes(x = PSO3.auc), color = "grey", fill="steelblue") +
  labs(title = "Learning Rate(AUC) per run",
       x="PSO with inertia weight (0.9-0.4)",
       y="Count",
       subtitle = "mapSize:10, popSize:100")


#---------AUC Statistical Tests------------#
# Making composit dataframe for Statistics
value <- c()
class <- c()
for (row in 1:nrow(AUC.df)){
  value <- c(value, AUC.df$PSO1.auc[row])  # Add SUS column
  class <- c(class, "PSO1")
  
  value <- c(value, AUC.df$PSO2.auc[row])  # Add RBS column
  class <- c(class, "PSO2")
  
  value <- c(value, AUC.df$PSO3.auc[row])   # Add TS column
  class <- c(class, "PSO3")
}

Stat.df <- data.frame(value, class)


wilcox.test(value ~ class, data = filter(Stat.df, class == "PSO1" | class == "PSO3"))


# clean up
rm(path1, path2, path3, PSO1.data, PSO2.data, PSO3.data)
rm(AVG.df, ID, PSO1.avg, PSO2.avg, PSO3.avg)
rm(AUC.df, ID, PSO1.auc, PSO2.auc, PSO3.auc)
rm(Stat.df, value, class, row)
