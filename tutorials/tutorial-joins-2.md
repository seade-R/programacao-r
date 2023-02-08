# Indivíduos e Domicílios: combinando os arquivos da TICDOM

Nesta seção, redundante em relação ao que já fizemos no tutorial anterior, veremos o uso dos _joins_ com dados de survey (TICDOM).

Em pesquisa aplicada é bastante comum encontrarmos dados que têm natureza hierárquica. Por exemplo, em _surveys_ como a PNAD ou a TICDOM, no qual os indívuos estão dentro de domicílios, coleta-se dados tanto dos invíduos quanto do domicílios. Como é possível haver mais de um indivíduo em um determinado domicílio, os dados podem ser organizados de duas maneiras diferentes: (1) repetindo-se para cada indivíduo a informação referente ao domicílio; (2) separando as informações em dois arquivos diferentes, um para cada unidade de análise.

A segunda opção é bastante mais eficiente, pois evita a repetição de informações. Em pesquisas como PNAD ou Censo populacional, que resultam em arquivos grandes e que dificultam o armazenamento, transporte e abertura de dados, separar os dados em mais de um arquivo é certamente a melhor opção.

Para combinar dados referentes a domicílios e seus respectivos indivíduos em uma mesma análise, é preciso combinar os dois arquivos a partir de um identificador comum a ambas. Essa é uma tarefa bastante simples de ser executada com a gramática do `dplyr` e esse é o nosso objetivo neste tutorial.

## Arquivos de domicílios e indivíduos da TICDOM

Vamos começar abrindo as bases e carregando pacotes. Precisamos, como anteriormente, do endereço na web ou no seu computador de onde estão armazenadas. Podemos guardá-las em um objeto simples de texto para facilitar seu uso:

``` r
library(tidyverse)
library(janitor)

ticdom_ind_url <- "http://cetic.br/media/microdados/181/ticdom_2017_individuos_base_de_microdados_v1.3.csv"
ticdom_dom_url <- "http://cetic.br/media/microdados/153/ticdom_2017_domicilios_base_de_microdados_v1.1.csv"
```

A seguir, utilizaremos a função `read_csv2()` do pacote `readr` para carregar as bases:

``` r
ticdom_ind <- read_csv2(ticdom_ind_url)
ticdom_dom <- read_csv2(ticdom_dom_url)
```

Note que as bases têm tamanhos diferentes:

``` r
dim(ticdom_ind)
dim(ticdom_dom)
```

* A base de indivíduos têm 20.490 linhas, cada uma representando um indivíduo, e 220 variáveis.

* A base de domicílios tem 23.592 linhas, cada uma representando um domicílio, e 65 variáveis.

Há algo contra intuitivo nestas informações. Se cada domicílio pode conter mais de um indivíduo, deveríamos esperar mais unidades do segundo do que do primeiro.

Certamente encontraremos domicílios que não estão associados a nenhum indivíduo da base carregada -- no caso da TICDOM, esses domicílios estão associados a outras pesquisas.

É possível que encontremos indivíduos que não estão em nenhum domicílio, mas, por se tratar de uma pesquisa cujo desenho amostral faz a seleção de indivíduos após a seleção de domicílios, este caso seria anômalo.

Vamos ver como combinar as duas bases e quais são as nossas opções.

## Combinando à direita e à esquerda

O primeiro passo ao combinar bases de dados é localizar, em ambas os _data frames_, qual é a "chave" ou "identificador" que associa as unidades de uma base às de outra.

No caso da TICDOM, o **id_domicilio** cumpre esse papel. Cada domicílio tem um identificador único que também é encontrado nos dados individuais, podendo ser repetido se houver mais de um indivíduo associado a um domicílio.

A chave não precisa estar em uma única variável. O IBGE costuma utilizar duas ou mais variáveis que, combinadas, criam a chave que associa diferentes bases. Códigos de unidades geográficas -- código de UF ou de município, por exemplo -- costumam ser bons identificadores. CPF, NIS e título de eleitor costumam ser utilizados como chave para indivíduos, e, em casos extremos, até mesmo nome, com o risco de haver ambiguidades e duplicidades.

O segundo passo é escolher qual será a base posicionada "à esquerda" e qual será posicionada "à direita". Uma vez posicionadas, utilizamos alguma função do tipo `_join` para juntá-las. Vejo o exemplo antes de detalharmos as escolhas de posição. Vamos começar fazendo um `left_join()`.

``` r
ticdom_all_ind <- left_join(ticdom_ind, ticdom_dom, by = 'id_domicilio')
```

O _data frame_ que aparece do lado esquerdo do parêntese é, obviamente, o que foi posicionado à esquerda. Ao utilizarmos o verbo `left_join()` estamos fazendo a seguinte opção: "manter na nova base todas as unidades que existiam na base à esquerda e adicionar a elas as colunas da base da direita quando houver correspondência".

No nosso caso, todos os indivíduos permanecerão no novo _data frame_. Se o **id_domicilio** desses indivíduos for encontrado na base de domicílios, as informações do domicílio serão adicionadas como novas colunas. Se, por outro lado, o **id_domicilio** desses indivíduos não constar na base de domicílios, as novas colunas existirão, porém serão preenchidas com `NA`.

Recapitulando, com `left_join()` as unidades da base à esquerda permanecerão e a base da direita contribuirá com novas colunas quando houver correspondência.

Note que podemos utilizar o `%>%` para fazer a operação. A grafia diferente não muda em nada o resultado. Esse é o uso mais comum:

``` r
ticdom_all_ind <- ticdom_ind %>%
  left_join(ticdom_dom, by = 'id_domicilio')
```

Dentro do argumento `by` inserimos a chave -- ou um vetor de chaves -- que farão a "ligação" entre as bases.

Note que, para os dados utilizados, encontramos uma base com o mesmo número de linhas que o _data frame_ posicionado à esquerda, como esperávamos. Podemos notar que as variáveis que são exclusivas do arquivo de domicílios -- como **AREA**, **radio** e **automovel** -- estão no novo _data frame_.

``` r
names(ticdom_all_ind)
```

Se houver variáveis com nomes idênticos em ambos _data frames_, salvo as variáveis apontadas no parâmetro `by`, cada um receberá o nome original terminados por **.x** e **.y**, para esquerda e direita, respectivamente. É isso que ocorre com **QUEST** e **RENDA_FAMILIAR**.

O verbo `right_join()` tem o mesmo funcionamento que `left_join()`, apenas invertendo as funções dos _data frames_ posicionados à direita e à esquerda.

``` r
ticdom_all_dom <- ticdom_ind %>%
  right_join(ticdom_dom, by = 'id_domicilio')
```

Dessa vez, a base resultante tem o mesmo número de linhas que a base de domicílios. Nesse caso, porém, nem todos os domicílios encontraram correspondência no _data frame_ de indivíduos. Para tais domicílios, as variáveis originárias da base de indivíduos são preenchidas com `NA`. Podemos inspecionar isso rapidamente pedindo para observar as linhas com `NA` para uma variável que só existe no _data frame_ de indivíduos, como **ID_MORADOR**:

``` r
ticdom_all_dom %>% 
  filter(is.na(ID_MORADOR))
```

## Interseção de duas bases

E se quiseremos trabalhar apenas com os casos completos, ou seja, somente os casos para os quais há correspondência em ambos _data frame_? Esta situação é a interseção entre as duas bases e é produzida pelo verbo `inner_join()`:

``` r
ticdom_inner <- ticdom_ind %>%
  inner_join(ticdom_dom, by = 'id_domicilio')
```

Não importa, nessa situação, qual é a base à direita ou à esquerda. Ambas contribuem somente com os casos "completos" e todas as suas variáveis.

Como, para os dados com os quais trabalhamos, todos os indivíduos encontram correspondência em domicílios -- o contrário não é verdade -- o resultado é idêntico ao produzido com `left_join()`. Mas, obviamente, isso é ocasional e, em geral, não ocorre.

## Combinação total de duas bases

Finalmente, pode ser desejável incluir todos os casos de ambos _data frames_, não importando se existe correspondência na outra base. Em vez da interseção, trabalharíamos com a união de todos os casos. Fazemos a união com o verbo `full_join()`:

``` r
ticdom_full <- ticdom_ind %>%
  full_join(ticdom_dom, by = 'id_domicilio')
```

Novamente, não importa quais são os _data frames_ à direita ou à esquerda. A união incluirá todos os casos completos da interseção e também os casos incompletos que apareceriam no `left_join()` e no `right_join()`.

## Uma representação visual

O livro [R for Data Science](https://r4ds.had.co.nz/relational-data.html) tem um capítulo muito bom sobre bases relacionais, que trás uma representação visual dos diferentes tipos de joins possíveis. Talvez isso possa lhe ajudar a guardar as informações deste tutorial:

![Representação visual de joins](join.png){width="213"}
