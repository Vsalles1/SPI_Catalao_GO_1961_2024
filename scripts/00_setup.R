# 00_setup.R
# Instala (se necessário) e carrega pacotes usados no fluxo.

pkgs <- c("tidyverse", "lubridate", "SPEI")

to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install) > 0) install.packages(to_install)

invisible(lapply(pkgs, library, character.only = TRUE))

# Pastas padrão
dir.create("dados", showWarnings = FALSE)
dir.create("saidas", showWarnings = FALSE)
dir.create("saidas/figuras", showWarnings = FALSE, recursive = TRUE)
dir.create("saidas/tabelas", showWarnings = FALSE, recursive = TRUE)
