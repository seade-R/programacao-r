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

Há outros 2 joins bastante úteis em R: 'semi join' e 'anti join'. São os chamados 'filtering joins'. Seu uso é diferente dos demais. Não produzem um novo data frame com a combinação das colunas das duas fontes de dados, 'semi join' resulta em um data frame com as mesmas colunas do data frame à esquerda, apenas, e com os casos da base à esquerda que encontram correspondência na base à direita.

Vamos trocar as posições colocar agora 'pop20' à esquerda e 'covid_maio' a direita e aplicar um 'semi join'

```{r}
df_semi <- pop20 %>% 
  semi_join(covid_maio, by = 'codigo_ibge')
```

O resultado é um data frame igual a 'pop20', mas sem as linhas de municípios que não têm par em 'covid_maio'. É como aplicassemos em 'pop20' um filtro que, por extenso, se leria: 'manter apenas os municípios também encontrados em "covid_maio"'. O resultado, como esperávamos, tem 326 linhas.

O 'anti join' é a operação complementar à de 'semi joint': são mantidas apenas as linhas do conjunto à esquerda que __não__ encontram par na base à direita.

```{r}
df_anti <- pop20 %>% 
  anti_join(covid_maio, by = 'codigo_ibge')
```

Permanecem no resultado as linhas dos 319 municípios de 'pop20' que não estavam também 'covid_maio'.


# (OPCIONAL) Indivíduos e Domicílios: combinando os arquivos da TICDOM

Nesta seção, redundante em relação ao que já fizemos no tutorial, veremos o uso dos 'joins' com dados de survey (TICDOM).

Em pesquisa aplicada é bastante comum encontrarmos dados que têm natureza hierárquica. Por exemplo, em surveys como a PNAD ou a TICDOM, no qual os indívuos são dentro de domicílios, coleta-se dados tanto dos invíduos quanto do domicílios. Como é possível haver mais de um indivíduo em um determinado domicílio, os dados podem ser organizados de duas maneiras diferentes:

1 - repetindo-se para cada indivíduo a informação referente ao domicílio;
2 - separando as informações em dois arquivos diferentes, um para cada unidade de análise.

A segunda opção é bastante mais eficiente, pois evita a repetição de informações. Em pesquisas como PNAD ou Censo populacional, que resultam em arquivos grandes e que dificultam o armazenamento, transporte e abertura de dados, separar os dados em mais de um arquivo é certamente a melhor opção.

Para combinar dados referentes a domicílios e seus respectivos indivíduos em uma mesma análise é preciso combinar os dois arquivos a partir de um identificador comum a ambas. Essa é uma tarefa bastante simples de ser executada com a gramática do _dplyr_ e esse é o nosso objetivo neste tutorial.

## Abrindo e examinando os arquivos de domicílios e indivíduos da TICDOM

Vamos começar abrindo as bases. Precisamos, como fizemos anteriormente, do endereço na web ou no seu computador de onde estão armazenadas. Podemos guardá-las em um objeto simples de texto para facilitar seu uso:

```{r}
ticdom_ind_url <- "http://cetic.br/media/microdados/181/ticdom_2017_individuos_base_de_microdados_v1.3.csv"
ticdom_dom_url <- "http://cetic.br/media/microdados/153/ticdom_2017_domicilios_base_de_microdados_v1.1.csv"
```

A seguir, utilizaremos a função _read\_csv2_ do pacote _readr_ para carregar as bases:

```{r}
ticdom_ind <- read_csv2(ticdom_ind_url)
ticdom_dom <- read_csv2(ticdom_dom_url)
```

Note que as bases têm tamanhos diferentes:

```{r}
dim(ticdom_ind)
dim(ticdom_dom)
```
A base de indivíduos têm 20490 linhas, cada uma representando um indivíduo, e 220 variáveis.

A base de domicílios tem 23592 linhas, cada uma representando um domicílio, e 65 variáveis.

Há algo contra intuitivo nestas informações. Se cada domicílio pode conter mais de un indivíduo, deveríamos esperar mais unidades do segundo do que do primeiro.

Certamente encontraremos domicílios que não estão associados a nenhum indivíduo da base carregada -- no caso da TICDOM, esses domicílios estão associados a outras pesquisas.

É possível que encontremos indivíduos que não estão em nenhum domicílio, mas, por se tratar de uma pesquisa cujo desenho amostral faz a seleção de indivíduos após a seleção de domicílios, este caso seria anômalo.

Vamos ver como combinar as duas bases e quais são as nossas opções.

## Combinando à direita e à esquerda

O primeiro passo ao combinar bases de dados é localizar, em ambas os data frames, qual é a 'chave' ou 'identificador' que associa as unidades de uma base às de outra.

No caso da TICDOM, o 'id\_domicilio' cumpre esse papel. Cada domicílio tem um identificador único que também é encontrado nos dados individuais, podendo ser repetido se houver mais de um indivíduo associado a um domicílio.

A chave não precisa estar em uma única variável. O IBGE costuma utilizar duas ou mais variáveis que, combinadas, criam a chave que associa diferentes bases. Códigos de unidades geográficas -- código de UF ou de município, por exemplo -- costumam ser bons identificadores. CPF, NIS e título de eleitor costumam ser utilizados como chave para indivíduos, e, em casos extremos, até mesmo nome, com o risco de haver ambiguidades e duplicidades.

O segundo passo é escolher qual será a base posicionada 'à esquerda' e qual será posicionada 'à direita'. Uma vez posicionadas, utilizamos alguma função do tipo 'join' para juntá-las. Vejo o exemplo antes de detalharmos as escolhas de posição. Vamos começar fazendo um _left\_join_.

```{r}
ticdom_all_ind <- left_join(ticdom_ind, ticdom_dom, by = 'id_domicilio')
```

O data frame que aparece do lado esquedo do parêntese é obviamente, o que foi posicionado à esquerda. Ao utilizarmos o verbo _left\_join_ estamos fazendo a seguinte opção: 'manter na nova base todas as unidades que existiam na base à esquerda e adicionar a elas as colunas da base da direita quando houver correspondência'.

No nosso caso, todos os indivíduos permanecerão no novo data frame. Se o 'id\_domicilio' desses indivíduos for encontrado na base de domicílios, as informações do domicílio serão adicionadas como novas colunas. Se, por outro lado, o 'id\_domicilio' desses indivíduos não constar na base de domicílios, as novas colunas existirão, porém serão preenchidas com NA.

Recapitulando, com _left\_join_ as unidades da base à esquerda permanecerão e a base da direita contribuirá com novas colunas quando houver correspondência.

Note que podemos utilizar o \%>\% para fazer a operação. A grafia diferente não muda em nada o resultado. Esse é o uso mais comum:

```{r}
ticdom_all_ind <- ticdom_ind %>%
  left_join(ticdom_dom, by = 'id_domicilio')
```

Dentro do argumento "by" inserimos a chave -- ou um vetor de chaves -- que farão a 'ligação' entre as bases.

Note que, para os dados utilizados, encontramos um base com o mesmo número de linhas que o data frame posicionado à esquerda, como esperávamos. Podemos notar que as variáveis que são excluivas do arquivo de domicílios -- como AREA, radio e automovel -- estão no novo data frame.

```{r}
names(ticdom_all_ind)
```

Se houver variáveis com nomes idênticos em ambos data frames, salvo as variáveis apontadas no parâmetro 'by', cada um receberá o nome original terminados por ".x" e ".y", para esquerda e direita, respectivamente. É isso que ocorre com "QUEST" e "RENDA\_FAMILIAR.y".

O verbo _right\_join_ tem o mesmo funcionamento que _left\_join_, apenas invertendo as funções dos data frames posicionados à direita e à esquerda.

```{r}
ticdom_all_dom <- ticdom_ind %>%
  right_join(ticdom_dom, by = 'id_domicilio')
```

Dessa vez, a base resultante tem o mesmo número de linha que a base de domicílios. Nesse caso, porém, nem todos os domicílios encontraram correspondência no data frame de indivíduos. Para tais domicílios, as variáveis originárias da base de indivíduos são preenchidas com NA. Podemos inspecionar isso rapidamente pedindo para observar as linhas com NA para uma variável que só existe no data frame de indivíduos. como "ID\_MORADOR":

```{r}
ticdom_all_dom %>% 
  filter(is.na(ID_MORADOR))
```

## Interseção de duas bases

E ser quiseremos trabalhar apenas com os casos completos, ou seja, somente os casos para os quais há correspondência em ambos data frame? Esta situação é a interseção entre as duas bases e é produzida pelo verbo _inner\_join_:

```{r}
ticdom_inner <- ticdom_ind %>%
  inner_join(ticdom_dom, by = 'id_domicilio')
```

Não importa, nessa situação, qual é a base à direita ou à esquerda. Ambas contribuem somemente com os casos 'completos' e todas as sua variáveis.

Como, para os dados com os quais trabalhamos, todos os indivíduos encontram correspondência em domicílios -- o contrário não é verdade -- o resultado é idêntico ao produzido com _left\_join_. Mas, obviamente, isso é ocasional e, em geral, não ocorre.

## Combinação total de duas bases

Finalmente, pode ser desejável incluir todos os casos de ambos data frames, não importando se existe correspondência na outra base. Em vez da interseção, trabalharíamos com a união de todos os casos. Fazemos a união com o verbo _full\_join_:

```{r}
ticdom_full <- ticdom_ind %>%
  full_join(ticdom_dom, by = 'id_domicilio')
```

Novamente, não importa quais são os data frame à direita ou à esquerda. A união incluirá todos os casos completos da interseção e também os casos incompletos que apareceriam no _left\_join_ e no _right\_join_.
