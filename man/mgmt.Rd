% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/management.R
\name{mgmt}
\alias{mgmt}
\alias{PromReload}
\alias{PromHealthy}
\alias{PromReady}
\alias{PromQuit}
\title{Management}
\usage{
PromReload(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090"))

PromHealthy(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090"))

PromReady(uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090"))

PromQuit(
  uri = Sys.getenv("PROMETHEUS_URL", "http://localhost:9090"),
  prompt = TRUE
)
}
\arguments{
\item{uri}{URL to the prometheus service, including
the port if necessary. It defaults to the \code{PROMETHEUS_URL}
environment variable and if this is not set uses
\verb{http://localhost:9090}.}

\item{prompt}{Whether to prompt the user for an input,
used for the dangerous \code{PromQuit} which shuts down the
Prometheus server. Defaults to \code{TRUE}.}
}
\description{
Interact with the management API of Prometheus.
}
\note{
All management-related functions start with a capital
letter.
}
\section{Functions}{

\itemize{
\item \code{PromReload}: Tell Prometheus to reload the configuration file.
Note that this only works if Prometheus was launched
with the \code{--web.enable-lifecycle} flag.
\item \code{PromReady}: Check whether Prometeus is ready to serve traffic
(i.e. respond to queries). Returns \code{TRUE} if Prometheus is ready.
\item \code{PromHealthy}: Checks Prometheus' health.
Returns \code{TRUE} if Prometheus is healthy.
\item \code{PromQuit}: riggers a graceful shutdown of Prometheus.
It's disabled by default and can be enabled via the
\code{--web.enable-lifecycle} flag.
}
}

