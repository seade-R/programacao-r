## Exercícios de Fixação -- Manipulação de Dados -- Sugestões de respostas

Vamos exercitar as nossas habilidade de manipulação de dados numéricos com dados da pandemia de covid-19 no estado de São Paulo. 

Primeiramente, vamos carregar os pacotes que precisaremos usar em nossas análises:

``` r
# Pacotes a serem utilizados
library(dplyr)
library(stringr)
library(readr)
library(lubridate)
```

Baixe o banco de [dados de casos e óbitos por município e data](https://repositorio.seade.gov.br/dataset/covid-19/resource/d2bad7a1-6c38-4dda-b409-656bff3fa56a) do Repositório do SEADE, descomprima o arquivo e mova o arquivo "dados_covid_sp.csv" para a sua pasta de trabalho. Carregue o arquivo:

``` r
dados_covid_sp <- read_csv2("dados_covid_sp.csv")
```

Caso tenha alguma dificuldade, volte aos tutoriais do curso para pensar em funções que possam te ajudar.


**1)** "Espie" dentro do objeto para verificar se ele foi aberto corretamente (em hipótese alguma clique no ícone de tabela no painel de ambiente ou use a função `View()`).

``` r
glimpse(dados_covid_sp)
head(dados_covid_sp)
```

**2)** Após criar a variável `ano`, utilizando o código abaixo, selecione somente as colunas referentes ao código do município, mês, ano, novos casos, novos óbitos e código da DRS.

``` r
dados_covid_sp <- dados_covid_sp %>% 
  mutate(ano = lubridate::year(datahora))
```

``` r
dados_covid_sp <- dados_covid_sp %>% 
  select(codigo_ibge, mes, ano, datahora, casos_novos, obitos_novos, cod_drs)
```

**4)** Calcule a soma total de casos e obitos por municipio do estado de SP ao longo de toda a pandemia, guardando esse resultado em um novo objeto, ordenando este banco do municipio com maior numero de obitos até o menor.

``` r
soma_casos_obitos <- dados_covid_sp %>% 
  group_by(codigo_ibge) %>% 
  summarise(total_casos = sum(casos_novos),
            total_obitos = sum(obitos_novos)) %>%  
  arrange(desc(total_obitos))
```

**5)** Importe a tabela de população por município do estado de São Paulo em 2021 do [repositório do curso](https://raw.githubusercontent.com/seade-R/programacao-r/master/data/populacao_2021_portepopulacional_esp.csv) por meio da função `read_csv2()` (atenção para o encoding). 

Precisaremos fazer uma pequena correção na variável `populacao_total`, para a qual apresento o código abaixo. Ao final, também transforme a coluna `codigo_ibge` para character.

``` r
populacao2021 <- read_csv2("https://raw.githubusercontent.com/seade-R/programacao-r/master/data/populacao_2021_portepopulacional_esp.csv", locale = locale(encoding = "latin1"))
```

``` r
populacao2021 <- populacao2021 %>%
  mutate(populacao_total = as.character(populacao_total),
         populacao_total = str_remove_all(populacao_total, "\\."),
         populacao_total = as.numeric(populacao_total))
```

``` r
populacao2021 <- populacao2021 %>%
  mutate(cod_ibge = as.character(cod_ibge))
```


**6)** Filtre somente as observacoes do banco `dados_covid_sp` para o ano de 2021, una esse banco (faça o `join`) com o banco de população municipal no ano de 2021, calcule o total de óbitos ocorridos nesse ano, e crie uma nova variável com o cálculo do percentual da população de cada município que faleceu em decorrência de covid-19 nesse ano. Por fim, recorte esse banco pelos 10 municípios com o maior percentual de óbitos em relação a população em 2021 (dê uma olhada no grupo de funções `slice_`.

``` r
obitos_mun <- dados_covid_sp %>% 
  filter(ano == 2021) %>%
  group_by(codigo_ibge) %>%
  summarise(obitos = sum(obitos_novos)) %>%
  ungroup() %>%
  mutate(codigo_ibge = as.character(codigo_ibge))

join_obitos <- left_join(obitos_mun, populacao2021, by = c("codigo_ibge" = "cod_ibge")) 

top10 <- join_obitos %>%
  mutate(percentual_obitos = (obitos/populacao_total)*100) %>%
  select(codigo_ibge, municipio, obitos, populacao_total, percentual_obitos) %>%
  slice_max(percentual_obitos, n = 10)
```

**7)** Carregue a [tabela](https://raw.githubusercontent.com/seade-R/programacao-r/master/data/nome_drs_2.csv) com os códigos dos Departamentos Regionais de Saúde (DRS) para a  para o seu ambiente no R. Em seguida, faça o *join* da tabela de casos e óbitos diarios com essa tabela com os nomes das DRS. Se receber alguma mensagem de erro, leia ela atentamente e pense em como corrigi-lo.

``` r
drs <- read.csv2("https://raw.githubusercontent.com/seade-R/programacao-r/master/data/nome_drs_2.csv") %>%
  mutate(cod_drs = as.character(cod_drs))

dados_covid_sp <- dados_covid_sp %>%
  mutate(cod_drs = as.character(cod_drs)) %>%
  left_join(drs, by = "cod_drs")

dados_covid_sp %>% glimpse()
```

**8)** Calcule a soma de total de casos e obitos por drs para o ano de 2020, preservando tanto a coluna de códigos da DRS quanto a de nome da DRS.

``` r
dados_covid_sp %>% 
  filter(ano == 2020) %>%
  group_by(nome_drs, cod_drs) %>%
  summarise(obitos = sum(obitos_novos),
            casos = sum(casos_novos))
```

