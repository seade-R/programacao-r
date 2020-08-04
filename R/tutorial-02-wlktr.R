library(tidyverse)
covid <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/dados_covid_sp.csv') 
covid <- covid %>% 
  mutate(obitos_pc = obitos / pop)
covid %>% 
  filter(nome_munic == 'Sao Paulo',
         datahora == '2020-08-03') %>% 
  select(nome_munic, datahora, obitos, pop, obitos_pc)
covid <- covid %>% 
  mutate(obitos_pc = obitos_pc * 100000)
covid %>% 
  filter(nome_munic == 'Sao Paulo',
         datahora == '2020-08-03') %>% 
  select(nome_munic, datahora, obitos, pop, obitos_pc)
covid <- covid %>% 
  mutate(obitos_pc = (obitos / pop) * 100000,
         casos_pc = (casos / pop) * 100000,
         letalidade = obitos / casos)
covid %>%
  filter(nome_drs == "Grande Sao Paulo") 
covid %>%
  filter(nome_drs == "Grande Sao Paulo") %>% 
  pull(obitos_novos)
covid %>%
  filter(nome_drs == "Grande Sao Paulo") %>% 
  pull(obitos_novos) %>% 
  sum()
covid %>%
  filter(nome_drs == "Grande Sao Paulo") %>% 
  summarise(obitos_totais = sum(obitos_novos))
covid %>%
  filter(nome_drs == "Baixada Santista") %>% 
  summarise(obitos_totais = sum(obitos_novos))
covid %>%
  group_by(nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos))
covid %>%
  group_by(nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos),
            media_obitos = mean(obitos_novos),
            desvpad_obitos = sd(obitos_novos),
            maximo_obitos = max(obitos_novos),
            casos_totais = sum(casos_novos))
covid %>%
  group_by(datahora, nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos))
covid %>%
  group_by(datahora, nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos)) %>% 
  filter(datahora == '2020-08-01')
covid_drs <- covid %>%
  group_by(nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos),
            casos_totais = sum(casos_novos))
covid_drs %>% 
  arrange(obitos_totais)
covid_drs %>% 
  arrange(-obitos_totais)
covid_drs %>% 
  arrange(-obitos_totais, -casos_totais)
