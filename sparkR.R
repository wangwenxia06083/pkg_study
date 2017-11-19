sc <- spark_connect(master = "local")
testing <- spark_read_csv(sc,'testing',path = 'E:/R/test_data/revenue_new.csv')
library(DBI)
dbGetQuery(sc,"select * from testing limit 5")