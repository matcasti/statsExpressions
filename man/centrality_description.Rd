% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/centrality_description.R
\name{centrality_description}
\alias{centrality_description}
\title{Dataframe and expression for distribution properties}
\usage{
centrality_description(data, x, y, type = "parametric", tr = 0.2, k = 2L, ...)
}
\arguments{
\item{data}{A dataframe (or a tibble) from which variables specified are to
be taken. Other data types (e.g., matrix,table, array, etc.) will \strong{not}
be accepted.}

\item{x}{The grouping (or independent) variable from the dataframe data.}

\item{y}{The response (or outcome or dependent) variable from the
dataframe \code{data}.}

\item{type}{A character specifying the type of statistical approach:
\itemize{
\item \code{"parametric"}
\item \code{"nonparametric"}
\item \code{"robust"}
\item \code{"bayes"}
}

You can specify just the initial letter.}

\item{tr}{Trim level for the mean when carrying out \code{robust} tests. In case
of an error, try reducing the value of \code{tr}, which is by default set to
\code{0.2}. Lowering the value might help.}

\item{k}{Number of digits after decimal point (should be an integer)
(Default: \code{k = 2L}).}

\item{...}{Currently ignored.}
}
\description{
Dataframe and expression for distribution properties
}
\details{
This function describes a distribution for \code{y} variable for each level of the
grouping variable in \code{x} by a set of indices (e.g., measures of centrality,
dispersion, range, skewness, kurtosis). It additionally returns an expression
containing a specified centrality measure. The function internally relies on
\code{datawizard::describe_distribution} function.
}
\examples{
set.seed(123)

# parametric -----------------------
centrality_description(iris, Species, Sepal.Length)

# non-parametric -------------------
centrality_description(mtcars, am, wt, type = "n")

# robust ---------------------------
centrality_description(ToothGrowth, supp, len, type = "r")

# Bayesian -------------------------
centrality_description(sleep, group, extra, type = "b")
}
