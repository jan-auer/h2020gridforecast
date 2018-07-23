library(tidyverse)

# creates a naive model for the data and returns scaled errors

naiveerrors<-function(train_all, adapt_all){

results<-numeric(24819);
errors<-numeric(1916);
scaled_errors<-numeric(1916);

for(i in seq(1,1916,1)){
  training_data<-(train_all[[i]])
  test_data<-(adapt_all[[i]])
  last_hour<-tail(training_data, n=12)
  our_data<-c(last_hour,test_data)
  for(t in seq(1,24808,12)){
    medium<-(our_data[t]+our_data[t+1]+our_data[t+2]+our_data[t+3]+our_data[t+4]+our_data[t+5]+our_data[t+6]+our_data[t+7]+our_data[t+8]+our_data[t+9]+our_data[t+10]+our_data[t+11])/12
    results[seq(t,t+11)]<-rep(medium,12)
  }
  rolling_msfe <- cummean(((test_data - results)^2))
  errors[i]<-rolling_msfe[23819]
  scaled_errors[i]<-errors[i]/var(training_data)
}
return (scaled_errors)
}