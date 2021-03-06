% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/counter.R
\name{Counter}
\alias{Counter}
\title{Counter}
\description{
Create a new counter.
}
\section{Super class}{
\code{\link[titan:MetricInterface]{titan::MetricInterface}} -> \code{Counter}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{Counter$new()}}
\item \href{#method-set}{\code{Counter$set()}}
\item \href{#method-dec}{\code{Counter$dec()}}
\item \href{#method-clone}{\code{Counter$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="get">}\href{../../titan/html/MetricInterface.html#method-get}{\code{titan::MetricInterface$get()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="inc">}\href{../../titan/html/MetricInterface.html#method-inc}{\code{titan::MetricInterface$inc()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="titan" data-topic="MetricInterface" data-id="render">}\href{../../titan/html/MetricInterface.html#method-render}{\code{titan::MetricInterface$render()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Counter$new(name, help, labels = NULL, unit = NULL)}\if{html}{\out{</div>}}
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
\if{html}{\out{<a id="method-set"></a>}}
\if{latex}{\out{\hypertarget{method-set}{}}}
\subsection{Method \code{set()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Counter$set(val, ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{val}}{Value to set the metric.}

\item{\code{...}}{Key value pairs of labels.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
Set the metrics to a specific value
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-dec"></a>}}
\if{latex}{\out{\hypertarget{method-dec}{}}}
\subsection{Method \code{dec()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Counter$dec()}\if{html}{\out{</div>}}
}

\subsection{Details}{
Cannot decrease a counter.
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Counter$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
