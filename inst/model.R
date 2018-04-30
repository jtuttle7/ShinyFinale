library(xgboost)
library(tidyverse)

Diamonds <- diamonds

# The outcome
y1 <- Diamonds$cut

# Save out the levels
var.levels <- levels(y1)

# XGBoost needs a zero value, so subtract 1
# Predicted values need to be numerical 
y <- as.integer(y1) - 1


# Drop outcome column 
noOutcome <- Diamonds[,-2] 

# Get rid of stuff we don't care about (list columns to keep). Also to make all numeric
x <- noOutcome[,c('depth','table','price','x','y')]

# Character vector with variable names in it
var.names <- names(x)

# Make it a matrix, all entries must be numeric
x <- as.matrix(x)

# Parameters we're going to send to XGBoost
params <- list(
  "objective" = "multi:softprob" # "One vs All" will build an individual model that compoares one variable vs the combination of all the others. then it'll force the probabilities to all add up to 1
  , "eval_metric" = "mlogloss" # Multi objective logLoss
  , "num_class" = length(table(y)) # How many classes are we trying to predict into
  , "eta" = 0.5 # Step-size
  , "max_depth" = 3 # How many splits in my trees
)

# Cross-validation
cv.nround <- 1000

# label is the outcome
# prediction = TRUE lets us see the logloss values its calculating. We want to see a large divergence between the test and train logloss, this will tell us we've passed taht minimum test error point.
# logLoss effectively penalizes you for how far away you are on your predictions. Take basketball. If one team is 99% guaranteed to win, and you predict a win, and they lose. You would get a huge logloss value because you shouldn't have missed that.
bst.cv <- xgb.cv(param = params, data = x, label = y
                 , nfold = 5, nrounds = cv.nround
                 , missing = NA, prediction = TRUE
                 )

# Find where the minimum test error was
nround <- which.min(bst.cv$evaluation_log$test_mlogloss_mean)
# Print that row out
bst.cv$evaluation_log[nround,]

# Build the model
DiamondClass <- xgboost(param=params,data = x 
                        , label = y, nrounds = nround
                        , missing = NA)

# Save the model
xgb.save(DiamondClass,"diamonds.model")

# Variable to contain the model information
DiamondClassInfo <- list(
  var.names = var.names
  , var.levels = var.levels
)

# Save the list for later
save(DiamondClassInfo, file = 'DiamondClassInfo.rda')

# See how each variable affected the model
# Gain is pretty much how each variable affects it
xgb.importance(var.names, model = DiamondClass)

























