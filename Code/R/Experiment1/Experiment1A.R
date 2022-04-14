install.packages("ggplot2")
install.packages("pracma")
install.packages("dplyr")
library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1A/Size - 10/StochasticUniversalSampling_data.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1A/Size - 10/RankingBasedSampling_data.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1A/Size - 10/TournamentSampling_data.txt"

#---------Visualizing Averages------------#
# Complete G-Best data 
SUS.data <- read.table(path1, header=FALSE, sep=",", dec=".")
RBS.data <- read.table(path2, header=FALSE, sep=",", dec=".")
TS.data  <- read.table(path3, header=FALSE, sep=",", dec=".")


AVG.df <- data.frame(ID <- 1:ncol(SUS.data),
                     SUS.avg  <- colMeans(SUS.data),
                     RBS.avg <- colMeans(RBS.data),
                     TS.avg <- colMeans(TS.data))

# plot data
ggplot(AVG.df, aes(x=ID)) +
  geom_line(aes(y = SUS.avg), color="darkred", size = 1.2) +
  geom_line(aes(y = RBS.avg), color="violet", size = 1.2) +
  geom_line(aes(y = TS.avg), color="steelblue", size = 1.2) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "Size:10, Amount:100")




#---------Visualizing AUC------------#

# Calculate area under the curve for each row (run)
# of the dataset using the trapezoidal rule. 

trapezoidal <- function(data){ 
  results <- c()
  
  for (ID in 1:nrow(data)){
    results <- c(results, trapz(1:ncol(data), unlist(data[ID, ])))
  }
  
  return(results)
}


# final dataframe for plotting  and further analysis
AUC.df <- data.frame(ID <- 1:nrow(SUS.data), 
                     SUS.auc <- trapezoidal(SUS.data),
                     RBS.auc <- trapezoidal(RBS.data),
                     TS.auc  <- trapezoidal(TS.data))


# quick point plot
ggplot(AUC.df, aes(x=ID)) +
  geom_point(aes(y = SUS.auc), color="darkred", size = 1.2) +
  geom_point(aes(y = RBS.auc), color="violet", size = 1.2) +
  geom_point(aes(y = TS.auc), color="steelblue", size = 1.2) +
  labs(title = "Learning Rate(AUC) per run",
       x="Map ID",
       y="AUC",
       subtitle = "Size:10, Amount:100")

# quick point plot
ggplot(AUC.df) +
  #geom_histogram(aes(x = SUS.auc), color = "grey", fill="darkred") +
  #geom_histogram(aes(x = RBS.auc), color = "grey", fill="violet") +
  geom_histogram(aes(x = TS.auc), color = "grey", fill="steelblue") +
  labs(title = "Learning Rate(AUC) per run",
       x="TS AUC",
       y="Count",
       subtitle = "Size:10, Amount:100")


# save mean values
mean(AUC.df$SUS.auc)
mean(AUC.df$RBS.auc)
mean(AUC.df$TS.auc)

sd(AUC.df$SUS.auc)
sd(AUC.df$RBS.auc)
sd(AUC.df$TS.auc)







#---------AUC Statistical Tests------------#
# Making composit dataframe for Statistics
value <- c()
class <- c()
for (row in 1:nrow(AUC.df)){
  value <- c(value, AUC.df$SUS.auc[row])  # Add SUS column
  class <- c(class, "SUS")
  
  value <- c(value, AUC.df$RBS.auc[row])  # Add RBS column
  class <- c(class, "RBS")
  
  value <- c(value, AUC.df$TS.auc[row])   # Add TS column
  class <- c(class, "TS")
}

Stat.df <- data.frame(value, class)

# anova test
aova.data <- aov(value ~ class, data = Stat.df)
summary(aova.data)


#wilcoxon test
#extract 2 class

wilcox.test(value ~ class, data = filter(Stat.df, class == "RBS" | class == "TS"))


# clean up
rm(path1, path2, path3)
rm(SUS.avg, RBS.avg, TS.avg, AVG.df)
rm(value, class, Stat.df, aova.data)
