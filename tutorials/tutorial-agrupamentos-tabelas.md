# Agrupamentos e tabelas na gramática do `dplyr`

No primeiro e segundo tutoriais aprendemos sobre os principais verbos do `dplyr`. Neste tutorial vamos usar um pouco mais os mesmos verbos, agora em conjunto com outras funções. Nossa intenção é usar um pouco mais a linguagem para nos habituarmos a ela ao mesmo tempo em que novas funcionalidades ou novos usos para funções já vistas vão aparecendo.

## PIESP - investimento por CNAE

Vamos fazer um exercício simples de recodificar a CNAE (Classificação Nacional de Atividades Econômicas) das empresas alvo de investimento, trabalhando com as duas divisões da CNAE que mais recebem investimentos e com o tipo de investimento (ampliação, modernização ou implantação).

Lembre-se sempre de carregar os pacotes que vai usar antes de começar a produzir o código. Usaremos, por enquanto, apenas o `tidyverse`.

Vamos carregar novamente os dados da pesquisa SEADE Investimentos:

``` r
library(tidyverse)
url_piesp <- "https://raw.githubusercontent.com/thandarasantos/egesp-seade-intro-programacao/main/data/piesp.csv"
piesp <- read_csv2(url_piesp)
```

E renomear algumas das variáveis de interesse:

``` r
piesp <- piesp %>% 
  rename(ano = Ano,
         valor = `Real (em milhoes)`,
         munic = Municipio,
         cnae = `CNAE Empresa alvo do investimento`,
         tipo = `Tipo Investimento`)
```

## Tabelas no tidyverse são sempre agrupamentos

Vocês notaram a ausência de uma função simples de produção de tabela até agora nos tutoriais? Algo como "table"?

Bom, existe a função `table()` no pacote base. Seu uso é um pouco estranho por conta de um símbolo que ainda não vimos, o `$`. Veremos esse símbolo quando aprendermos sobre a gramática de manipulação de dados do 'base'.

Veja uma tabela de contagem de investimentos por ano:

``` r
table(piesp$ano)
```

Com o pacote `dplyr`, porém, utilizamos o verbo `group_by()` para produzir operações que envolvem agregação por uma variável categórica:

``` r
piesp %>% 
  group_by(ano) %>% 
  count()
```

`count()` serve para contar as linhas dentro de cada 'grupo' da variável ano. A classe do objeto gerado com o código acima é, veja só, também um data frame.

``` r
piesp %>% 
  group_by(ano) %>% 
  count() %>% 
  class()
```

Quando falamos em tabulações, no contexto da gramática do `dplyr`, estamos falando em data frames reduzidos pelo uso do verbo de agrupamento.

Vamos produzir agora uma tabela com contagem de investimentos por CNAE e ordenada de forma decrescente pela contagem (variável **n**):

``` r
piesp %>% 
  group_by(cnae) %>% 
  count() %>% 
  arrange(desc(n)) 
```

Voltaremos a falar sobre tabelas. Vamos parar agora para fazer algumas transformações na variável **cnae**.

## Divisão da CNAE

A última tabela que produzimos ficou demasidamente grande, pois existem muitas CNAEs. Para simplificar nossa análise, vamos trabalhar apenas com a divisão da CNAE, que é representada pelos 2 primeiros dígitos. Como a CNAE é uma variável do tipo "character"", apesar de ser escrita em números, temos que fazer um recorte pelos 2 primeiros dígitos do texto da CNAE. Vamos usar o verbo `mutate()` e a função `str_sub()` ('str' de *string* e 'sub' de *subset*) para criar a variável divisão. `str_sub()` é parte do pacote `stringr`, que também compõem o `tidyverse`.

``` r
piesp <- piesp %>% 
  mutate(divisao = str_sub(cnae, start = 1, end = 2),
         divisao = as.numeric(divisao))
```

Os argumentos de `str_sub()` são a variável da qual retiraremos os dígitos, a posição do primeiro dígito a ser retirado e a posição do último dígito.

Como o resultado é um número de 2 dígitos, podemos usar a função `as.numeric()` para transformarmos seu tipo. Existe uma função de prefixo `as.` para cada tipo de dado: character, logical, etc.

Vamos produzir uma tabela com a nova variável:

``` r
piesp %>% 
  group_by(divisao) %>% 
  count() %>% 
  arrange(desc(n)) 
```

Encontramos 76 divisões nos dados de investimentos. Vamos restringir nossa análise às duas divisões com mais investimentos, 47 (comércio varejista) e 56 (alimentação). Criaremos, assim, uma nova versão dos dados apenas com as linhas de investimentos dessas duas divisões. Note que precisamos fazer uma nova atribuição para gerar essa cópia reduzida dos nossos dados.

``` r
piesp_2 <- piesp %>%
  filter(divisao == 56 | divisao == 47)
```

Simplificando a tabela anterior:

``` r
piesp_2 %>% 
  group_by(divisao) %>% 
  count()
```

Mas 47 é qual divisão mesmo? Alimentação ou Comércio varejista? Para não esquecermos, vamos criar uma nova variável que terá o nome descritivo da divisão em lugar de seu código numérico com a função `recode()`. Veja com calma e tente entender o seu uso:

``` r
piesp_2 <- piesp_2 %>%
  mutate(divisao_desc = recode(divisao, 
                               '56' = 'Alimentacao', 
                               '47' = 'Varejo'))
```

A tabela fica bem melhor assim:

``` r
piesp_2 %>% 
  group_by(divisao_desc) %>% 
  count()
```

Qual das divisões tem, na média, mais investimentos anunciados de maior valor? Em vez de usarmos `count()` para termos a contagem como conteúdo das células, podemos gerar uma estatística a partir de uma segunda variável com o verbo `summarise()`. Por exemplo, a média de valores anunciados:

``` r
piesp_2 %>% 
  group_by(divisao_desc) %>% 
  summarise(media_valor = mean(valor, na.rm = T))
```

Lembre-se da usar o argumento `na.rm = T` para excluir os missings, pois há muitos deles na variável de valor em milhões de R$ que utilizamos acima.

Dentro do `summarise()` cabem todas as estatísticas descritivas que vimos no [tutorial 3](https://github.com/seade-R/egesp-seade-intro-programacao/blob/main/tutorial/tutorial-03.md):

``` r
piesp_2 %>% 
  group_by(divisao_desc) %>% 
  summarise(contagem = n(),
            media = mean(valor, na.rm = T),
            desvpad = sd(valor, na.rm = T),
            mediana = quantile(valor, probs = 0.5, na.rm = T),
            soma = sum(valor, na.rm = T),
            minimo = min(valor, na.rm = T),
            maximo = max(valor, na.rm = T))
```

Como temos que repetir muitas vezes o argumento de exclusão de missings, o mais simples é refazermos o código usando `filter()` para eliminarmos os NAs da variável **valor** antes de fazermos o agrupamento:

``` r
piesp_2 %>% 
  group_by(divisao_desc) %>% 
  filter(!is.na(valor)) %>% 
  summarise(contagem = n(),
            media = mean(valor),
            desvpad = sd(valor),
            mediana = quantile(valor, probs = 0.5),
            soma = sum(valor),
            minimo = min(valor),
            maximo = max(valor))
```

Lembre-se que, aqui, não estamos criando novos objetos. Estamos apenas "imprimindo" tabelas no **Console** para analisar os dados. Para criarmos novos objetos teríamos que atribuir (`<-`) o código a um objeto nomeado.

## Cruzamentos de variáveis

Vamos incluir uma nova variável na nossa análise: o tipo de investimento, ou seja, se o investimento é de implantação, ampliação ou modernização de negócios.

``` r
piesp_2 %>% 
  group_by(tipo) %>% 
  count()
```

Vamos simplificar essa variável e trabalhar apenas com duas categorias: "Implantacao" e "Ampliacao/Modernizacao", que conterá "Ampliacao" e "Modernizacao", antes separadas. Vamos fazer uma substituição na própria variável, sobrescrevendo-a. Utilizaremos o verbo `mutate()` e a função `replace()`. Leia com calma para entender o seu uso:

``` r
piesp_2 <- piesp_2 %>%
  mutate(
    tipo = replace(tipo, tipo == 'Ampliacao', 'Ampliacao/Modernizacao'),
    tipo = replace(tipo, tipo == 'Modernizacao', 'Ampliacao/Modernizacao')
    )
```

Podemos agora fazer um agrupamento a partir de duas variáveis para gerarmos uma tabela de duas entradas:

``` r
piesp_2 %>% 
  group_by(divisao_desc, tipo) %>% 
  count()
```

Não era isso que esperávamos, certo? Seria mais legal receber algo assim (como fazemos na gramática do `base`):

``` r
table(piesp_2$divisao_desc, piesp_2$tipo)
```

Repare com cuidado. As duas tabelas fornecem a mesma informação. _A diferença está no formato_. A segunda representa o "pivotamento da primeira"", que, apesar de termos chamado de tabela, é um data frame no formato _long_ (ou seja, "comprido").

_Long_ e _wide_ são as denominações que damos aos formatos acima, respectivamente. Na gramática do `dplyr` trabalharemos sempre com o formato _long_ e há uma boa razão para isso: fazer operações e, sobretudo, produzir gráficos com tabelas no formato _long_ é mais simples. Quando chegarmos à "gramática dos gráficos" isso ficará mais claro.

Há dois verbos no `tidyverse` (mais especificamente, no pacote `tidyr`) que são utilizados para redesenhar data frames de _long_ em _wide_ e vice-versa: `pivot_wider()` e `pivot_longer()`. Veja o uso do primeiro para rearranjar nossa tabela:

``` r
piesp_2 %>% 
  group_by(divisao_desc, tipo) %>% 
  count() %>% 
  pivot_wider(names_from = tipo,
              values_from = n)
```

Estamos muito acostumados a fazer tabelas de duas entradas. Mas, garanto a você, elas são menos úteis do que parecem. Se você não gostou do código acima, não se preocupe, você vai usá-lo raramente (e não se preocupe caso tenha dificuldade de entender o funcionamento das funções `pivot_`, [usuários de R costumam ter dificuldades com elas](https://twitter.com/data_question/status/1534416818810462209)).

Finalmente, o formato _long_ permite que façamos o cruzamento de quantas variáveis quisermos, ou seja, podemos pensar em uma tabela de inúmeras margens que é representada por um data frame "verticalizado". Vamos incluir o ano, por exemplo, restringindo para 2019 e 2020.

```{r}
piesp_2 %>% 
  filter(ano >= 2019) %>% 
  group_by(divisao_desc, tipo, ano) %>% 
  count()
```

## Cruzamento de variáveis com sumário estatístico

Não precisamos trabalhar apenas com contagens ao combinarmos duas ou mais variáveis em um agrupamento. Novamente, substituindo `count()` por `summarise()` com uma função de estatística descritiva alteramos o conteúdo da célula. Veja o exemplo com a média do valor:

``` r
piesp_2 %>% 
  group_by(divisao_desc, tipo) %>% 
  summarise(media_valor = mean(valor, na.rm = T))
```

Podemos criar quantas variáveis quiser dentro do `summarise()`:

``` r
piesp_2 %>% 
  group_by(divisao_desc, tipo) %>% 
  summarise(media_valor = mean(valor, na.rm = T),
            mediana_valor = median(valor, na.rm = T),
            desvio_padrao_valor = sd(valor, na.rm = T)
  )
```

O pivoteamento da tabela para chegarmos a uma variável na margem funciona do mesmo jeito:

``` r
piesp_2 %>% 
  group_by(divisao_desc, tipo) %>% 
  summarise(media_valor = mean(valor, na.rm = T)) %>% 
  pivot_wider(names_from = tipo,
              values_from = media_valor)
```

No próximo tutorial veremos como produzir tabelas semelhantes utilizando outro pacote que se tornou bastante popular recentemente, `janitor`, e faremos menos uso das combinações `group_by()` + `count()` e `group_by()` + `summarise()`.
