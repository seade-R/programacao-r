## Exercícios -- Visualização de dados com `ggplot2` -- Sugestões de respostas

Em nossa atividade hoje, vamos produzir visualizações de dados numéricos com dados da pandemia de covid-19 no estado de São Paulo. 

Caso tenha alguma dificuldade, volte aos tutoriais do curso para pensar em funções que possam te ajudar.

Primeiramente, vamos carregar os pacotes que precisaremos usar em nossas análises:

``` r
# Pacotes a serem utilizados
library(dplyr)
library(stringr)
library(ggplot2)
library(forcats)
library(tidyr)
library(lubridate)
```

Baixe o banco de [dados de casos e óbitos por município e data](https://repositorio.seade.gov.br/dataset/covid-19/resource/d2bad7a1-6c38-4dda-b409-656bff3fa56a) do Repositório do SEADE, descomprima o arquivo e mova o arquivo "dados_covid_sp.csv" para a sua pasta de trabalho. Carregue o arquivo:

``` r
dados_covid_sp <- read_csv2("dados_covid_sp.csv")

dados_covid_sp <- dados_covid_sp %>% 
  mutate(ano = lubridate::year(datahora))
```

**2)** Filtre os dados para o ano de 2021 e exclua os municípios da DRS de Grande São Paulo do banco. Em seguida, some o numero de obitos ocorridos nesse ano por município. Por fim, faça um histograma da variável de total de óbitos, alterando o argumento `bins`.

``` r
ex2 <- dados_covid_sp %>% 
  filter(ano == 2021,
         nome_drs != "Grande São Paulo") %>%
  group_by(codigo_ibge) %>%
  summarise(total_obitos = sum(obitos_novos)) %>%
  ungroup()

ex2 %>%
  ggplot() +
  geom_histogram(aes(x = total_obitos), bins = 100)
```

**3)** Calcule a soma total de casos e óbitos por DRS do estado de SP ao longo de toda a pandemia. Com este resultado, crie um gráfico de barras do total de óbitos por DRS. 

O que você faria para melhorar a visualização desse gráfico? Experimente os seguintes pontos: (1) Ordene o eixo-x em ordem crescente do número de óbitos (caminho sugerido: transformar a variável em `factor`, e ordernar os `levels` na ordem desejada, manualmente ou utilizando a função `fct_reorder()`); (2) inverta os eixos-x e y, colocando a variável numérica no eixo-y.

Explore o banco de dados e reflita sobre o que significa o `NA` no resultado. Como você lidaria com ele numa visualização para um relatório?

``` r
soma_casos_obitos <- dados_covid_sp %>% 
  group_by(nome_drs) %>%
  summarise(total_casos = sum(casos_novos),
            total_obitos = sum(obitos_novos)) %>%
  # Ressaltar a importancia do ungroup()
  ungroup() %>%
  arrange(desc(total_obitos))

soma_casos_obitos %>% 
  mutate(nome_drs = fct_reorder(nome_drs, total_obitos)) %>%
  ggplot() +
  geom_col(aes(x = total_obitos, y = nome_drs))
  
# O NA advem de obitos que nao tem um municipio associado
# Como sao poucos casos, o ideal seria retira-los da visualizacao
# Alem disso, podemos/devemos colocar uma nota informando que eles
# foram retirados e qual o n deles.
```

**4)** Calcule o total de casos por DRS e ano (considerando somente os anos de 2020, 2021 e 2022) e o percentual que RA corresponde nesses anos. Em seguida, faça um gráfico de barras no qual o eixo-x é o ano e o eixo-y apresenta o percentual de cada DRS. Mude os nomes dos eixo-x e eixo-y e retire a legenda do gráfico. Além disso, como você melhoraria o eixo-x deste gráfico?

``` r
dados_covid_sp %>%
  filter(ano != 2023) %>%
  group_by(nome_drs, ano) %>%
  summarise(total_casos = sum(casos_novos)) %>%
  ungroup() %>%
  group_by(ano) %>%
  mutate(percentual = (total_casos/sum(total_casos))*100) %>%
  ggplot() +
  geom_col(aes(x = ano, y = percentual, fill = nome_drs)) +
  theme(legend.position="bottom") +
  coord_flip()
  
# Podemos colocar mais "breaks" no nosso eixo-x para
# facilitar a leitura de quanto cada fatia correspondente.
# Tambem podemos explorar outras paletas de cores para melhorar
# a visualizacao de forma geral.
```

**5)** Faça um gráfico de linhas com o total de novos óbitos por dia na cidade de São Paulo, alterando outros elementos do gráfico como nome dos eixos e título. Caso esteja insatisfeito com o gráfico, tente criar uma variável de média móvel de óbitos (dica: veja a função `rollapply()` do pacote `zoo`) e refaça seu gráfico.

``` r
dados_covid_sp %>% 
  filter(codigo_ibge == 3550308) %>%
  ggplot() +
  geom_line(aes(x = datahora, obitos_novos))

library(zoo)

dados_covid_sp %>% 
  filter(codigo_ibge == 3550308) %>%
  mutate(obitos_mm = rollapply(obitos_novos, 7, mean, fill = NA)) %>%
  ggplot() +
  geom_line(aes(x = datahora, obitos_mm))
```

**6)** Com o código abaixo, vamos criar um novo objeto com as seguintes informações: óbitos nos anos de 2021 e 2022 por cada dia-mês do ano no estado de SP.

``` r
sp_mes <- dados_covid_sp %>%
  filter(ano != 2020 & ano != 2023) %>%
  mutate(mesdia = str_c(mes, dia)) %>% 
  group_by(ano, mesdia) %>%
  summarise(obitos = sum(obitos_novos)) %>%
  ungroup() %>%
  pivot_wider(id_cols = mesdia, names_from = ano, values_from = obitos) %>%
  rename(obitos2021 = `2021`,
         obitos2022 = `2022`)
```

Agora, crie um diagrama de dispersão que contenha essas duas variáveis. Por fim, tente plotar uma linha de regressão para a relação entre essas duas variáveis. Você nota alguma relação entre essas variáveis?

``` r
sp_mes %>% 
  ggplot(aes(x = obitos2021, y = obitos2022)) +
  geom_point() +
  geom_smooth(method = "lm")
```

**7)** Vamos fazer algo semelhante ao do exercício 3, mas dividindo os resultados por ano. Assim, calcule a soma total de casos e óbitos por DRS do estado de SP por ano da pandemia. Com este resultado, crie um gráfico de barras do total de óbitos por DRS, divindo os resultados por ano (dica: use a função `facet_wrap()`). Não se esqueça de removar os casos em que `nome_drs == "NA"`.

``` r
soma_casos_obitos <- dados_covid_sp %>% 
  group_by(nome_drs, ano) %>%
  summarise(total_casos = sum(casos_novos),
            total_obitos = sum(obitos_novos)) %>%
  ungroup() %>%
  arrange(desc(total_obitos))

soma_casos_obitos %>% 
  mutate(nome_drs = fct_reorder2(nome_drs, total_obitos, ano)) %>%
  ggplot() +
  geom_col(aes(x = nome_drs, y = total_obitos)) +
  coord_flip() +
  facet_wrap(~ ano, nrow = 3, scales = "free")
```
