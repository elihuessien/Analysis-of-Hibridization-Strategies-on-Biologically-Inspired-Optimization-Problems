library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)

# returns path name based on value chosen
path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment3A/Size - 10/w(0.",x,").txt", sep = ""))
}

# creates global variable based on string names
# to store the complete dataset
for (i in 1:10){
  assign(paste("w",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}


# dataframe for alpha AUC data
w.AUC.df <- data.frame(ID <- 1:nrow(w1))

# assign trapz function to get AUC for all data
# giving each variant its own column
for (i in 1:10){
  # assign data
  w.AUC.df[ncol(w.AUC.df)+1] <- trapezoidal(get(paste("w",i, sep = "")))
  # name new column
  names(w.AUC.df)[ncol(w.AUC.df)] <- paste("w",i, sep = "")
}


# analysing avg. and std.
averages = c()
standardDeviation = c()

# for each column (w1, w2...)
for(i in 2:ncol(w.AUC.df)){
  averages = c(averages, mean(w.AUC.df[,i]))
  standardDeviation = c(standardDeviation, sd(w.AUC.df[,i]))
}

w.Stat <- data.frame(ID  <- 1:10, 
                         avg <- averages,
                         std <- standardDeviation)

#displaying stats
ggplot(w.Stat, aes(x = ID)) +
  geom_line(aes(y = avg), color="darkred", size = 1.2) +
  #geom_line(aes(y = std), color="steelblue", size = 1.2) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  labs(title = "Average AUC",
       x="Inertia Weight (1 = 10%, 2 = 20%...)",
       y="Average",
         subtitle = "MapSize:10, MapCount:100")



# Statistical Analysis of experiment results

value <- c()
class <- c()
for(i in 1:nrow(w.AUC.df)){
  value <- c(value, w.AUC.df$w5[i])
  class <- c(class, "w5")
  
  value <- c(value, w.AUC.df$w4[i])
  class <- c(class, "w4")
}

w.stat2 <- data.frame(value, class)

wilcox.test(value ~ class, data = w.stat2)




# Clean Up
values <- c()
for (i in 1:10){
  values <- c(values, paste("w",i, sep = ""))
}

rm(list = values, values)
rm(path, ID, w.AUC.df)
rm(averages, standardDeviation, avg, std, w.Stat)
rm(value, class, w.stat2)