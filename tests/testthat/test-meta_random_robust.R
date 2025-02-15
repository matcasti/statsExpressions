
test_that(
  desc = "meta_analysis works - robust",
  code = {
    options(tibble.width = Inf)
    skip_if(getRversion() < "4.0")
    skip_if_not_installed("metaplus")

    # renaming to what `{statsExpressions}` expects
    set.seed(123)
    data(mag, package = "metaplus")
    dat <-
      mag %>%
      rename(estimate = yi, std.error = sei) %>%
      sample_frac(0.4)

    # df
    set.seed(123)
    df <- meta_analysis(
      data = dat,
      type = "robust",
      random = "normal",
    )

    # testing all details
    set.seed(123)
    expect_snapshot(select(df, -expression))
    expect_snapshot(as.character(df$expression[[1]]))
  }
)
