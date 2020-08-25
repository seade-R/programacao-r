rm(list=ls())
library(tidyverse)
library(janitor)

obitos_2019 <- read_csv2('http://www.seade.gov.br/wp-content/uploads/2020/05/SEADE-Obitos_2019_MunicipioResidencia_IdadeSexo_Versao30_Abril_2020_v2.csv')

obitos_2019 <- obitos_2019 %>% 
  clean_names()

obitos_2019 %>% 
  glimpse()

obitos_2019 %>% 
  tabyl(ano) 

obitos_2019 <- obitos_2019 %>% 
  rename(munic = municipio_de_residencia) %>% 
  filter(munic != 'ESTADO DE SÃO PAULO')

obitos_2019 <- obitos_2019 %>%
  select(codigo_ibge, munic, total_homens, total_mulheres)

obitos_2019 %>% 
  glimpse()

obitos_2019 %>% 
  mutate(t2 = as.numeric(total_mulheres)) %>% 
  filter(is.na(t2))

obitos_2019 <- obitos_2019 %>% 
  mutate(
    total_mulheres = replace(total_mulheres, total_mulheres == '-', '0'),
    total_mulheres = as.numeric(total_mulheres)
  )

obitos_2019 %>% 
  glimpse()

populacao_imp <- read_csv2('data/imp_2020-08-23_17-03.csv', locale = locale(encoding = 'Latin1'))

populacao_imp <- populacao_imp %>% 
  clean_names()

populacao_imp %>% 
  glimpse()

populacao_imp <- populacao_imp %>% 
  filter(periodos == 2019) %>% 
  select(cod_ibge, populacao_masculina, populacao_feminina)

df <- inner_join(obitos_2019, populacao_imp, by = c('codigo_ibge' = 'cod_ibge'))

df %>% glimpse()

df <- df %>% 
  mutate(
    mortalidade_homens = total_homens / populacao_masculina,
    mortalidade_mulheres = total_mulheres / populacao_feminina
  )

df %>% 
  top_n(10, mortalidade_homens) %>% 
  select(munic, mortalidade_homens) %>% 
  arrange(-mortalidade_homens)
  
df %>% 
  top_n(10, mortalidade_mulheres) %>% 
  select(munic, mortalidade_mulheres) %>% 
  arrange(-mortalidade_mulheres)


pop20_url <- 'https://painel.seade.gov.br/wp-content/uploads/2020/08/populacao2020.zip'
download.file(pop20_url, 'pop20.zip')
unzip('pop20.zip')
list.files()
pop20 <- read_csv2('Populacao2020_Caracterizacao.csv', locale = locale(encoding = 'Latin1'))

pop20 %>% 
  glimpse()

pop20 <- pop20 %>% 
  clean_names() %>% 
  select(codigo_ibge, municipio, populacao)

covid_maio <- read_csv2('data/covid_sp_20200501.csv')

covid_maio <- covid_maio %>% 
  select(codigo_ibge, nome_munic, casos, obitos)

df_l <- left_join(covid_maio, pop20, by = 'codigo_ibge') 

df_l <- covid_maio %>% 
  left_join(pop20, by = 'codigo_ibge') 

df_r <- covid_maio %>% 
  right_join(pop20, by = 'codigo_ibge') 

df_f <- covid_maio %>% 
  full_join(pop20, by = 'codigo_ibge') 

df_f %>% 
  anti_join(df_r)
  
