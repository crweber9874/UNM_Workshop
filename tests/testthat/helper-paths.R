# test_dir() may be run from the repo root or from tests/testthat/.
repo_path <- function(...) {
  for (up in c(".", "../..")) {
    p <- file.path(up, ...)
    if (file.exists(p)) return(p)
  }
  file.path(".", ...)
}
