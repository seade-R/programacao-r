# http://www.seade.gov.br/produtos/midia/2020/02/DO2018.xlsx

library(tidyverse)
library(janitor)

output <- dataset %>% 
  clean_names() %>%
  mutate(sexo_f = recode_factor(sexo,
                                'F' = 'Feminino',
                                'M' = 'Masculino',                  
                                'I' = 'Ignorado'),
         racacor_f = recode_factor(racacor,
                                   '1' = 'Branca',
                                   '2' = 'Preta',                  
                                   '3' = 'Amarela',
                                   '4' = 'Parda',
                                   '5' = 'Indígena',
                                   '9' = 'Ignorada'),
         idade_faixa = cut(idadeanos, 
                           breaks = c(-Inf, 18, 75, Inf),
                           labels = c('0 a 17', '18 a 74', '75 ou mais'))
  )