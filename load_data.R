if(!exists('load_data_R')){
  load_data_R<-T
  
  library(rjson)
  
  dk_map <- fromJSON(file="https://raw.githubusercontent.com/moestrup/covid19/master/test.json")
  
  kommuneareal <- read.csv(url("https://raw.githubusercontent.com/PhazeDK/catch3/master/data/kommuneareal.csv"),
                           encoding="UTF-8", stringsAsFactors=FALSE, header = TRUE)
}