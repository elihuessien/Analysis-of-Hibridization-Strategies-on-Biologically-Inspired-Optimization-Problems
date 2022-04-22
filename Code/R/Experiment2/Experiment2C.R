library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment2C/Size - 10/AS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment2C/Size - 10/MM1.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment2C/Size - 10/MM2.txt"


AS.data <- read.table(path1, header=FALSE, sep=",", dec=".")
MM1.data <- read.table(path2, header=FALSE, sep=",", dec=".")
MM2.data <- read.table(path3, header=FALSE, sep=",", dec=".")

AVG.df <- data.frame(ID <- 1:ncol(AS.data),
                     AS.avg  <- colMeans(AS.data),
                     MM1.avg <- colMeans(MM1.data),
                     MM2.avg <- colMeans(MM2.data))

# plot data
ggplot(AVG.df, aes(x=ID)) +
  geom_line(aes(y = AS.avg), color="darkred", size = 1.2) +
  geom_line(aes(y = MM1.avg), color="violet", size = 1.2) +
  geom_line(aes(y = MM2.avg), color="steelblue", size = 1.2) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "Size:10, Amount:100")


# clean up
rm(path1, path2, path3, AS.data, MM1.data, MM2.data)
rm(AVG.df, ID, AS.avg, MM1.avg, MM2.avg)
