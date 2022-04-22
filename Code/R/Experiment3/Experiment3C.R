library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment3/Size - 10/PSO.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment3/Size - 10/MPSO(50%).txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment3/Size - 10/MPSO(25%).txt"

PSO.data <- read.table(path1, header=FALSE, sep=",", dec=".")
MPSO50.data <- read.table(path2, header=FALSE, sep=",", dec=".")
MPSO25.data  <- read.table(path3, header=FALSE, sep=",", dec=".")

AVG.df <- data.frame(ID <- 1:ncol(PSO.data),
                     PSO.avg  <- colMeans(PSO.data),
                     MPSO50.avg <- colMeans(MPSO50.data),
                     MPSO25.avg <- colMeans(MPSO25.data))

# plot averages
ggplot(AVG.df, aes(x=ID)) +
  geom_line(aes(y = PSO.avg), color="darkred", size = 1.2) +
  geom_line(aes(y = MPSO50.avg), color="violet", size = 1.2) +
  geom_line(aes(y = MPSO25.avg), color="steelblue", size = 1.2) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "mapSize:10, popSize:100")


# dataframe for plotting and further analysis
AUC.df <- data.frame(ID <- 1:ncol(PSO.data),
                     PSO.auc  <- trapezoidal(PSO.data),
                     MPSO50.auc <- trapezoidal(MPSO50.data),
                     MPSO25.auc <- trapezoidal(MPSO25.data))

# quick point plot
ggplot(AUC.df, aes(x=ID)) +
  geom_point(aes(y = PSO.auc), color="darkred", size = 1.2) +
  geom_point(aes(y = MPSO50.auc), color="violet", size = 1.2) +
  geom_point(aes(y = MPSO25.auc), color="steelblue", size = 1.2) +
  labs(title = "Learning Rate(AUC) per run",
       x="Map ID",
       y="AUC",
       subtitle = "mapSize:10, popSize:100")


# quick point plot
ggplot(AUC.df) +
  #geom_histogram(aes(x = PSO.auc), color = "grey", fill="darkred") +
  #geom_histogram(aes(x = MPSO50.auc), color = "grey", fill="violet") +
  geom_histogram(aes(x = MPSO25.auc), color = "grey", fill="steelblue") +
  labs(title = "Learning Rate(AUC) per run",
       x="MPSO(25%) AUC",
       y="Count",
       subtitle = "mapSize:10, popSize:100")


#---------AUC Statistical Tests------------#
# Making composit dataframe for Statistics
value <- c()
class <- c()
for (row in 1:nrow(AUC.df)){
  value <- c(value, AUC.df$PSO.auc[row])  # Add SUS column
  class <- c(class, "PSO")
  
  value <- c(value, AUC.df$MPSO50.auc[row])  # Add RBS column
  class <- c(class, "MPSO(50)")
  
  value <- c(value, AUC.df$MPSO25.auc[row])   # Add TS column
  class <- c(class, "MPSO(25)")
}

Stat.df <- data.frame(value, class)


wilcox.test(value ~ class, data = filter(Stat.df, class == "MPSO(50)" | class == "MPSO(25)"))


# clean up
rm(path1, path2, path3, PSO.data, MPSO50.data, MPSO25.data)
rm(AVG.df, ID, PSO.avg, MPSO50.avg, MPSO25.avg)
rm(AUC.df, ID, PSO.auc, MPSO50.auc, MPSO25.auc)
rm(Stat.df, value, class, row)
