# Reprodutibilidade – Análise SPI (R)

Este repositório contém um fluxo reproduzível (scripts + comandos) para calcular e **plotar SPI-3, SPI-6 e SPI-12** a partir de uma série diária de precipitação.

> **Entrada esperada:** arquivo CSV com separador `;` e colunas:
> - `Data` no formato `dd/mm/aaaa` (ex.: `01/01/1961`)
> - `Precipitacao` (mm) – pode vir como texto (ex.: `"1.7"`)

## Estrutura sugerida
```
SPI_Catalao_GO_1961_2024/
  README.md
  scripts/
    00_setup.R
    01_preparar_dados.R
    02_calcular_spi.R
    03_plotar_spi.R
  dados/
    chuva_diaria_1961_2024.csv 
  saidas/
    figuras/
    tabelas/
```

## Como rodar (passo a passo)
1) Copie seu arquivo para `dados/chuva_diaria_1961_2024.csv` (ou ajuste o caminho nos scripts).  
2) No R/RStudio, abra um projeto apontando para a pasta SPI_Catalao_GO_1961_2024/.  
3) Execute na ordem:

```r
source("scripts/00_setup.R")
source("scripts/01_preparar_dados.R")
source("scripts/02_calcular_spi.R")
source("scripts/03_plotar_spi.R")
```

As figuras serão salvas em `saidas/figuras/` e as tabelas em `saidas/tabelas/`.

## Pacotes utilizados
- `tidyverse` (dplyr, readr, ggplot2 etc.)
- `lubridate`
- `SPEI` (função `spi()`)

## Observações importantes
- Se sua precipitação vier como **texto**, este fluxo converte para numérico.
- O SPI é calculado sobre **precipitação mensal** (agregada a partir do diário).
- Se houver meses sem dados, o gráfico pode apresentar “falhas” (NA). O script também exporta diagnóstico de completude por mês.

