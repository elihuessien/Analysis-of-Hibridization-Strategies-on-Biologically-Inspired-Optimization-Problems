library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

# data paths
path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1C/Size - 10/Base_SS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1C/Size - 10/Elt.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1C/Size - 10/Elt_SS.txt"

# extract data
ss.data <- read.table(path1, header=FALSE, sep=",", dec=".")
elt.data <- read.table(path2, header=FALSE, sep=",", dec=".")
elt.ss.data <- read.table(path3, header=FALSE, sep=",", dec=".")



# dataframe storing averages for analysis
SS.AVG.df <- data.frame(ID <- 1:ncol(ss.data),
                        ss.avg  <- colMeans(ss.data),
                        elt.avg <- colMeans(elt.data),
                        elt.ss.avg <- colMeans(elt.ss.data))

# plot averages
ggplot(SS.AVG.df, aes(x=ID)) +
  geom_line(aes(y = ss.avg), color="darkred", size = 1) +
  geom_line(aes(y = elt.avg), color="violet", size = 1) +
  geom_line(aes(y = elt.ss.avg), color="steelblue", size = 1) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "Size:10, Amount:100")


# data frame for storing AUC data
AUC.df <- data.frame(ID <- 1:nrow(ss.data),
                     ss <- trapezoidal(ss.data),
                     elt <- trapezoidal(elt.data),
                     elt.ss <- trapezoidal(elt.ss.data))

# quick point plot
ggplot(AUC.df, aes(x=ID)) +
  geom_point(aes(y = ss), color="darkred", size = 1.2) +
  geom_point(aes(y = elt), color="violet", size = 1.2) +
  geom_point(aes(y = elt.ss), color="steelblue", size = 1.2) +
  labs(title = "Learning Rate(AUC) per run",
       x="Map ID",
       y="AUC",
       subtitle = "Size:10, Amount:100")

# quick point plot
ggplot(AUC.df) +
  geom_histogram(aes(x = ss), color = "grey", fill="darkred") +
  #geom_histogram(aes(x = elt), color = "grey", fill="violet") +
  #geom_histogram(aes(x = elt.ss), color = "grey", fill="steelblue") +
  labs(title = "Steady State AUC",
       x="Learning Rate(AUC) per run",
       y="Count",
       subtitle = "Size:10, Amount:100")



AUC.df[2]

AUC.df[3, 2]

value <- c()
class <- c()
for (row in 1:nrow(AUC.df)){
  value <- c(value, AUC.df[row, 4])  # Add ss column
  class <- c(class, "elt.ss")
  
  value <- c(value, AUC.df[row, 3])  # Add elt column
  class <- c(class, "elt")
}

Stat.df <- data.frame(value, class)

wilcox.test(value ~ class, data = Stat.df)


# clean up
rm(base.SS.data, elt.data, elt.ss.data, SS.AVG.df)
rm(base.SS.avg, elt.avg, elt.ss.avg, ID, path1, path2, path3)
