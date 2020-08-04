library(tidyverse)

df <- read_csv2('https://raw.githubusercontent.com/seade-R/dados-covid-sp/master/data/dados_covid_sp.csv')

remove_acentos <- function(x) iconv(x, to = "ASCII//TRANSLIT")

df %>% 
  filter(codigo_ibge != 9999999) %>% 
  mutate(nome_munic = remove_acentos(nome_munic)) %>% 
  select(nome_munic, codigo_ibge, datahora, casos, casos_novos, obitos, obitos_novos, nome_drs, pop) %>% 
  write_csv2('data/dados_covid_sp.csv')

