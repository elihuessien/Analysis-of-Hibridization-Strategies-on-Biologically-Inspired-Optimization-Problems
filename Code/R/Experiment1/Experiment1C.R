library(pracma)
library(dplyr)
library(datasets)

# data paths
path1 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1C/Size - 10/Base_SS.txt"
path2 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1C/Size - 10/Elt.txt"
path3 <- "C:/Users/C14460702/Dissertation/Data/Results/Experiment1C/Size - 10/Elt_SS.txt"

# extract data
base.SS.data <- read.table(path1, header=FALSE, sep=",", dec=".")
elt.data <- read.table(path1, header=FALSE, sep=",", dec=".")
elt.ss.data <- read.table(path1, header=FALSE, sep=",", dec=".")



# dataframe storing averages for analysis
SS.AVG.df <- data.frame(ID <- 1:ncol(base.SS.data),
                        base.SS.avg  <- colMeans(base.SS.data),
                        elt.avg <- colMeans(elt.data),
                        elt.ss.avg <- colMeans(elt.ss.data))

# plot averages
ggplot(SS.AVG.df, aes(x=ID)) +
  geom_line(aes(y = base.SS.avg), color="violet", size = 1) +
  geom_line(aes(y = elt.avg), color="darkred", size = 1) +
  geom_line(aes(y = elt.ss.avg), color="steelblue", size = 1) +
  labs(title = "Average GBest per iteration",
       x="Iteration",
       y="GBest",
       subtitle = "Size:10, Amount:100")


# clean up
rm(base.SS.data, elt.data, elt.ss.data, SS.AVG.df)
rm(base.SS.avg, elt.avg, elt.ss.avg, ID, path1, path2, path3)
