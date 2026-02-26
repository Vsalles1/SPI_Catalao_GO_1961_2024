# 01_preparar_dados.R
# Lê precipitação diária, padroniza tipos e agrega para mensal.

# ---- Config ----
arquivo <- "dados/chuva_diaria_1961_2024.csv"  # ajuste se necessário
sep_csv <- ";"                                # seu arquivo estava com ';'
formato_data <- "%d/%m/%Y"                    # dd/mm/aaaa

stopifnot(file.exists(arquivo))

# ---- Leitura ----
dados <- read.csv(arquivo, sep = sep_csv, header = TRUE, stringsAsFactors = FALSE)

# Checagem de colunas
stopifnot(all(c("Data", "Precipitacao") %in% names(dados)))

# ---- Tipos ----
dados$Data <- as.Date(dados$Data, format = formato_data)

# Precipitação pode vir como texto com vírgula ou ponto:
# - troca vírgula por ponto
# - converte para numérico (NAs serão reportados)
dados$Precipitacao <- as.numeric(gsub(",", ".", dados$Precipitacao))

# Diagnóstico rápido
na_prec <- sum(is.na(dados$Precipitacao))
if (na_prec > 0) message("Atenção: existem ", na_prec, " valores NA em Precipitacao após conversão.")

# Remove linhas sem data
dados <- dados[!is.na(dados$Data), ]

# ---- Agregação mensal ----
dados_mensal <- dados |>
  dplyr::mutate(ano = lubridate::year(Data),
                mes = lubridate::month(Data)) |>
  dplyr::group_by(ano, mes) |>
  dplyr::summarise(prec_mensal = sum(Precipitacao, na.rm = TRUE),
                   n_dias = dplyr::n(),
                   .groups = "drop") |>
  dplyr::mutate(data_mes = as.Date(sprintf("%04d-%02d-01", ano, mes)))

# Ordena
dados_mensal <- dados_mensal |>
  dplyr::arrange(data_mes)

# Diagnóstico de completude (se quiser, ajuste o critério)
# Ex.: meses com poucos dias podem indicar faltas no diário
diag_mensal <- dados_mensal |>
  dplyr::mutate(flag_poucos_dias = n_dias < 25)

# ---- Salva objetos para os próximos scripts ----
saveRDS(dados, "saidas/tabelas/dados_diarios_padronizados.rds")
saveRDS(dados_mensal, "saidas/tabelas/dados_mensais_prec.rds")
write.csv(diag_mensal, "saidas/tabelas/diagnostico_mensal.csv", row.names = FALSE)

message("OK: dados preparados. Mensal salvo em saidas/tabelas/dados_mensais_prec.rds")
