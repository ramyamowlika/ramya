install.packages("timetk")
install.packages("tidyquant")
library(tidyquant) # To download the data
library(plotly) # To create interactive charts
library(timetk) # To manipulate the data series
tick <- c('AMZN', 'AAPL', 'NFLX', 'XOM', 'T')

price_data <- tq_get(tick,
                     from = '2014-01-01',
                     to = '2018-05-31',
                     get = 'stock.prices')
price_data
##return price of stocks is the change in dollars in the price when compared to the previous close

log_ret_tidy <- price_data %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = 'daily',
               col_rename = 'ret',
               type = 'log')

log_ret_tidy
## data is in tidy format so now we will use spread function to convert the data into wide format
library(dplyr)
library(tidyverse)
log_ret_xts <- log_ret_tidy %>%
  spread(symbol, value = ret) %>%
  tk_xts()

head(log_ret_xts)

## mean retuns of each stock
mean_ret <- colMeans(log_ret_xts)
print(round(mean_ret, 5))

## 
cov_mat <- cov(log_ret_xts) * 252

print(round(cov_mat,4))