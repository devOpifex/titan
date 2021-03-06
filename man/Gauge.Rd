% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gauge.R
\name{Gauge}
\alias{Gauge}
\title{Gauge}
\description{
Gauge

Gauge
}
\section{Super class}{
\code{\link[titan:MetricInterface]{titan::MetricInterface}} -> \code{Gauge}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{Gauge$new()}}
\item \href{#method-clone}{\code{Gauge$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="dec">}\href{../../titan/html/MetricInterface.html#method-dec}{\code{titan::MetricInterface$dec()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="get">}\href{../../titan/html/MetricInterface.html#method-get}{\code{titan::MetricInterface$get()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="inc">}\href{../../titan/html/MetricInterface.html#method-inc}{\code{titan::MetricInterface$inc()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="render">}\href{../../titan/html/MetricInterface.html#method-render}{\code{titan::MetricInterface$render()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="set">}\href{../../titan/html/MetricInterface.html#method-set}{\code{titan::MetricInterface$set()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Gauge$new(name, help, labels = NULL, unit = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{name}}{Name of the metric.}

\item{\code{help}}{Help text describing the metric.}

\item{\code{labels}}{Character vector of labels available.}

\item{\code{unit}}{Unit of metric.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
Initialise
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Gauge$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
