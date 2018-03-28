library(reshape2)
library(ggplot2)

reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  hc <- hclust(dd)
  cormat <-cormat[hc$order, hc$order]
}

train_all <- readRDS(file = "/home/datascience/local_data/train_all.rds")
train_all_non_empty <- train_all[, colMeans(train_all) != 0]
cors_non_empty <- cor(train_all_non_empty %>% select(-timestamp))
cors_non_empty_reorderd <- reorder_cormat(cors_non_empty)
melted_cors <- melt(cors_non_empty_reorderd[1:250,1:250])

cors_sign_non_empty <- cor(sign(train_all_non_empty %>% select(-timestamp)))
cors_sign_non_empty_reordered <- reorder_cormat(cors_sign_non_empty)
melted_cors_sign <- melt(cors_sign_non_empty_reordered[1:250,1:250])

ggplot(data = melted_cors, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() + 
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white", 
    midpoint = 0, limit = c(-1,1), space = "Lab", 
    name="Pearson\nCorrelation")

ggplot(data = melted_cors_sign, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() + 
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white", 
    midpoint = 0, limit = c(-1,1), space = "Lab", 
    name="Pearson\nCorrelation")
