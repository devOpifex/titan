library(titan)

cnter <- Counter$new(
  "home", 
  "Counts number of pings at /",
  labels = "endpoint"
)

#* Increment a counter
#* @get /
function() {
  cnter$inc(endpoint = "home")
  return("Hello titan!")
}

#* Increment the same counter
#* @get /count
function() {
  cnter$inc(endpoint = "count")
  return("More titan!")
}

#* Render Metrics
#*
#* @serializer text
#* @get /metrics
titanPlumber
