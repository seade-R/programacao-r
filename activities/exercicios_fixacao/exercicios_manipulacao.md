## Exercícios de Fixação -- Manipulação de Dados

Vamos exercitar as nossas habilidade de manipulação de dados numéricos com dados da pandemia de covid-19 no estado de São Paulo. 

Primeiramente, vamos carregar os pacotes que precisaremos usar em nossas análises:

``` r
# Pacotes a serem utilizados
library(dplyr)
library(stringr)
library(readr)
library(lubridate)
```

A partir do banco de dados carregado abaixo, faça as atividades a seguir.

``` r
dados_covid_sp <- read_csv2("https://raw.githubusercontent.com/seade-R/dados-covid-sp/master/data/dados_covid_sp.csv", col_types = "ccDnnnnnnnnccnn")
```

Caso tenha alguma dificuldade, volte aos tutoriais do curso para pensar em funções que possam te ajudar.


**1)** "Espie" dentro do objeto para verificar se ele foi aberto corretamente (em hipótese alguma clique no ícone de tabela no painel de ambiente ou use a função `View()`).

**2)** Selecione somente as colunas referentes ao código do município, mês, ano, novos casos, novos óbitos e código da DRS. A seguir, apresentamos um código para criação das variáveis mês e ano, que serão úteis em nossas análises.

``` r
dados_covid_sp <- dados_covid_sp %>% 
  mutate(ano = lubridate::year(datahora),
         mes = lubridate::month(datahora))
```
**4)** Calcule a soma total de casos e obitos por municipio do estado de SP ao longo de toda a pandemia, guardando esse resultado em um novo objeto, ordenando este banco do municipio com maior numero de obitos até o menor.

**5)** Importe a tabela de população por município do estado de São Paulo em 2021 do [repositório do curso](https://raw.githubusercontent.com/seade-R/programacao-r/master/data/populacao_2021_portepopulacional_esp.csv) por meio da função `read_csv2()` (atenção para o encoding). 

Precisaremos fazer uma pequena correção na variável `populacao_total`, para a qual apresento o código abaixo. Ao final, também transforme a coluna `codigo_ibge` para character.

``` r
populacao2021 <- populacao2021 %>%
  mutate(populacao_total = as.character(populacao_total),
         populacao_total = str_remove_all(populacao_total, "\\."),
         populacao_total = as.numeric(populacao_total))
```

**6)** Filtre somente as observacoes do banco `dados_covid_sp` para o ano de 2021, una esse banco (faça o `join`) com o banco de população municipal no ano de 2021, calcule o total de óbitos ocorridos nesse ano, e crie uma nova variável com o cálculo do percentual da população de cada município que faleceu em decorrência de covid-19 nesse ano. Por fim, recorte esse banco pelos 10 municípios com o maior percentual de óbitos em relação a população em 2021 (dê uma olhada no grupo de funções `slice_`.

**7)** Carregue a [tabela](https://raw.githubusercontent.com/seade-R/programacao-r/master/data/nome_drs_2.csv) com os códigos dos Departamentos Regionais de Saúde (DRS) para a  para o seu ambiente no R. Em seguida, faça o *join* da tabela de casos e óbitos diarios com essa tabela com os nomes das DRS. Se receber alguma mensagem de erro, leia ela atentamente e pense em como corrigi-lo.

**8)** Calcule a soma de total de casos e obitos por drs para o ano de 2020, preservando tanto a coluna de códigos da DRS quanto a de nome da DRS.
