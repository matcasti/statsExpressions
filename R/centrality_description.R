#' @title Dataframe and expression for distribution properties
#' @name centrality_description
#'
#' @details
#'
#' This function describes a distribution for `y` variable for each level of the
#' grouping variable in `x` by a set of indices (e.g., measures of centrality,
#' dispersion, range, skewness, kurtosis). It additionally returns an expression
#' containing a specified centrality measure. The function internally relies on
#' `datawizard::describe_distribution` function.
#'
#' @param x The grouping (or independent) variable from the dataframe data.
#' @inheritParams oneway_anova
#' @param ... Currently ignored.
#'
#' @examples
#' set.seed(123)
#'
#' # parametric -----------------------
#' centrality_description(iris, Species, Sepal.Length)
#'
#' # non-parametric -------------------
#' centrality_description(mtcars, am, wt, type = "n")
#'
#' # robust ---------------------------
#' centrality_description(ToothGrowth, supp, len, type = "r")
#'
#' # Bayesian -------------------------
#' centrality_description(sleep, group, extra, type = "b")
#' @export

centrality_description <- function(data,
                                   x,
                                   y,
                                   type = "parametric",
                                   tr = 0.2,
                                   k = 2L,
                                   ...) {

  # measure -------------------------------------

  # standardize
  type <- stats_type_switch(type)

  # styler: off
  # which centrality measure?
  centrality <- case_when(
    type == "parametric"    ~ "mean",
    type == "nonparametric" ~ "median",
    type == "robust"        ~ "trimmed",
    type == "bayes"         ~ "MAP"
  )
  # styler: on

  # dataframe -------------------------------------

  # creating the dataframe
  select(data, {{ x }}, {{ y }}) %>%
    tidyr::drop_na(.) %>%
    mutate({{ x }} := droplevels(as.factor({{ x }}))) %>%
    group_by({{ x }}) %>%
    group_modify(
      .f = ~ standardize_names(
        data = datawizard::describe_distribution(
          x          = .,
          centrality = centrality,
          threshold  = tr,
          verbose    = FALSE,
          ci         = 0.95 # TODO: https://github.com/easystats/bayestestR/issues/429
        ),
        style = "broom"
      )
    ) %>%
    ungroup() %>%
    mutate(
      expression = glue("widehat(mu)[{centrality}]=='{format_value(estimate, k)}'"),
      n_label = paste0({{ x }}, "\n(n = ", .prettyNum(n), ")")
    ) %>%
    arrange({{ x }}) %>%
    select({{ x }}, !!as.character(ensym(y)) := estimate, n_obs = n, everything())
}
