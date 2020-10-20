library(tidyverse)
library(readxl)
library(janitor)

obitos_2018_url <- 'http://www.seade.gov.br/produtos/midia/2020/02/DO2018.xlsx'
download.file(obitos_2018_url, 'obitos_2018.xlsx')
obitos_2018 <- read_excel('obitos_2018.xlsx')

obitos_2018 %>% 
  glimpse()

obitos_2018 %>% 
  ggplot() + 
  geom_bar(aes(x = idadeanos))



obitos_2018 %>% 
  ggplot() +
  geom_bar(aes(racacor_f))

obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos))

obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos), binwidth = 5)

obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos), 
                 binwidth = 5,
                 color = 'orange',
                 fill = 'green')

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos))

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'darkblue')

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'darkblue',
               fill = 'darkblue')

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) 
geom_vline(aes(xintercept = 75))

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) +
  geom_vline(aes(xintercept = 82))


obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) +
  geom_vline(aes(xintercept = 82),
             linetype="dashed",
             color="red")

obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos,
                     fill = sexo),
                 binwidth = 5)

obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos,
                     fill = sexo),
                 binwidth = 5,
                 position = "dodge")

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo)) 

obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo)) 

obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo,
                   fill = sexo)) 

obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo,
                   fill = sexo),
               alpha = 0.5) 

obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos, 
                   fill = racacor_f, 
                   color = racacor_f), 
               alpha = 0.5)

obitos_2018 %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f))

obitos_2018 %>% 
  ggplot() + 
  geom_violin(aes(x = racacor_f, 
                  y = idadeanos,
                  fill = racacor_f))

obitos_2018 %>% 
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f))

obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>%
  filter(racacor_f != 'Ignorada') %>%
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f)) +
  facet_wrap(.~sexo_f)

obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  filter(racacor_f != 'Ignorada') %>% 
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f)) +
  facet_wrap(.~sexo_f) +
  labs(
    title = 'Distribuição de óbitos por idade, sexo e raça/cor',
    subtitle = 'Registro Civil 2018',
    caption = 'Fonte: SEADE',
    y = 'Idade (anos)',
    x = '') +
  theme(legend.position = 'none')

obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  filter(racacor_f != 'Ignorada') %>% 
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = sexo_f, 
                   y = idadeanos,
                   fill = sexo_f)) +
  facet_wrap(.~racacor_f) +
  labs(
    title = 'Distribuição de óbitos por idade, sexo e raça/cor',
    subtitle = 'Registro Civil 2018',
    caption = 'Fonte: SEADE',
    y = 'Idade (anos)',
    x = '') +
  theme(legend.position = 'none')

nv_2017_url <- 'http://www.seade.gov.br/produtos/midia/2020/02/DN2017.xlsx'
download.file(nv_2017_url, 'nv_2017.xlsx')
nv_2017 <- read_excel('nv_2017.xlsx')

