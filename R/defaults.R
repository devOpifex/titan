trackInputs <- function(name = "inputs", 
  session = shiny::getDefaultReactiveDomain()){

  inputCounter <- Counter$new(
    name,
    "Number of times inputs were triggered",
    labels = "name"
  )

  session$onInputReceived(function(val){
    inputNames <- parseInputNames(names(val))

    sapply(inputNames, function(n){
      inputCounter$inc(1, name = n)
    })

    return(val)
  })
}

parseInputNames <- function(names){
  gsub("-", "_", names)
}