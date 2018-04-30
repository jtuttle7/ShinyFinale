### Lecture 11 Notes

# Tyler typically builds his XGBoost models in two steps. The first is to find the minimum in iterations for test error. The second is to actually build the model, limited at that minimum point in test error. He will typically do this with 5-fold cross validation. XGBoost does this automatically. 

# We're basically creating 5 datasets, then drop 1/5th of the dataset each time to train, then we'll try to predict the piece we held out. Then we'll average the logLoss of each of the 5 to get the test error



# Prophet package (google it)
# Builds forecasts based on input. Super cool!!!

# Arima Model, another method of forecasting. Look into that?.. Tyler says Prophet is WAY EASIER.


# shinyapps.io - go here to get packages to be able to hook up shiny apps to the web

# Rstudio has a shiny server pro that you might be able to use as well








