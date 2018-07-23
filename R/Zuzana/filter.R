library(tidyverse)

#calculate maximum zero sequence length
filterdata<-function(train_all, adapt_all, maxzerolength = 120){
  mm <- numeric(ncol(train_all)-1)

  for (i in 1:(ncol(train_all)-1)){
    fulldata<-c(train_all[[i]],adapt_all[[i]])
    rr <- rle(fulldata == 0)
    mm[i] <- max(rr$lengths[rr$values == TRUE])
  }
  x<-seq(1:1916)
  table<-data.frame(x,mm)
  colnames(table)<-c("time series","maxsequencelength")
  nonzerotimeseries<- table %>% filter(maxsequencelength<=maxzerolength)
  return(nonzerotimeseries)
}
