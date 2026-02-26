# 02_calcular_spi.R
# Calcula SPI-3, SPI-6 e SPI-12 com base na precipitação mensal.

mensal_path <- "saidas/tabelas/dados_mensais_prec.rds"
stopifnot(file.exists(mensal_path))

dados_mensal <- readRDS(mensal_path)

# Série temporal mensal (ts)
# Atenção: o SPI pressupõe periodicidade regular. Aqui assumimos mensal.
start_year <- lubridate::year(min(dados_mensal$data_mes, na.rm = TRUE))
start_month <- lubridate::month(min(dados_mensal$data_mes, na.rm = TRUE))

prec_ts <- ts(dados_mensal$prec_mensal,
              start = c(start_year, start_month),
              frequency = 12)

# ---- SPI ----
spi_3  <- SPEI::spi(prec_ts, scale = 3)
spi_6  <- SPEI::spi(prec_ts, scale = 6)
spi_12 <- SPEI::spi(prec_ts, scale = 12)

# Salva objetos
saveRDS(spi_3,  "saidas/tabelas/spi_3.rds")
saveRDS(spi_6,  "saidas/tabelas/spi_6.rds")
saveRDS(spi_12, "saidas/tabelas/spi_12.rds")

# Também salva as séries "fitted" em CSV
spi_df <- function(spi_obj, nome) {
  tibble::tibble(
    data = as.Date(zoo::as.yearmon(time(spi_obj$fitted))),
    spi  = as.numeric(spi_obj$fitted),
    escala = nome
  )
}

# zoo é dependência comum; se não vier instalado, instala aqui:
if (!"zoo" %in% rownames(installed.packages())) install.packages("zoo")
library(zoo)

out <- dplyr::bind_rows(
  spi_df(spi_3,  "SPI-3"),
  spi_df(spi_6,  "SPI-6"),
  spi_df(spi_12, "SPI-12")
)

write.csv(out, "saidas/tabelas/spi_series.csv", row.names = FALSE)

message("OK: SPI-3/6/12 calculados e salvos em saidas/tabelas/.")
