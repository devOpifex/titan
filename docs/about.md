# About Titan & Monitoring

Titan is an R package to allow generating [Prometheus](https://prometheus.io/) metrics for R projects, including shiny, plumber, ambiorix, and more.

When products rely on plumber APIs and teams rely on shiny applications these better be up and running. These services may crash, become overloaded, their response latency might increase, they may run out of resources, and more. In addition these scale non-linearly as the number of such services or containers grow; hence monitoring their health and being alerted when they raise too many errors or crash becomes crucial. 

Prometheus is an open-source monitoring and alerting solution. There are other such monitoring tools out there such as [Sensu](https://sensu.io/), [Nagios](https://www.nagios.org/), or [InfluxDB](https://www.influxdata.com/) which also focus on time series data.

## Push vs. Pull

Prometheus differs from other services in many ways but the most important one probably is the fact that it reads the metrics from services from an endpoint provided by said service; it _pulls_ the data. 

Whereas many other solutions work the other way around; metrics are _pushed_ to the service for monitoring. The latter has the disadvantage that a tiny mistake can result in too much data being pushed to the monitoring service thereby essentially DDoSing yourself.

Another difference is that Prometheus is built with containers in mind (Docker & Kubernetes). Though fully open-sourced today, it was initially developed at [Soundcloud](https://soundcloud.com/) which is a big advocate of and pioneer in using micro-services at scale.

## Black box vs. White box

Up until recently most monitoring was probably "black box," applications were developed by some people and deployed by others. Devops had to set up monitoring of services with little knowledge of them.

Nowadays, with the advent of micro-services where developers are responsible for the deployment of the apps they build, the industry is increasingly turning towards "white box" monitoring.

> You build it you run it
> -- Jeff Bezos

As the developer of the service you know more about it than anyone and can therefore setup more appropriate monitoring; Prometheus and titan let you do just that.

This is particularly relevant to R programmers, most of which actually have to deploy the services they build.

It's not as daunting as it sounds, it's rather natural, and you quickly come to enjoy it, a bit like [testthat](https://testthat.r-lib.org/) in a sense.

## Scale

Monitoring is often mentioned along with large-scale micro-services where it is absolutely necessary. But this is not the only time when monitoring is useful.

Surely, as the developer of an application, you want to keep an eye on its performances. Perhaps you were given performance objectives, like reducing the load time of a shiny application or reducing the response time of a plumber API endpoint.

Even at a small scale monitoring is interesting and useful. Set up alerts when your services go down and fix them before your boss learns about it via a client.
