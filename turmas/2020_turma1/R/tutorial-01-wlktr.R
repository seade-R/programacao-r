library(tidyverse)
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv')
url_piesp <- "https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv"
piesp <- read_csv2(url_piesp)
View(piesp)
head(piesp)
nrow(piesp)
ncol(piesp)
names(piesp)
# Imprime o nome das variaveis do data frame da PIESP
names(piesp)

names(piesp) # Repetindo o comando acima com comentario em outro lugar
head(x = piesp, n = 20)
str(piesp)
glimpse(piesp)
names(piesp)
piesp <- rename(piesp, ano = Ano, valor = `Real (em milhoes)`, tipo = `Tipo Investimento`)
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv')

piesp <- piesp %>% 
  rename(ano = Ano,
         valor = `Real (em milhoes)`,
         tipo = `Tipo Investimento`)
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv')

piesp <- rename(piesp, ano = Ano, valor = `Real (em milhoes)`, tipo = `Tipo Investimento`)
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv')
piesp <- piesp %>% 
  rename(ano = Ano,
         empresa_alvo = `Empresa alvo do investimento`,
         empresa_investidora = `Empresa(s) investidora(s)`,
         valor = `Real (em milhoes)`,
         valor_dolar = `Dolar (em milhoes)`,
         munic = Municipio,
         tipo = `Tipo Investimento`)
piesp <- select(piesp, ano, valor, tipo)
piesp <- piesp %>%
  select(ano,
         valor,
         tipo)
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv') %>% 
  rename(ano = Ano,
         empresa_alvo = `Empresa alvo do investimento`,
         empresa_investidora = `Empresa(s) investidora(s)`,
         valor = `Real (em milhoes)`,
         valor_dolar = `Dolar (em milhoes)`,
         munic = Municipio,
         tipo = `Tipo Investimento`) %>%
  select(ano,
         valor,
         tipo)
piesp19 <- piesp %>% 
  filter(ano == 2019)
piesp1518 <- piesp %>% 
  filter(ano == 2017 | ano == 2017 | ano == 2018)
piesp1518 <- piesp %>% 
  filter(ano >= 2015 & ano <= 2018)
piesp1518_implantacao <- piesp %>% 
  filter(ano >= 2015 & ano <= 2018 & tipo == 'Implantacao')
piesp1518_implantacao <- piesp %>% 
  filter(ano >= 2015,
         ano <= 2018,
         tipo == 'Implantacao')
piesp <- piesp %>% 
  filter(!is.na(tipo))
