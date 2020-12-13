---
title: Internals of titan
summary: Some description of the internals of the package.
authors:
    - John Coene
---

# Internals

This gives some details on the internals of titan that may be of use when using the package.

## Principle

Titan aims not to make your service go down, that would be too ironic. Therefore titan makes very little use of `stop` and instead uses `warning` starting in `[IGNORING]` and skips the action.

E.g.: One cannot decrease the value of Counters, if you try to do so Titan will return a warning and ignore the action but will not `stop`.

## Storage

When titan is loaded in your environment with `library(titan)` it creates an environment in which it stores all metrics.

This is useful when, for instance, you setup a shiny application with titan, run it locally with `titanApp`, test it, then stop the app to make changes; when you run it again the metrics from the previous run will remain.

!!! info
    You can run `cleanRegistry` to clean the environment.

## Serving

As mentioned Prometheus pulls the metrics from your service, therefore those metrics have to be made available. These are exposed in the form of a plain text (`text/plain`) endpoint called `/metrics` where titan will serve the metrics that Prometheus can then read, store, and analyse.

With shiny you can use the function `titanApp` where you would normally use `shinyApp`, with plumber, Ambiorix, and other services you can use `renderMetrics`. 

There is more detail and many examples on how to use this on this site.
