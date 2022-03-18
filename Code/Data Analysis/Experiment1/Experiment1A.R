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
path4 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1A/Size - 10/StochasticUniversalSampling_avg.txt"
path5 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1A/Size - 10/RankingBasedSampling_avg.txt"
path6 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1A/Size - 10/TournamentSampling_avg.txt"

#---------Visualizing Averages------------#
# average GBest data
SUS_avg  <- read.delim(path4, header=FALSE, sep=",", dec=".")
RBS_avg  <- read.delim(path5, header=FALSE, sep=",", dec=".")
TS_avg   <- read.delim(path6, header=FALSE, sep=",", dec=".")

# transpose tables creating vectors
SUS_avg <- t(SUS_avg)
RBS_avg <- t(RBS_avg)
TS_avg  <- t(TS_avg)

# convert from 2D to 1D
SUS_avg <- SUS_avg[,1]
RBS_avg <- RBS_avg[,1]
TS_avg  <- TS_avg[,1]

# create data frame for analysis
AVG.df <- data.frame(IDs, SUS_avg, RBS_avg, TS_avg)

# plot data
ggplot(AVG.df, aes(x=ID)) +
  geom_line(aes(y = SUS_avg), color="darkred", size = 1.2) +
  geom_line(aes(y = RBS_avg), color="violet", size = 1.2) +
  geom_line(aes(y = TS_avg), color="steelblue", size = 1.2) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "Size:10, Amount:100")




#---------Visualizing AUC------------#
# Complete G-Best data 
SUS_data <- read.table(path1, header=FALSE, sep=",", dec=".")
RBS_data <- read.table(path2, header=FALSE, sep=",", dec=".")
TS_data  <- read.table(path3, header=FALSE, sep=",", dec=".")

SUS_data[99,]

# iteration IDS
IDs  <- 1:nrow(SUS_data)

# Calculate area under the curve for each row (run)
# of the dataset using the trapezoidal rule. 

trapezoidal <- function(data){
  results <- c()
  
  for (ID in IDs){
    results <- c(results, trapz(1:ncol(data), unlist(data[ID, ])))
  }
  
  return(results)
}


# final dataframe for plotting  and further analysis
AUC.df <- data.frame(IDs, 
                     SUS_auc = trapezoidal(SUS_data),
                     RBS_auc = trapezoidal(RBS_data),
                     TS_auc  = trapezoidal(TS_data))


# quick point plot
ggplot(AUC.df, aes(x=IDs)) +
  geom_point(aes(y = SUS_auc), color="darkred", size = 1.2) +
  geom_point(aes(y = RBS_auc), color="violet", size = 1.2) +
  geom_point(aes(y = TS_auc), color="steelblue", size = 1.2) +
  labs(title = "Learning Rate(AUC) per run",
       x="Map ID",
       y="AUC",
       subtitle = "Size:10, Amount:100")

# quick point plot
ggplot(AUC.df) +
  geom_histogram(aes(x = SUS_auc), color = "grey", fill="darkred") +
  #geom_histogram(aes(x = RBS_auc), color = "grey", fill="violet") +
  #geom_histogram(aes(x = TS_auc), color = "grey", fill="steelblue") +
  labs(title = "Learning Rate(AUC) per run",
       x="SUS AUC",
       y="Count",
       subtitle = "Size:10, Amount:100")

#chose outlier ranges are
SUS.out <- AUC.df$SUS_auc >= 0.12
RBS.out <- AUC.df$RBS_auc >= 0.12
TS.out  <- AUC.df$TS_auc >= 0.12

# save mean values
sus.mean <- mean(AUC.df$SUS_auc)
rbs.mean <- mean(AUC.df$RBS_auc)
ts.mean <- mean(AUC.df$TS_auc)

# replace outliers
AUC.df$SUS_auc[SUS.out] <- sus.mean
AUC.df$RBS_auc[RBS.out] <- rbs.mean
AUC.df$TS_auc[TS.out]  <- ts.mean

#averages
mean(AUC.df$TS_auc)
sd(AUC.df$RBS_auc)






#---------AUC Statistical Tests------------#
# Making composit dataframe for Statistics
value <- c()
class <- c()
for (row in 1:nrow(AUC.df)){
  value <- c(value, AUC.df$SUS_auc[row])  # Add SUS column
  class <- c(class, "SUS")
  
  value <- c(value, AUC.df$RBS_auc[row])  # Add RBS column
  class <- c(class, "RBS")
  
  value <- c(value, AUC.df$TS_auc[row])   # Add TS column
  class <- c(class, "TS")
}

Stat.df <- data.frame(value, class)

# anova test
aova.data <- aov(value ~ class, data = Stat.df)
summary(aova.data)


#wilcoxon test
#extract 2 class
wilcox.data <- filter(Stat.df, class == "SUS" | class == "RBS")

wilcox.test(value ~ class, data = wilcox.data)


t.test(filter(Stat.df, class == "SUS")[1], filter(Stat.df, class == "TS")[1])

# clean up
rm(path1, path2, path3, path4, path5, path6)
rm(SUS_avg, RBS_avg, TS_avg, AVG.df)
rm(ID, IDs, SUS_data, RBS_data, TS_data, trapezoidal, AUC.df)
rm(SUS.out, RBS.out, TS.out, sus.mean, rbs.mean, ts.mean)
rm(value, class, Stat.df, aova.data, wilcox.data)
