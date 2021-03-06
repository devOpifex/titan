% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metrics.R
\name{MetricInterface}
\alias{MetricInterface}
\title{Metrics Interface}
\description{
Exposed interface to the metrics.
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{MetricInterface$new()}}
\item \href{#method-set}{\code{MetricInterface$set()}}
\item \href{#method-get}{\code{MetricInterface$get()}}
\item \href{#method-inc}{\code{MetricInterface$inc()}}
\item \href{#method-dec}{\code{MetricInterface$dec()}}
\item \href{#method-render}{\code{MetricInterface$render()}}
\item \href{#method-clone}{\code{MetricInterface$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$new(
  name,
  help,
  labels = NULL,
  unit = NULL,
  type = c("gauge", "counter", "histogram", "summary"),
  renderMeta = TRUE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{name}}{Name of the metric.}

\item{\code{help}}{Help text describing the metric.}

\item{\code{labels}}{Character vector of labels available.}

\item{\code{unit}}{Unit of metric.}

\item{\code{type}}{Metric type.}

\item{\code{renderMeta}}{Whether to render the metadata.}
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
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$set(val, ...)}\if{html}{\out{</div>}}
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
Set the metric to a current value given labels.
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-get"></a>}}
\if{latex}{\out{\hypertarget{method-get}{}}}
\subsection{Method \code{get()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$get(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Key value pairs of labels.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
Retrieve the value of a metric given labels
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-inc"></a>}}
\if{latex}{\out{\hypertarget{method-inc}{}}}
\subsection{Method \code{inc()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$inc(val = 1, ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{val}}{Value to increase the metric.}

\item{\code{...}}{Key value pairs of labels.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
Increase the metric to a current value given labels.
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-dec"></a>}}
\if{latex}{\out{\hypertarget{method-dec}{}}}
\subsection{Method \code{dec()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$dec(val = 1, ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{val}}{Value to decrease the metric.}

\item{\code{...}}{Key value pairs of labels.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
Decrease the metric to a current value given labels.
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-render"></a>}}
\if{latex}{\out{\hypertarget{method-render}{}}}
\subsection{Method \code{render()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$render()}\if{html}{\out{</div>}}
}

\subsection{Details}{
Render the metric
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{MetricInterface$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
