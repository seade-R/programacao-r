library(tidyverse)
library(janitor)

obitos_2019 <- read_csv2('http://www.seade.gov.br/wp-content/uploads/2020/05/SEADE-Obitos_2019_MunicipioResidencia_IdadeSexo_Versao30_Abril_2020_v2.csv') %>%
  clean_names()%>%
  select(codigo_ibge, municipio_de_residencia, total_homens, total_mulheres)%>% 
  mutate(
    total_mulheres = replace(total_mulheres, total_mulheres == '-', '0'),
    total_mulheres = as.numeric(total_mulheres)
  ) %>%
  filter(codigo_ibge != 35)

populacao_imp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/imp_2020-08-23_17-03.csv', locale = locale(encoding = 'Latin1')) %>%
  clean_names() %>% 
  filter(periodos == 2019) %>% 
  select(cod_ibge, populacao_masculina, populacao_feminina)

df_inner <- inner_join(obitos_2019, populacao_imp, by = c('codigo_ibge' = 'cod_ibge')) %>% 
  mutate(
    mortalidade_homens = total_homens * 1000 / populacao_masculina,
    mortalidade_mulheres = total_mulheres * 1000 / populacao_feminina
  )
