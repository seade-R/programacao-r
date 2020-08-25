library(tidyverse)
library(readxl)
library(janitor)

obitos_2018_url <- 'http://www.seade.gov.br/produtos/midia/2020/02/DO2018.xlsx'
download.file(obitos_2018_url, 'obitos_2018.xlsx')
obitos_2018 <- read_excel('obitos_2018.xlsx')

obitos_2018 %>% 
  glimpse()

obitos_2018 <- obitos_2018 %>% 
  clean_names() 

obitos_2018 %>% 
  glimpse()

obitos_2018 %>% 
  group_by(sexo) %>% 
  count

obitos_2018 %>% 
  tabyl(sexo)

obitos_2018 <- obitos_2018 %>% 
  mutate(sexo = recode(sexo,
                          'F' = 'Feminino',
                          'M' = 'Masculino',                  
                          'I' = 'Ignorado'))

obitos_2018 <- obitos_2018 %>% 
  mutate(sexo_f = factor(sexo, 
                         levels = c('Feminino', 'Masculino', 'Ignorado')))

obitos_2018 %>% 
  tabyl(sexo_f)

obitos_2018 %>% 
  tabyl(racacor) 

obitos_2018 <- obitos_2018 %>% 
  mutate(racacor_f = recode_factor(racacor,
                     '1' = 'Branca',
                     '2' = 'Preta',                  
                     '3' = 'Amarela',
                     '4' = 'Parda',
                     '5' = 'Indígena',
                     '9' = 'Ignorada'))

obitos_2018 %>% 
  tabyl(racacor_f) 

tabela_racacor <- obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)

tabela_racacor %>% 
  write_csv2('tabela_racacor.csv')

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) 


obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages()


obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages() %>% 
  adorn_pct_formatting()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = c('col', 'row'))

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages() %>% 
  adorn_rounding(digits = 2)

obitos_2018 %>% 
  glimpse


obitos_2018 %>% 
  mutate(idade = as.numeric(idadeemanos)) %>% 
  filter(!is.na(idadeemanos)) %>% 
  summarise(mean(idadeemanos))

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(c('col', 'row')) %>% 
  adorn_percentages('all') %>% 
  adorn_pct_formatting()  


obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages() %>% 
  adorn_pct_formatting()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'col') %>% 
  adorn_pct_formatting()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_pct_formatting()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals()

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = 'col')

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = c('col', 'row'))

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages() %>% 
  adorn_totals(where = c('col', 'row'))

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_pct_formatting() %>% 
  adorn_title(placement = 'top',
              row_name = 'Raça/cor', 
              col_name =  'Sexo')

obitos_2018 %>% 
  tabyl(racacor, sexo) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_pct_formatting() %>% 
  adorn_title(placement = 'top',
              row_name = 'Raça/cor', 
              col_name =  'Sexo') %>% 
  write_csv2('obitos_racacor_sexo.csv')


obitos_2018 <- obitos_2018 %>% 
  mutate(estciv_f = recode_factor(estciv,
                                   '1' = 'solteiro',                  
                                   '2' = 'casado',                  
                                   '3' = 'viúvo',                     
                                   '4' = 'separação Judicial',
                                   '5' = 'união consensual',
                                   '9' = 'ignorado'
  ))

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f, estciv_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_pct_formatting() %>% 
  adorn_title(placement = 'top',
              row_name = 'Raça/cor', 
              col_name =  'Sexo') 

obitos_2018 %>% 
  tabyl(racacor_f, sexo_f, estciv_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_pct_formatting() %>% 
  adorn_title(placement = 'top',
              row_name = 'Raça/cor', 
              col_name =  'Sexo') -> lista_tabelas

lista_tabelas %>% 
  names(.) %>%
  walk(~ write_csv(lista_tabelas[[.]], paste0('tabela_obitos_', ., ".csv")))

