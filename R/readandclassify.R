library(medulloPackage)

readandclassify <- function(expr, meta = NA, ext){

  if(ext == "tsv"){
    print("reading TAB delimited file!")
    expr <- read.delim(file = expr, header = T, check.names = F, stringsAsFactors = F)
    if(!is.na(meta)){
      actual <- read.delim(file = meta, header = F, check.names = F, stringsAsFactors = F)
      actual <- as.character(actual[,1])
    }
  } else if(ext == "RData") {
    print("loading RData objects!")
    expr <- get(load(expr))
    if(!is.na(meta)){
      actual <- get(load(meta))
    }
  } else if(ext == "RDS"){
    print("reading RDS files!")
    expr <- readRDS(expr)
    if(!is.na(meta)){
      actual <- readRDS(meta)
    }
  }

  print("Done reading...")

  # classify
  print("Start classifying...")
  pred <- classify(exprs = expr)
  pred$p.value <- format(pred$p.value, scientific = T, digits = 3)
  print("Done classifying...!")

  # stats
  if(!is.na(meta)){
    print("Start accuracy testing...")
    accuracy <- calcStats(myClassActual = actual, myClassPred = pred$best.fit)
    print("Done accuracy testing...!")
  } else {
    accuracy <- NA
  }

  return(list(accuracy = accuracy, pred = pred))
}
