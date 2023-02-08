# `janitor`, `factor` e tabelas simples na gramática do `dplyr`

No [tutorial anterior](/tutorial/tutorial-06.md) vimos que a produção de tabelas na gramática do tidyverse pode ser feita utilizando o verbo `group_` acompanhado de `count()` ou `summarise()`. As tabelas de frequência eram sempre novos data frames, menores, compactados.

Neste tutorial, vamos explorar um pouco mais a confecção de tabelas na gramática do `dplyr` utilizando um pacote que é uma baita mão na roda: `janitor`. Em vez de utilizarmos `group_by()` para produzirmos tabelas de frequência, teremos funções simples que entregam o mesmo resultado e, de quebra, formatam a tabela para seu uso em relatórios ou para exportação.

No processo de confecção de tabelas aprenderemos sobre um novo tipo de variável em R: *factor*. 

_Factors_ são utilizados para variáveis categóricas. Até agora, mantivemos tais variáveis como texto. Entretanto, trabalhar variáveis categóricas como texto é incoveniente, sobretudo no caso de categorias ordenáveis, nas quais a ordem das categorias não corresponde à ordem alfabética. 

Para quem vem de outros softwares de análise de dados, factors correspondem a variáveis categóricas armazenadas com códigos numéricos acompanhados de rótulos de valores.

## Dados de óbitos de 2021

Neste tutorial utilizaremos os microdados de óbitos do Registro Civil de São Paulo de 2021, produzidos pelo SEADE. Você encontra os dados [neste link do Repositório do SEADE](https://repositorio.seade.gov.br/dataset/microdados-obitos). Antes de obter os dados, vamos carregar os pacotes que vamos utilizar, `janitor` e `tidyverse`.

Comece instalando o pacote que vamos utilizar, `janitor`. Em seguida, carregue os pacotes:

``` r
install.packages('janitor')

library(janitor)
library(tidyverse)
```

Agora, importamos os dados:

``` r
obitos_2021 <- read_csv2("https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/main/data/microdados_obitos2021.csv")
```

## Nomes bonitos para variáveis com `janitor`

Nesta versão do banco de dados de óbitos do registro civil, os nomes das variáveis estão razoavelmente dentro das convenções. Poderiam, porém, estar em minúscula. No pacote `janitor` há uma função excelente para lidar com nomes com espaços, acentos e maísculas: *clean_names()*. Por ora, vamos aplicá-la para tornar os nomes deste conjunto de dados mais próximos da convenção e conhecer a função:

``` r
obitos_2021 <- obitos_2021 %>% 
  clean_names() 
```

Vamos usar novamente *glimpse()* para observar o resultado:

``` r
obitos_2021 %>% 
  glimpse()
```

## `tabyl()`: seu novo melhor amigo para produzir tabelas

No tutorial passado vimos que podemos produzir tabelas de frequência na gramática do `dplyr` com o combo `group_by()` e `count()`. Por exemplo, vamos fazer a contagem de óbitos por sexo em nossos dados:

``` r
obitos_2021 %>% 
  group_by(sexo) %>% 
  count()
```

Em vez de precisarmos de duas funções, podemos utilizar simplesmente `tabyl()`, do pacote `janitor`:

``` r
obitos_2021 %>% 
  tabyl(sexo)
```

Ademais de produzir a contagem, `tabyl()` produz também a _frequência relativa_ de cada categoria da variável escolhida.

A tabela é, digamos, _feia_. Vamos melhorá-la. Porém, não começaremos pela estética da tabela, mas produzindo uma mudança na variável **sexo**, transformando-a de "character" em "factor".

## Factors em R

"Factors" são certamente uma das maiores pedras no sapato em R (e por isso os evitamos até agora). A razão disso é que diversas funções da 'gramática do R base' convertem automaticamente texto em "factor".

Entretanto, "factors" são muito úteis e, às vezes, inevitáveis. 

Olhe novamente para a tabela que produzimos: as categorias da variável sexo são "F", "I" e "M", e você deve ter deduzido que correspondem a "Feminino", "Ignorado" e "Masculino", respectivamente. Incovenientemente, "Ignorado" aparece no meio da tabela, quando esperaríamos que figurasse como última categoria.

A tabela respeita o ordenamento da variável que, por ser do tipo "character", é alfabético. Como fazer uma tabela na qual a ordem seja "Feminino", "Masculino" e "Ignorado"?

Em primeiro lugar, vamos recodificar a variável e escrever o nome das categorias por extenso. Fazemos isso com `mutate()`, já que estamos transformando uma coluna, e `recode()`, que é a função de transformação que aplicaremos:

``` r
obitos_2021 <- obitos_2021 %>% 
  mutate(sexo = recode(sexo,
                       'F' = 'Feminino',
                       'M' = 'Masculino',                  
                       'I' = 'Ignorado'))
```

Repetindo a tabela, vemos que os textos das categorias mudaram, mas a ordem continua inconveniente. Após a recodificação, **sexo** ainda é uma variável de texto.

``` r
obitos_2021 %>% 
  tabyl(sexo)
```

Para transformar texto em "factor" usamos a função `factor()`. E especificamos no argumento `level` um vetor com a ordem das categorias da nova variável. Assim, vamos criar uma nova variável, **sexo_f**, que será a versão de **sexo** como "factor", e cuja ordem das categorias é definida pelo vetor `c("Feminino", "Masculino", "Ignorado")`. Veja:

``` r
obitos_2021 <- obitos_2021 %>% 
  mutate(sexo_f = factor(sexo, 
                         levels = c('F', 'M', 'I')))
```

Produzindo a tabela com nossa nova variável temos:

``` r
obitos_2021 %>% 
  tabyl(sexo_f)
```

Muito melhor, não?

Vamos fazer o mesmo para variável **racacor**, que contém a informação sobre raça/cor nos dados de óbitos de 2021. Veja a tabela antes da transformação:

``` r
obitos_2021 %>% 
  tabyl(racacor) 
```

Puxa, está tudo em código numérico! Não tem problema, vamos recodificar. Para que possamos recofidicar, precisamos ter acesso ao dicionário de variáveis dessa base. O dicionário é um documento que descreve a base de dados e todas as suas variáveis. O dessa pesquisa está disponível [neste link do Repositório de Dados do SEADE](https://repositorio.seade.gov.br/dataset/30026c29-2237-4ee4-8650-ea3a9657dcd8/resource/12244a8d-db32-4de5-b5cd-7c9af53ad4ee/).

Dessa vez, porém, não utilizaremos `recode()`. Como sabemos que queremos uma variável do tipo "factor" ao final, utilizaremos *recode_factor()*. A ordem das recodificações corresponderá à ordem dos `levels` da nova variável:

``` r
obitos_2021 <- obitos_2021 %>% 
  mutate(racacor_f = recode_factor(
          racacor,
          '1' = 'Branca',
          '2' = 'Preta',                  
          '3' = 'Amarela',
          '4' = 'Parda',
          '5' = 'Indígena',
          '9' = 'Ignorada'))
```

A tabela para nossa nova variável, **racacor_f** é:

``` r
obitos_2021 %>% 
  tabyl(racacor_f) 
```

Excelente! Porém, ainda não muito bonita.

## "Enfeitando" as tabelas produzidas com tabyl

Se as tabelas produzidas com `tabyl()` são data frames, renomear suas margens é exatamente como renomear variáveis de um data frame:

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)
```

No pacote `janitor`, há um conjunto de funções de prefixo `adorn_*` que serve para alterar a estética da tabela. `adorn_pct_formatting()` transforma a coluna **percent** em percentual, ou seja, multiplica por 100, delimita o número de casas decimais e adiciona o símbolo %.

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting()
```

Se objetivo for apenas arredondar as casas decimais, `adorn_rounding()` cumpre bem a função. Você pode escolher o número de dígitos:

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_rounding(digits = 2)
```

Como adicionar totais? Com `adorn totals()`:

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_totals()
```

Você pode combinar mais de uma função `adorn_*`:

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)
```

Chegamos, finalmente, a uma tabela razoavelmente bonita em R. Lembre-se que você sempre pode guardar sua tabela como objeto fazendo uma atribuição.

``` r
tabela_racacor <- obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)
```

E pode usá-la novamente quando quiser.

``` r
tabela_racacor
```

Uma curiosidade. Se invertermos o símbolo de atribuição, ou seja, se no lugar de `<-` usarmos `->` a operação de atribuição funciona?

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent) -> tabela_racacor 
```

Sim, funciona. Mas a boa prática de legibilidade dos códigos em R é usar o sentido de `<-`.

## Exportando tabelas com *readr*

Chegamos, finalmente, a uma tabela razoavelmente bonita em R. Como exportá-la?

Aprendemos no passado sobre as funções `read_*` para abrirmos arquivos de texto. Para exportar arquivos de texto não temos nenhuma surpresa: usamos funções com prefixo `write_*`, também do pacote `readr`.

Por exemplo, se quiseremos exportar nossa tabela (que é um data frame) em formato .csv separado por ponto e vírgula fazemos:

``` r
write_csv2(tabela_racacor, 'tabela_racacor.csv')
```

O primeiro argumento é o objeto a ser exportado e o segundo é o nome do arquivo que será criado.

Outra forma de escrever o mesmo comando é usando pipe (`%>%`):

``` r
tabela_racacor %>% 
  write_csv2('tabela_racacor.csv')
```

Se você quiser, pode emendar a exportação de uma tabela ao final do código que a produz para evitar uma atribuição:

``` r
obitos_2021 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent) %>% 
  write_csv2('tabela_racacor.csv')
```

Voltaremos à exportação de data frames no próximo tutorial.

## Tabulações cruzadas (crosstabs) com `tabyl()`

Sim, há como fazer _crosstabs_ em R. Basta usar `tabyl()` com duas variáveis (`tabyl()` é a sua melhor amiga na produção de tabelas em R):

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f)
```

Como se trata de uma tabela de duas entradas, temos que o conteúdo da célula é uma contagem. Com `adorn_percentages()` transformamos o conteúdo das células em percentuais dentro de cada linha.

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages()
```

Convém usar `adorn_pct_formatting()` para conseguir ler alguma coisa na tabela:

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages() %>% 
  adorn_pct_formatting()
```

Se alterarmos o denominador (argumento `denominator`) dentro da função para `denominator = 'col'`, temos agora percentuais calculados dentro de cada coluna:

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'col') %>% 
  adorn_pct_formatting()
```

Ou ainda sobre o total da tabela, se usarmos "all" como denominador:

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_pct_formatting()
```

Tal como na tabela para apenas uma variável, podemos adicionar a soma da linhas com `adorn totals()`:

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals()
```

Ou a soma de colunas se utilizarmos `where = 'col'` dentro de `adorn totals()`

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = 'col')
```

Ou ainda a soma de linhas e colunas se a opção em `where` for o vetor `c('col', 'row')`.

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = c('col', 'row'))
```

Os totais valem para percentuais, obviamente:

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_pct_formatting()  
```

Não faz nenhum sentido usar `rename()` para alterar uma tabela de duas entradas produzida com `tabyl()`, pois ambas as margens contêm as categorias das variáveis utilizadas em sua produção. Mas há uma solução. O último "enfeite" à nossa tabela, que se aplica apenas à tabela de duas entradas, é escrever o nome das variáveis de linha e de coluna com `adorn_title()`. Veja um exemplo de uso:

``` r
obitos_2021 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_pct_formatting() %>% 
  adorn_title(placement = 'top',
              row_name = 'Raça/cor', 
              col_name =  'Sexo')
```

## `cut()`: criando faixas a partir de uma variável numérica

Uma das transformações que podemos fazer com variáveis numéricas envolve a criação de faixas (ou categorias) associadas a intervalos determinados entre os valores numéricos.

Por exemplo, no data frame de óbitos, temos a variável **idadeanos**, que apesar de ter apenas números, foi salva como uma variável textual. O primeiro passo, então, é torná-la uma variável numérica, usando `as.numeric()`, do R base.

``` r
obitos_2021 <- obitos_2021 %>% 
  mutate(idadeanos = as.numeric(idadeanos)) 
```

Em seguida, podemos "cortar" as idades em alguns intervalos (ou `breaks`) e atribuir rótulos (ou `labels`) a esses intervalos, que descrevem as faixas de idade a que pertencem. Veja no exemplo abaixo:

``` r
obitos_2021 <- obitos_2021 %>% 
  mutate(
    idade_faixa = cut(idadeanos, 
                      breaks = c(-Inf, 18, 75, Inf),
                      labels = c('0 a 17', '18 a 74', '75 ou mais'))
  )
```

Agora podemos rodar a tabela de frequências usando `tabyl()` como vimos anteriormente:

``` r
obitos_2021 %>% 
  tabyl(idade_faixa) %>% 
  adorn_pct_formatting()
```
