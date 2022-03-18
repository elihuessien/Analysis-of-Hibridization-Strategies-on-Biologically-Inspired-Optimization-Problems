#---- extract dataset
# returns path name based on value chosen
path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment1B/Size - 10/",x,"%.txt", sep = ""))
}

# creates global variable based on string names
# to store the complete dataset
for (i in seq(0,90,10)){
  assign(paste("elt",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}

IDs <- 1:nrow(elt0)


# data frame for storing AUC data
elt.AUC.df <- data.frame(ID <- IDs)

# assign trapz function to get AUC for all data
# giving each variant its own column
for (i in seq(0,90,10)){
  # assign data
  elt.AUC.df[ncol(elt.AUC.df)+1] <- trapezoidal(get(paste("elt",i, sep = "")))
  # name new column
  names(elt.AUC.df)[ncol(elt.AUC.df)] <- paste("elt",i, sep = "")
}


# analysing avg. and std.
averages = c()
standardDeviation = c()

for(i in 2:ncol(elt.AUC.df)){
  averages = c(averages, mean(elt.AUC.df[,i]))
  standardDeviation = c(standardDeviation, sd(elt.AUC.df[,i]))
}

averages
standardDeviation

x <- seq(0,90, 10)

elt.Stat <- data.frame(ID  <- x, 
                       avg <- averages,
                       std <- standardDeviation)

#displaying stats
ggplot(elt.Stat, aes(x = ID)) +
  geom_line(aes(y = avg), color="darkred", size = 1.2) +
  scale_x_continuous(breaks = seq(0, 90, by = 10)) +
  labs(title = "Average AUC",
       x="Elite Class Percentage",
       y="AUC",
       subtitle = "Size:10, Amount:100")



# I have highlighted 10% and 20% as my optimum values
# So I will perform extra statistical tests between them
# to get a statistical answer

value <- c()
class <- c()
for(i in 1:nrow(elt.AUC.df)){
  value <- c(value, elt.AUC.df$elt10[i])
  class <- c(class, "elt0")
  
  value <- c(value, elt.AUC.df$elt20[i])
  class <- c(class, "elt10")
}

elt.stat2 <- data.frame(value, class) 

wilcox.test(value ~ class, data = elt.stat2)


t.test(elt.AUC.df$elt0, elt.AUC.df$elt10)



# clean Up
x <- c()
for(i in seq(0,90,10)){
  x <- c(x, paste("elt", i, sep = ""))
}
rm(list = x, x, IDs, i, path)
rm(elt.AUC.df, averages, standardDeviation, elt.Stat, elt.stat2, value, class)
