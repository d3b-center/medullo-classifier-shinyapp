library(medulloPackage)

readandclassify <- function(expr, meta, ext){

  if(ext == "tab"){
    print("reading TAB delimited file!")
    expr <- read.delim(file = expr, header = T, check.names = F, stringsAsFactors = F)
    actual <- read.delim(file = meta, header = F, check.names = F, stringsAsFactors = F)
    actual <- as.character(actual[,1])
  } else if(ext == "RData") {
    print("loading RData objects!")
    expr <- get(load(expr))
    actual <- get(load(meta))
  } else if(ext == "RDS"){
    print("reading RDS files!")
    expr <- readRDS(expr)
    actual <- readRDS(meta)
  }

  print("Done reading...")

  # classify
  print("Start classifying...")
  pred <- classify(exprs = expr)
  print("Done classifying...!")

  # stats
  print("Start accuracy testing...")
  accuracy <- calcStats(myClassActual = actual, myClassPred = pred$best.fit)
  print("Done accuracy testing...!")

  return(list(accuracy = accuracy, pred = pred))
}
