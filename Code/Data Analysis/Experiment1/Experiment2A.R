library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)


#---- extract dataset

# returns path name based on value chosen
path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment2A/Size - 10/ASTest_alpha(",x,").txt", sep = ""))
}

# creates global variable based on string names
# to store the complete dataset
for (i in 1:10){
  assign(paste("alpha",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}



# dataframe for alpha AUC data
alpha.AUC.df <- data.frame(ID <- 1:nrow(alpha1))


# assign trapz function to get AUC for all data
# giving each variant its own column
for (i in 1:10){
  # assign data
  alpha.AUC.df[ncol(alpha.AUC.df)+1] <- trapezoidal(get(paste("alpha",i, sep = "")))
  # name new column
  names(alpha.AUC.df)[ncol(alpha.AUC.df)] <- paste("alpha",i, sep = "")
}




# analysing avg. and std.
averages = c()
standardDeviation = c()

# for each column (Alhpa1, Alpha2...)
for(i in 2:ncol(alpha.AUC.df)){
  averages = c(averages, mean(alpha.AUC.df[,i]))
  standardDeviation = c(standardDeviation, sd(alpha.AUC.df[,i]))
}

alpha.Stat <- data.frame(ID  <- 1:10, 
                       avg <- averages,
                       std <- standardDeviation)

#displaying stats
ggplot(alpha.Stat, aes(x = ID)) +
  geom_line(aes(y = avg), color="darkred", size = 1.2) +
  #geom_line(aes(y = std), color="steelblue", size = 1.2) +
  scale_x_continuous(breaks = seq(1, 10, by = 1)) +
  labs(title = "AUC Standard Deviation",
       x="Alpha Ratio to Beta(1)",
       y="SD",
       subtitle = "Size:10, Amount:100")




# Analysis of alpha ratio of 5 vs 7
# I have highlighted 10% and 20% as my optimum values
# So I will perform extra statistical tests between them
# to get a statistical answer

value <- c()
class <- c()
for(i in 1:nrow(alpha.AUC.df)){
  value <- c(value, alpha.AUC.df$alpha5[i])
  class <- c(class, "alpha5")
  
  value <- c(value, alpha.AUC.df$alpha3[i])
  class <- c(class, "alpha3")
}

alpha.stat2 <- data.frame(value, class)

wilcox.test(value ~ class, data = alpha.stat2)



#clean Up
values <- c()
for (i in 1:10){
  values <- c(values, paste("alpha",i, sep = ""))
}

rm(list = values, values)
rm(alpha.Stat, alpha.stat2, alpha.AUC.df)
rm(path, averages, standardDeviation, value, class)