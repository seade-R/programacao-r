library(tidyverse)
library(readxl)

download.file('http://www.seade.gov.br/produtos/midia/2020/08/06-2020_Tabelas_SITE-1.xlsx', 'pib_mensal.xlsx')

read_excel('pib_mensal.xlsx', range = 'A8:G230') %>% 
  rename(
    mes = `...1`,
    ano = `...2`,
    total =`...6`
    ) %>%
  filter(mes == 'Setembro') %>% 
  ggplot(aes(x = ano, y = total)) +
  geom_point() +
  geom_line(group = 1)
