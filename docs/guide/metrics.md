# Metrics

Prometheus provides four types of metrics. This document only briefly explains them, please refer to the [official documentation](https://prometheus.io/docs/concepts/metric_types/) if you need to learn more about it.

Note that of the four types the most commonly used are the Counter and Gauge, the Histogram and Summary are extremely useful but used must less as they are most complicated to fully understand and set up correctly. Many client libraries of Prometheus do not even provide support for Histograms and Summaries. 

## Basics

Every metrics must bear a __unique name__ and help text. Titan __will not__ let you override a metric: make sure the names (identifiers) are unique.

The help text is also mandatory as per Prometheus, it allows giving more context on the metric tracked.

Optionally, metrics can also take labels, which will be detailed later in this document.

All metrics are R6 classes, you can have any number of these metrics in any project.

## Counter

A counter is the most basic metrics one can use. It consists of a simple counter __that can only go up__; the value of counters can never decrease.

This can be used to measure the number of times an application is visited, or the number of times an endpoint is hit: these values only ever go up. Never use Counters for values that go down, titan will not let you decrease their value.

Instantiate a new counter from the `Counter` R6 class, give it a name and some help text, then use the method `inc` to increase it. You can also use the method `set` to set it to a specific value, again make sure that value is greater than that which the counter already holds or it will throw a warning and _not set the counter to that value._

```r
c <- Counter$new(
  name = "btn_clicks_total",
  help = "Total clicks on buttons"
)

c$inc() # increase
c$inc(2) 

# preview the metrics
previewMetrics()
```

```
# HELP btn_clicks_total Total clicks on buttons
# TYPE btn_clicks_total counter
btn_clicks_total 3 
```

## Gauge

A gauge is very similar to the Counter at the exception that __its value can decrease__.

Then again this is set up in similar way as the Counter, the only difference is that it also has a `dec` method to decrease the gauge.

```r
g <- Gauge$new(
  name = "current_users_total",
  help = "Total number of users right now"
)

g$inc(2) # increase by 2
g$dec() # decrease by 1

# preview the metrics
previewMetrics()
```

```
# HELP current_users_total Total number of users right now
# TYPE current_users_total gauge
current_users_total 1
```

So why would you use a Counter when a Gauge does the same and more? Because this is stored and processed differently by Prometheus. Prometheus is, at its core, a time series database and will take the metric type into account when reporting metrics.

## Histogram

Histograms allow you to count observations and put them in configurable buckets.

Start by declaring a predicate; a function which will turn put the observations into buckets. A bucket is defined using the `bucket` function which takes 1) the label of the bucket, and 2) the value of said bucket. Below we create a predicate that will put the observations into two buckets. It will be used to measure the time it take to process a request, if the request takes more than 3 seconds it goes into a bucket called "3" and if it takes over 3 seconds it will put the observation into another bucket called "9".

```r
# predicate to put observations into buckets.
pred <- function(value){
  v <- as.numeric(value)

  # put in bucket 3 if less than 3 seconds
  if(v < 3)
    return(bucket(label = "3", v))

  # otherwise put in bucket 9
  bucket(label = "9", v)
}
```

The creation of the histogram itself differs little from other metrics: specify a unique name, help text, and pass the predicate function previously defined. 

```r
h <- Histogram$new(
  name = "request_process_time",
  help = "Time it took to process the request",
  predicate = pred
)
```

Here, to demonstrate, we create a function to simulate a request taking time by randomly making the function sleep for between 1 and 9 seconds. When the function exits we `observe` the time difference between the beginning and end of the function. The `observe` method will internally run the `predicate` and place the results into buckets.

```r
simulateRequest <- function(){
  # time at which the request starts
  start <- Sys.time()

  # when done
  on.exit({
    # compute time difference
    diff <- Sys.time() - start

    # observe data
    # will internally run `pred`
    h$observe(diff)
  })

  # sleep between 1 and 9 seconds
  Sys.sleep(sample(1:9, 1))

  print("done")
}

# simulate some requests
simulateRequest()
simulateRequest()
simulateRequest()
simulateRequest()

# preview the metrics
previewMetrics()
```

```
# HELP request_process_time Time it took to process the request
# TYPE request_process_time histogram
request_process_time {le="3"} 2 
request_process_time {le="9"} 2 
request_process_time_count 4 
request_process_time_sum 13.0094513893127 
```

Note that the histogram (as per Prometheus standards) also logs the `count`, the number of observations and the `sum` the sum of the observations. Above we can see that 4 requests were made that took a total of ~13 seconds; 2 of these took less than 3 seconds and the other 2 took more than that.

## Summary

The Summary metric is very similar to the histogram, and works the same with Titan (predicate, etc.) except it does not count the observations in each buckets, instead it computes the sum of it. Also these buckets in Summary are called quantiles and must be between zero and one (0 < q < 1). 

## Labels

Labels allow adding granularity to metrics without duplicating them.

From the [official documentation](https://prometheus.io/docs/practices/naming/#labels):

>  CAUTION: Remember that every unique combination of key-value label pairs represents a new time series, which can dramatically increase the amount of data stored. Do not use labels to store dimensions with high cardinality (many different label values), such as user IDs, email addresses, or other unbounded sets of values.

Say for instance you have a small API with three endpoints and simply want to track the number of times they get pinged.

Though you could create three separate Counters it might be more convenient to create a simple Counter with a label that can be set to the path that is used.

```r
c <- Counter$new(
  name = "api_visits_total",
  help = "Total API visits",
  labels = "endpoint"
)

c$inc(1, endpoint = "/")
c$inc(1, endpoint = "/count")
c$inc(1, endpoint = "/home")
c$inc(2, endpoint = "/home")

previewMetrics()
```

```
# HELP api_visits_total Total API visits
# TYPE api_visits_total counter
api_visits_total {endpoint="/"} 1 
api_visits_total {endpoint="/count"} 1 
api_visits_total {endpoint="/home"} 3
```

If you use `labels` you must specify __all of the labels__ every time you change the value of the metric (`inc`, `dec`, `set`, `observe`). Otherwise titan throws a warning and ignores the action. 
