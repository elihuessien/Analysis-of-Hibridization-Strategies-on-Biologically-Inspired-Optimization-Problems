library(ggplot2)
library(pracma)
library(dplyr)
library(datasets)


#---- extract dataset

# returns path name based on value chosen
path <- function(x){
  return(paste("C:/Users/C14460702/Dissertation/Data/Results/Experiment2B/Size - 10/",x,"%.txt", sep = ""))
}

# creates global variable based on string names
# to store the complete dataset
for (i in 1:99){
  assign(paste("evap",i, sep = ""), read.delim(path(i), header=FALSE, sep=",", dec="."))
}



# dataframe for alpha AUC data
evap.AUC.df <- data.frame(ID <- 1:nrow(evap1))


# assign trapz function to get AUC for all data
# giving each variant its own column
for (i in 1:99){
  # assign data
  evap.AUC.df[ncol(evap.AUC.df)+1] <- trapezoidal(get(paste("evap",i, sep = "")))
  # name new column
  names(evap.AUC.df)[ncol(evap.AUC.df)] <- paste("evap",i, sep = "")
}



averages = c()
standardDeviation = c()

# for each column (evap1, evap2...)
for(i in 2:ncol(evap.AUC.df)){
  averages = c(averages, mean(evap.AUC.df[,i]))
  standardDeviation = c(standardDeviation, sd(evap.AUC.df[,i]))
}

evap.Stat <- data.frame(ID  <- 1:99, 
                         avg <- averages,
                         sd <- standardDeviation)


#displaying stats
ggplot(evap.Stat, aes(x = ID)) +
  #geom_line(aes(y = avg), color="darkred", size = 1.2) +
  geom_line(aes(y = sd), color="steelblue", size = 1.2) +
  scale_x_continuous(breaks = seq(0, 100, by = 10)) +
  labs(title = "AUC Standard Deviation",
       x="Evaporation Rate",
       y="SD",
       subtitle = "Size:10, Amount:100")




# clean up
values <- c()
for (i in 1:99){
  values <- c(values, paste("evap",i, sep = ""))
}

rm(list = values, values)
rm(path, evap.AUC.df, averages, standardDeviation, evap.Stat)
rm(ID, avg, sd, i)
