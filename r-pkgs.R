# R packages install script
#
# Install pak as preferred way to then install and manage packages
install.packages("pak", repos = "https://r-lib.github.io/p/pak/dev/")

# CRAN packages
cran_pkgs <- c(
  "tidyverse",
  "afex",
  "bayestestR",
  "blogdown",
  "bookdown",
  "BUCSS",
  "Cairo",
  "compute.es",
  "correlation",
  "cowplot",
  "datapasta",
  "datarium",
  "datawizard",
  "devtools",
  "DiagrammeR",
  "DT",
  "easypower",
  "effectsize",
  "effsize",
  "emmeans",
  "emojifont",
  "faux",
  "fontawesome",
  "ggfortify",
  "ggh4x",
  "ggpubr",
  "ggstatsplot",
  "ggtext",
  "ggthemes",
  "gtsummary",
  "here",
  "hrbrthemes",
  "huxtable",
  "insight",
  "janitor",
  "jmv",
  "kableExtra",
  "knitr",
  "languageserver",
  "leaflet",
  "learnr",
  "linl",
  "lme4",
  "lmerTest",
  "MBESS",
  "meta",
  "metafor",
  "miniUI",
  "modelbased",
  "moments",
  "MOTE",
  "nlme",
  "qqplotr",
  "pagedown",
  "palmerpenguins",
  "parallelly",
  "parameters",
  "PASWR2",
  "patchwork",
  "performance",
  "posterdown",
  "prereg",
  "psych",
  "pwr",
  "RefManageR",
  "remotes",
  "renv",
  "report",
  "rmarkdown",
  "robust",
  "Routliers",
  "rpact",
  "see",
  "simstudy",
  "statcheck",
  "styler",
  "Superpower",
  "tidymodels",
  "tint",
  "usethis",
  "ufs",
  "vitae",
  "waffle",
  "WebPower",
  "weightr",
  "workflowr",
  "WRS2",
  "xaringan",
  "xaringanthemer",
  "zcurve"
)
pak::pkg_install(cran_pkgs)

# Github (i.e., non-CRAN repo) packages
gh_pkgs <- c(
  "ciannabp/inauguration",
  "crsh/citr",
  "crsh/papaja@devel",
  "gadenbuie/xaringanExtra",
  "gadenbuie/rsthemes",
  "GRousselet/rogme",
  "Lakens/TOSTER",
  "MathiasHarrer/dmetar",
  "paleolimbot/rbbt",
  "profandyfield/discovr",
  "ropenscilabs/icon",
  "statisfactions/simpr"
)
pak::pkg_install(gh_pkgs)

# Check for and update CRAN packages
library(tidyverse)
update_pkgs <- old.packages() %>%
  tibble::as_tibble() %>%
  dplyr::filter(Repository == "https://cloud.r-project.org/src/contrib") %>%
  dplyr::pull(Package)
pak::pkg_install(update_pkgs, upgrade = TRUE)
