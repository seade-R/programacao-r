## Exercícios - Visualização de dados com `ggplot2`

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

**3)** Calcule a soma total de casos e óbitos por DRS do estado de SP ao longo de toda a pandemia. Com este resultado, crie um gráfico de barras do total de óbitos por DRS. 

O que você faria para melhorar a visualização desse gráfico? Experimente os seguintes pontos: (1) Ordene o eixo-x em ordem crescente do número de óbitos (caminho sugerido: transformar a variável em `factor`, e ordernar os `levels` na ordem desejada, manualmente ou utilizando a função `fct_reorder()`); (2) inverta os eixos-x e y, colocando a variável numérica no eixo-y.

Explore o banco de dados e reflita sobre o que significa o `NA` no resultado. Como você lidaria com ele numa visualização para um relatório?

**4)** Calcule o total de casos por DRS e ano (considerando somente os anos de 2020, 2021 e 2022) e o percentual que RA corresponde nesses anos. Em seguida, faça um gráfico de barras no qual o eixo-x é o ano e o eixo-y apresenta o percentual de cada DRS. Mude os nomes dos eixo-x e eixo-y e retire a legenda do gráfico. Além disso, como você melhoraria o eixo-x deste gráfico?

**5)** Faça um gráfico de linhas com o total de novos óbitos por dia na cidade de São Paulo, alterando outros elementos do gráfico como nome dos eixos e título. Caso esteja insatisfeito com o gráfico, tente criar uma variável de média móvel de óbitos (dica: veja a função `rollapply()` do pacote `zoo`) e refaça seu gráfico.

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

**7)** Vamos fazer algo semelhante ao do exercício 3, mas dividindo os resultados por ano. Assim, calcule a soma total de casos e óbitos por DRS do estado de SP por ano da pandemia. Com este resultado, crie um gráfico de barras do total de óbitos por DRS, divindo os resultados por ano (dica: use a função `facet_wrap()`). Não se esqueça de removar os casos em que `nome_drs == "NA"`.
