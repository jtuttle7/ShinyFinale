library(xgboost)
library(tidyverse)
library(shiny)
library(DT)

# Load the model
DiamondClass <- xgb.load("diamonds.model")
load("DiamondClassInfo.rda")


# Build a function to see how well the predict function does. Make it near the actual stuff in your dataset
generatePreds <- function(depth = 60, table = 50, price = 335, x = 4, y = 4){
  
  # This must be the same order as the x that the model was built on
  testDF <- as.matrix(
    depth,table,price,x,y
  )
  
  preds <- predict(DiamondClass, as.matrix(testDF))
  
  data.frame(
    Cut = DiamondClassInfo$var.levels
    , preds
  ) %>%
    arrange(desc(preds))
}

