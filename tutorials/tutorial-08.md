# Bases relacionais com a gramática do dplyr

Nos tutoriais anteriores trabalhamos quase que exclusivamente com um único data frame, produzindo transformações de colunas, mudando os nomes das variáveis, selecionando de linhas e colunas e agrupando para produzir tabelas e estatísticas descritivas. Neste tutorial vamos aprender a trabalhar com bases relacionais, ou seja, a combinar data frames usando as funções de sufixo 'join' do dplyr.

Combinar data frames é necessário quando as informações que serão utilizadas na análise estão presentes em mais de um fonte de dados. Vamos trabalhar neste tutorial com 4 fontes de dados para exemplificar os diferentes tipos de combinação ('joins'): (1) uma base óbitos por município em 2019, produzida pelo SEADE; (2) a base de Informações dos Municípios Paulistas (IMP), da qual retiraremos a população dos municípios em 2019; (3) os dados de população dos municípios paulistas em 2020 do SEADE; e (4) os dados de casos e óbitos por COVID-19 nos municípios paulistas (fixados em 01 de maio de 2020 por razões didáticas).

Note que as 4 fontes tem o mesmo 'identificador', ou seja, todas elas contém uma informação que permite relacioná-la com as demais. No nosso caso, o indexador é o código do município fornecido pelo IBGE.

Antes de avançar, carregue os pacotes que utilizaremos nesta atividade:

```{r}
library(tidyverse)
library(janitor)
```

## Mortalidade de homens e mulheres por município

Nosso primeiro objetivo será calcular a mortalidade (óbitos por 1000 habitantes) por município para homens e mulheres, separadamente, para o ano de 2019. Precisamos, pois, de duas informações para cada município: o total de óbitos para cada grupo de sexo por município; e a população do município.

A primeira informação, óbitos para cada grupo de sexo por município, podem ser encontradas aqui: https://www.seade.gov.br/produtos/dados-de-obitos/. Vamos abrir os dados, disponibilizados em .csv, diretamente:

```{r}
obitos_2019 <- read_csv2('http://www.seade.gov.br/wp-content/uploads/2020/05/SEADE-Obitos_2019_MunicipioResidencia_IdadeSexo_Versao30_Abril_2020_v2.csv')
```

e examiná-los com _glimpse_:

```{r}
obitos_2019 %>% 
  glimpse()
```

Aaaaaaaaaaaaaaarrrgh! Como trabalhar com nomes de variáveis com espaço, acento e começando com números? A resposta é simples: _clean\_names_ do pacote _janitor_.

```{r}
obitos_2019 <- obitos_2019 %>% 
  clean_names()
```

Fantático, não?

```{r}
obitos_2019 %>% 
  glimpse()
```

Não precisamos de todas as variáveis existente nesse conjunto de dados. Com _select_, vamos manter apenas aquelas que nos interessam: o código e o nome dos municípios e o total de óbitos de homens e mulheres.

```{r}
obitos_2019 <- obitos_2019 %>%
  select(codigo_ibge, municipio_de_residencia, total_homens, total_mulheres)
```

Reexamine os dados:

```{r}
obitos_2019 %>% 
  glimpse()
```

Veja que a variável do total de óbitos de mulheres está como texto ('chr') e não como numérica ('dbl'). Há várias maneiras de inspecionar isso, mas vamos pular. O problema ocorre por que temos o símbolo '-' em vez de 0 para um município no qual não houve óbito de mulher.

Para corrigir o problema, vamos substituir '-' por 0 com _replace_ e, a seguir, vamos converter a variável de texto para numérica coma a função _as.numeric_. Veja que se tivéssemos aplicado _as.numeric_ sem fazermos a substituição, '-' seria convertido em NA.

```{r}
obitos_2019 <- obitos_2019 %>% 
  mutate(
    total_mulheres = replace(total_mulheres, total_mulheres == '-', '0'),
    total_mulheres = as.numeric(total_mulheres)
  )
```

Ótimo! Vamos agora abrir nossa segunda fonte de dados, o IMP. Para os dados do IMP, precisamos consultar o site do http://www.imp.seade.gov.br/frontend/#/tabelas e fazer download manualmente ou utilizar a API (que é perfeitamente possível em R).

Para não precisamos fazer nenhum dos dois, vamos utilizar uma cópia dos dados armazenada no repositório do curso:

```{r}
populacao_imp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/imp_2020-08-23_17-03.csv', locale = locale(encoding = 'Latin1'))
```

Veja que utilizamos o argumento 'locale'. Os dados do IMP obtidos via download manual vêm com o encoding 'Latin1' e como trabalhando no servidor RStudio do servidor Linux do SEADE, precisamo informar esse parâmetro para que o dado seja lido corretamente.

Examine os dados:

```{r}
populacao_imp %>% 
  glimpse()
```

Nomes fora de padrão? _clean\_names_

```{r}
populacao_imp <- populacao_imp %>% 
  clean_names()
```

Reexaminando:

```{r}
populacao_imp %>% 
  glimpse()
```

Note que há informações sobre vários anos. Podemos produzir rapidamente uma tabela de anos com _tabyl_

```{r}
populacao_imp %>% 
  tabyl(periodos)
```

Temos informação dos 645 municípios em todos os períodos. Mas nos interessa apenas 2019. Fazemos, então, uma seleção de linhas com _filter_ e, a seguir, utilizamos _select_ para manter apenas as variáveis que utilizaremos na análise: código do município e as populações masculina e feminina. Podemos descartar o nome do município, posto que esta variável já existe na base de óbitos com a qual combinaremos as informações de população municipal.

```{r}
populacao_imp <- populacao_imp %>% 
  filter(periodos == 2019) %>% 
  select(cod_ibge, populacao_masculina, populacao_feminina)
```

## Inner Join

Pronto! Temo agora dois data frames preparados com as informações de duas fontes de dados diferentes e com um identificador em comum, o nome do muncípio.

Há 6 tipos de 'joins' em R: 'inner', 'full', 'left', 'right', 'semi' e 'anti'. No 'inner join', o resultado da combinação é a interseção dos dois conjuntos, ou seja, o data frame resultante contém apenas os casos presentes nas duas bases. É, pois, o 'join' mais restritivo, pois exclui qualquer caso ausente em alguma dos data frames originais.

Vamos criar o objeto 'df_inner' combinando 'obitos_2019' com 'populacao_imp'. Note que precisamos informar obrigatoriamente no argumento 'by' qual (quais) variável (variáveis) está (estão) sendo usada(s) como identificadores na combinação. No nosso caso 'codigo_ibge', pertencente a 'obitos_2019', e 'cod_ibge', a 'populacao_imp'.

```{r}
df_inner <- inner_join(obitos_2019, populacao_imp, by = c('codigo_ibge' = 'cod_ibge'))
```

Observe o resultado:

```{r}
df_inner %>% 
  glimpse()
```

Note que temos 645 linhas no novo data frame. Mas o data frame de óbitos continha 647 linhas. O que aconteceu?

Essas duas linhas extras são informações sobre o Estado de São Paulo e sobre óbitos em localidade ignorada. Ao exigirmos que o novo data frame tenha apenas os casos completos, ou seja, municípios existentes em ambas origens, tais linhas excedentes são descartadas.

Pronto. Temos agora as 4 variáveis que precisamos para calcular a mortalidade por município para cada grupo de sexo em um único data frame:

```{r}
df_inner <- df_inner %>% 
  mutate(
    mortalidade_homens = total_homens * 1000 / populacao_masculina,
    mortalidade_mulheres = total_mulheres * 1000 / populacao_feminina
  )
```

## Exportando um data frame

No tutorial anterior exportamos tabelas produzidas com _tabyl_ com o comando _write\_csv2_. Essa função vale para qualquer objeto da classe data frame e a que vamos utilizar para exportar conjunto de dados para .csv. Veja o exemplo:

```{r}
write_csv2(df_inner, 'mortalidade_sexo_municipio.csv')
```

ou, equivalentemente,

```{r}
df_inner %>% 
  write_csv2('mortalidade_sexo_municipio.csv')
```

Há um problema bastante sério com as funções de exportação do _readr_: elas não permitem exportar em outro encoding além de UTF-8. E, se você trabalhar com dados com caracteres especiais e em Windows, você terá problemas.

A alternativa é utilizar a função equivalente do pacote base, cuja grafia leva '.' no lugar de '\_', para poder especificar o encoding do arquivo exportado no argumento 'fileEncoding':

```{r}
df_inner %>% 
  write.csv2('mortalidade_sexo_municipio.csv', fileEncoding = 'Latin1', row.names = F)
```

Por padrão, as funções de exportação do base inserem uma coluna com a numeração das linhas à esquerda, o que provoca uma desordem nos nomes das variáveis, todas deslocadas uma célula à esquerda. Para evitar esse problema, precisamos do argumento 'row.names = F'.

## Caso e óbitos covid por habitante

Neste segundo exercício, vamos calcular o número de casos de COVID-19 por 100 mil habitantes para os municípios paulistas em 01 de maio de 2020. A data foi escolhida fortuitmente, pois à época a epidemia não havia chegado a todos os municípios do estado e, portanto, teremos conjuntos de dados -- a base de COVID-19 e a de população em 2020 -- sem correspondência completa entre suas observações para testarmos os diferentes tipos de joins

Vamos começar obtendo dados sobre a projeção das populações municipais em 2020, disponíveis em https://painel.seade.gov.br/repositorio-de-dados/. Nosso objetivo será calcular, para cada município, a mortalidade por COVID-19 e, por isso, precisamos da população municipal de 2020. O arquivo com o qual vamos trabalhar está em .zip. Precisamos, assim, fazer o download do zip (vamos salvá-lo com o nome 'pop20.zip'):

```{r}
download.file('https://painel.seade.gov.br/wp-content/uploads/2020/08/populacao2020.zip', 'pop20.zip')
```

A seguir, vamos 'deszipar' o arquivo 'pop20.zip' (note que este é um nome arbitrário que escolhemos na função de download para o arquivo de zip):

```{r}
unzip('pop20.zip')
```

É preciso examinar, agora, nossa pasta de trabalho para ver se o arquivo que queremos ('Populacao2020_Caracterizacao.csv', que não é um nome que escolhemos) está lá:

```{r}
list.files()
```

E, finalmente, vamos carregá-lo. Novamente, precisaremos informar o encoding para que seja lido corretamente.

```{r}
pop20 <- read_csv2('Populacao2020_Caracterizacao.csv', locale = locale(encoding = 'Latin1'))
```

Examinando os dados:

```{r}
pop20 %>% 
  glimpse()
```

Vamos limpar os nomes e selecionar apenas as variáveis que nos interessam:

```{r}
pop20 <- pop20 %>% 
  clean_names() %>% 
  select(codigo_ibge, municipio, populacao)
```

Pronto!

Agora vamos abrir os dados de casos de COVID-19 nos municípios do estado de Sâo Paulo em 01 de maio de 2020, disponíveis no repositório do curso:

```{r}
covid_maio <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/covid_sp_20200501.csv')
```

Vamos manter apenas as informações dos municípios e a contagem de casos até a data:

```{r}
covid_maio <- covid_maio %>% 
  select(codigo_ibge, nome_munic, casos)
```

Excelente! Podemos agora combinar os dois conjuntos.

## Left e right join

As duas fontes de dados têm tamanhos distintos. Enquanto 'pop20' contém os 645 municípios paulistas, 'covid_maio' contém apenas 327:

```{r}
nrow(pop20)
nrow(covid_maio)
```

Começaremos fazendo um 'left join'. 'Esquerda', significa que escolheremos uma base para mantermos à esquerda e que terá todos os seus casos preservados na combinação, ou seja, mesmo que os casos não encontrem correspondência na base à 'direita' estarão no resultado final da combinação. Contrariamente, os casos da base à 'direita' que não existam à esquerda serão descartados. 

O efeito é semelhante ao de acrescentar colunas da base à direita base das esquerda, mantendo este última integra.

```{r}
df_left <- left_join(covid_maio, pop20, by = 'codigo_ibge') 
```

Outra maneira de escrever o mesmo 'join', com pipe (%>%), é:

```{r}
df_left <- covid_maio %>% 
  left_join(pop20, by = 'codigo_ibge') 
```

A base à esquerda é, portanto, a que está fora da função quando utilizamos o pipe. Note que, como o identificador tem a mesma grafia em ambas as bases, simplificamos o uso do argumento 'by' (compare com o exercício anterior).

O resultado final tem, como esperávamos, o mesmo número de linhas da base à esquerda, 'covid_maio'. Existe apenas um caso deste conjunto de dados que não tem part em 'pop20': o município de número 9999999, 'Ignorado'.

O que acontece com as variáveis de 'pop20' acrescentadas à linha do município 'Ignorado'? Vamos examinar:

```{r}
df_left %>% 
  filter(codigo_ibge == 9999999)
```

Como 'Ignorado' não existe em 'pop20', as variáveis para esta linha provenientes da base de população recebem NA.

A operação de 'right join' é idêntica à de 'left join' se trocarmos as bases de posição. Intuitivamente, faz mais sentido usar a combinação 'esquerda', pois em geral queremos acrescentar colunas de uma segunda fonte de dados à base com a qual estamos trabalhando.

```{r}
df_right <- pop20 %>% 
  right_join(covid_maio, by = 'codigo_ibge') 
```

Com os dados combinados, podemos calcular a taxa por da população de cada município por 100 mil habitantes que teve confirmadamente COVID-19 (vamos aproveitar e excluir o município 'Ignorado'):

```{r}
df_left <- df_left %>% 
  filter(codigo_ibge == 9999999) %>% 
  mutate(casos_pc = casos * 100000 / populacao)
```

## Full join

Tanto 'inner join' quanto 'left/right join' descartam casos de pelo menos alguma das origens dos dados quando não há correspondência. Se quisermos que a combinação resulte na união completa de casos de ambas as bases utilizamos 'full join':

```{r}
df_full <- covid_maio %>% 
  full_join(pop20, by = 'codigo_ibge') 
```

Não importa qual é a base à esquerda ou à direita. O resultado para a combinação de 'covid_maio' e 'pop20' terá 646 linhas, 326 municípios paulistas que tinham casos com COVID-19 em 01 de maio de 2020, 319 que ainda não constavam na base 'covid_maio' e o 'Ignorado', que não tem informações sobre a população em 2020.

## Filtering joins

```{r}
df_f %>% 
  anti_join(df_r)
```
  