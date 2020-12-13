# Titan

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/devOpifex/titan.svg?branch=master)](https://travis-ci.com/devOpifex/titan)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/devOpifex/titan?branch=master&svg=true)](https://ci.appveyor.com/project/devOpifex/titan)
[![Coveralls test coverage](https://coveralls.io/repos/github/devOpifex/titan/badge.svg)](https://coveralls.io/r/devOpifex/titan?branch=master)
<!-- badges: end -->

[Prometheus](prometheus.io/) monitoring for shiny applications, plumber APIs, and other R web services.

[Monitoring](/about/monitoring){: .md-button .md-button--primary }
[Get Started](/guide/installation){: .md-button }

## Acknowledgement 

I have put this package together in order to 1) grasp a better understanding of Prometheus metrics and 2) have some direct control over the source code of software I deploy for clients. I have written and re-written this three times before discovering [openmetrics](https://github.com/atheriel/openmetrics/), an R package that provides the same functionalities. I have taken much inspiration from it.

!!! info
    Prometheus is the _titan_ god of fire.

## Related work

There are other packages out there that will let you serve Prometheus metrics.

- [openmetrics](https://github.com/atheriel/openmetrics/) provides support for all metrics as well as authentication, and goes a step further in enforcing [OpenMetrics](https://openmetrics.io/) standards.
- [pRometheus](https://github.com/cfmack/pRometheus/) Provides support for Gauge and Counter.
