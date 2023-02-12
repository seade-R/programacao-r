library(tidyverse)
library(zoo)

read_csv2('https://raw.githubusercontent.com/seade-R/dados-covid-sp/master/data/dados_covid_sp.csv') %>% 
  filter(pop >= 500000, nome_munic != 'São Paulo') %>%
  arrange(nome_munic, datahora) %>% 
  group_by(nome_munic) %>% 
  mutate(media_movel = rollapply(casos_novos, 7, mean, align = 'right', fill = NA)) %>% 
  select(nome_munic, datahora, media_movel) %>% 
  ggplot(aes(x = datahora, y = media_movel, color = nome_munic)) +
  geom_line() +
  facet_wrap(~nome_munic) +
  theme(legend.position = 'none') +
  labs( title = 'Média Móvel de Casos COVID-19', x = 'Data', y = '') 
