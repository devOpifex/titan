getStorage <- function(name){
  items <- ls(titan:::titanCollector)
  for(item in items){
    metric <- titan:::titanCollector[[item]]
    
    if(metric$getName() == name)
      return(metric)
  }

  return("ERROR")
}