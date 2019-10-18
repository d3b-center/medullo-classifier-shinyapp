library(medulloPackage)

readandclassify <- function(expr, meta, ext){
  
  if(ext == "tab"){
    print("reading TAB delimited file!")
    expr <- read.delim(expr, file = expr, header = T, check.names = F, stringsAsFactors = F)
    actual <- read.delim(expr, file = meta, header = F, check.names = F, stringsAsFactors = F)
  } else if(ext == "RData") {
    print("loading RData objects!")
    expr <- get(load(expr))
    actual <- get(load(meta))
  } else if(ext == "RDS"){
    print("reading RDS files!")
    expr <- readRDS(expr)
    actual <- readRDS(meta)
  }
  actual <- as.character(actual$subtype)
  
  print("Done reading...")
  # print(head(expr)[,1:5])
  # print(head(actual))
  
  
  # classify
  print("Start classifying...")
  pred <- classify(exprs = expr)
  print("Done classifying...!")
  # print(head(pred))
  # stats
  print("Start accuracy testing...")
  accuracy <- calcStats(myClassActual = actual, myClassPred = pred)
  print("Done accuracy testing...!")
  # print(accuracy)
  return(accuracy)
}