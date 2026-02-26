# 03_plotar_spi.R
# Plota SPI e salva PNG (alta resolução).

dir.create("saidas/figuras", showWarnings = FALSE, recursive = TRUE)

plot_spi_png <- function(spi_rds, titulo, arquivo_png,
                         w = 3200, h = 1800, res = 300) {
  stopifnot(file.exists(spi_rds))
  spi_obj <- readRDS(spi_rds)

  # Verifica se há infinitos (você checou isso antes no console)
  if (any(is.infinite(spi_obj$fitted), na.rm = TRUE)) {
    warning("Foram encontrados valores infinitos no SPI. Verifique dados/ajuste.")
  }

  png(arquivo_png, width = w, height = h, res = res)
  par(mar = c(5, 5, 4, 2) + 0.1)

  plot(spi_obj$fitted,
       type = "l",
       lwd = 1.2,
       main = titulo,
       xlab = "Ano",
       ylab = "SPI")

  abline(h = 0, lwd = 1)
  abline(h = c(-1, -1.5, -2, 1, 1.5, 2), lty = 2)

  legend("topright",
         legend = c("0 (normal)", "±1, ±1.5, ±2 (limiares)"),
         bty = "n")

  dev.off()
}

# ---- Chamadas ----
plot_spi_png("saidas/tabelas/spi_3.rds",
             "SPI-3 – Catalão (GO) (1961–2024)",
             "saidas/figuras/FIG_SPI3_Catalao_GO_1961_2024.png")

plot_spi_png("saidas/tabelas/spi_6.rds",
             "SPI-6 – Catalão (GO) (1961–2024)",
             "saidas/figuras/FIG_SPI6_Catalao_GO_1961_2024.png")

plot_spi_png("saidas/tabelas/spi_12.rds",
             "SPI-12 – Catalão (GO) (1961–2024)",
             "saidas/figuras/FIG_SPI12_Catalao_GO_1961_2024.png")

message("OK: Figuras salvas em saidas/figuras/.")
