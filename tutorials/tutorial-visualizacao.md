# Visualização de dados com a gramática do `ggplot2`

Em conjunto com a gramática de manipulação de dados do `dplyr`, a gramática de gráficos `ggplot2` é um dos destaques da linguagem R. Além de flexível e aplicável a diversas classes de objetos (data frames, objetos de mapa e redes, por exemplo), a qualidade dos gráficos é excepcionalmente boa.

Existe uma forte ligação entre a gramática de `dplyr` e a gramática de `ggplot2`: toda a informação para o nosso gráfico vem de um data frame; cada linha em nosso data frame é uma "unidade" a ser exibida no gráfico, e cada coluna em nosso data frame é uma variável que determina um aspecto visual específico do gráfico, incluindo posição, cor, tamanho e forma.

Neste tutorial vamos priorizar a compreensão da estrutura do código para produzir gráficos com `ggplot2` a partir de alguns exemplos simples e propositalmente não cobriremos todas as (inúmeras) possibilidades de visualização.

Você verá, depois de um punhado de gráficos, que a estrutura pouco muda de um tipo de gráfico a outro. Quando precisar de um "tipo" novo de gráfico, ou, como denominaremos a partir de agora, de uma _nova geometria_, bastará aprender mais uma linha de código a ser adicionada ao final de um código já conhecido.

## Registro Civil: óbitos em 2021

Na primeira parte deste tutorial vamos trabalhar com dados de óbitos de 2021 do Registro Civil do estado de São Paulo, produzidos pela Fundação SEADE, já utilizados anteriormente.

Começamos carregando os pacotes que utilizaremos. Note que o `ggplot2` é parte do `tidyverse`, então não é preciso carregá-lo diretamente.

``` r
library(tidyverse)
library(janitor)
```

Vamos abrir e examinar os dados, que estão em formato .csv:

```r
obitos_2021 <- read_csv2("https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/main/data/microdados_obitos2021.csv")

obitos_2021 %>% 
  glimpse()
```

Em seguida, utilizamos funções dos pacotes `janitor` e `dplyr` para prepará-los. Além de limpar os nomes, vamos transformar idade em variável numérica e recodificar sexo e raça/cor, transformando-as em "factor". Finalmente, vamos eliminar idades com código "999": 

``` r
obitos_2021 <- obitos_2021 %>% 
  clean_names() %>% 
  mutate(idadeanos = as.numeric(idadeanos),
         sexo_f = recode_factor(sexo,
                                'F' = 'Feminino',
                                'M' = 'Masculino',                  
                                'I' = 'Ignorado'),
         racacor_f = recode_factor(racacor,
                                   '1' = 'Branca',
                                   '2' = 'Preta',                  
                                   '3' = 'Amarela',
                                   '4' = 'Parda',
                                   '5' = 'Indígena',
                                   '9' = 'Ignorada')) %>% 
  filter(idadeanos != 999)
```

Começaremos conhecendo a _distribuição de óbitos por raça/cor_ no Registro Civil de 2021. Veja como apresentar essa informação com o pacote `ggplot2`:

``` r
ggplot(obitos_2021) +
  geom_bar(aes(racacor_f))
```

O código é bastante estranho, não? Vamos olhar cada uma de suas partes.

Comecemos pela primeira linha. A principal função do código é, como era de se esperar, `ggplot()` (sem o 2 mesmo). Note que não estamos fazendo uma atribuição, por enquanto, pois queremos apenas "imprimir" o gráfico (não no Console, mas aba **Plots** -- ao lado de **Files** e **Help**), e não guardá-lo como objeto.

O argumento da função `ggplot()` é `data`, ou seja, o objeto que contém os dados a serem visualizados. No nosso caso, é o data frame `obitos_2021`.

Podemos colocar os dados no início do nosso código como "pipe"" (`%>%`) para não precisar inseri-lo dentro da função `ggplot()`. Você verá que isso será bem útil num futuro breve.

``` r
obitos_2021 %>% 
  ggplot() +
  geom_bar(aes(racacor_f))
```

Ao usarmos a função `ggplot()` iniciamos um gráfico sem conteúdo, por enquanto.

Para adicionarmos uma geometria, colocamos um símbolo de `+` após fecharmos o parêntesis da função `ggplot()`. Cada `+` nos permite adicionar mais uma camada em nosso gráfico. 

Mas qual camada? Nós definimos um gráfico por sua _geometria_ - o tipo de representação visual dos nossos dados que queremos. `geom_bar` indica que queremos uma geometria de barras, como um "bar chart" em editores de planilha.

A escolha da geometria depende do tipo de dados que você deseja visualizar em seu data frame. Como analisamos a distribuição de óbitos pela variável raça/cor, que é discreta ("factor"), utilizamos uma geometria adequada a dados discretos. A lógica de um gráfico de barras é representar a contagem de cada categoria discreta, então faz sentido usar a geometria `geom_bar`. Veremos exemplos de outras geometrias que correspondam a outros dados abaixo.

Na linha de código da geometria, as 3 letrinhas `aes()` causam estranheza. `aes()` é a abreviação de _aesthetics_. Aqui definiremos quais variáveis de nosso data frame farão parte do gráfico. Estamos trabalhando por enquanto com apenas uma variável, representada no eixo horizontal, ou eixo "x". Por esta razão preenchemos o parâmetro `x` da _aesthetics_ e nada mais.

## Gráficos com uma variável contínua - Gráficos de histogramas

Vamos trabalhar agora com uma variável numérica, idade em anos, alterando o valor de `x` dentro de _aesthetics_ (`aes`).

Precisamos mudar a geometria - o equivalente de um gráfico de barras para variáveis contínuas é um histograma, então usamos `geom_histogram()`.

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos))
```

Faz mais sentido? Espero que sim. Compare os dois códigos acima com calma e compreenda as diferenças. Note que o _tipo de variável que demanda a geometria a ser escolhida_, e não contrário.

### Parâmetros fixos 

As geometrias, cada uma com sua utilidade, também têm parâmetros que podem ser alterados. Por exemplo, as barras do histograma que acabamos de produzir são muito "fininhas". Vamos aumentar sua largura, ou seja, vamos representar mais valores do eixo "x" em cada barra do histograma:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos), binwidth = 5)
```

Uma observação importante aqui: o `binwidth` é especificado _fora_ do `aes()`. Por quê? 

Existe uma regra importante no `ggplot2`: parâmetros que dependem de nossos dados devem ficar dentro de `aes()`; parâmetros fixos, que não dependem de nossos dados, devem ficar fora do `aes()`. 

Então, em nosso código, temos dentro de `aes()` uma variável, idade em anos, e fora de `aes()` um número que independe dos dados, 5. 

O gráfico está muito cinza. Se quisemos mudar algumas cores, onde vamos especificar novos parâmetros de cores? Como as cores são fixas para todo o gráfico e não depende de nossos dados, inserimos o parâmetro fora de `aes()`.

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos), 
                 binwidth = 5,
                 color = 'orange',
                 fill = 'green')
```

Melhor, não? _Certamente não!_ Mas note que podemos trocar os contornos das barras e seu preenchimento. Em geral, os argumentos `color` e `fill` servem a várias geometrias. Faça o teste e mude os nomes das cores para ver como fica (lembre-se que os nomes das cores precisam ser em inglês: red, blue, purple, yellow, etc).

Curiosidade: R aceita as duas grafias em inglês para a palavra cor, "colour" (britânico) e "color" (norte-americano).

## Gráficos com uma variável contínua - Gráficos de densidade

Histogramas são normalmente bastante adequados para variáveis numéricas com valores bastante espaçados, como é o caso de variáveis discretas numéricas (valores inteiros apenas, como acontece com anos inteiros ou número de televisores em um residência).

Uma alternativa mais elegante ao histograma, e convencionalmente utilizada para variáveis verdadeiramente contínuas, são os gráficos de densidade. Vamos, assim, apenas alterar a geometria para a mesma variável, **idadeanos**, e observar novamente sua distribuição. A lição é que, embora a geometria deva corresponder ao tipo de dado, existem várias geometrias que podem funcionar para um tipo de dado específico (histograma ou densidade, por exemplo).

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos))
```

Lindo, mas ainda cinza demais. Vamos adicionar cor à borda (`color`):

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'darkblue')
```

Melhor (?), mas ainda muito branco. Vamos adicionar cor ao interior da curva (`fill`):

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               fill = 'darkblue')
```

Muito pior. E se deixássemos a curva mais "transparente" (`alpha`)?

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) 
```

Agora sim melhorou. Mas nos falta uma referência para facilitar a leitura do gráfico. Por exemplo, seria legal adicionar uma linha vertical que indicasse onde está a moda da distribuição. Vamos calcular a moda:

``` r
obitos_2021 %>% 
    tabyl(idadeanos) %>% 
    filter(n == max(n))
```

Estamos tratando de curvas de densidade, não estamos? Nessa geometria não há possibilidade de representar valores com uma linha vertical. Vamos, então, adicionar uma nova geometria, com uma _aesthetics_ própria, com novos dados (no caso, um valor único), ao gráfico que já havíamos construído:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) +
  geom_vline(aes(xintercept = 74))
```

Veja que, com `ggplot2` podemos adicionar novas geometrias e dados sempre que precisarmos. Agora, temos duas camadas e duas geometrias. É por esta razão que a estrutura do código deste pacote difere tanto da estrutura para gráficos no pacote `base`. A flexibilidade para adicionar geometrias (usando ou não os dados inicialmente apontados) é uma das grandes vantagens do `ggplot2`.

Para tornarmos o gráfico mais interessante, vamos alterar a forma e a cor da linha adicionada no gráfico anterior:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) +
  geom_vline(aes(xintercept = 74),
             linetype = "dashed",
             color = "red")
```

`linetype` é outro parâmetro comum a diversas geometrias (obviamente, as geometrias de linhas).

Dica: cuidado para não usar o pipe (`%>%`) no lugar de `+` ao construir gráficos (esse é um deslize comum inclusive entre programadoras e programadores experientes). O pipe serve para aplicar uma nova função ao resultado produzido na linha anterior. O + serve para adicionar um novo aspecto estético dentro de um gráfico produzido com a função `ggplot()`.

## Gráficos com uma variável contínua e uma variável discreta

Vamos dar alguns passos para trás e retornar aos histogramas. E se quisermos comparar as distribuições de idade por sexo ou raça/cor, por exemplo? Precisamos filtrar os dados e fazer um gráfico para cada categoria de sexo?

Poderíamos. Mas mais interessante é comparar as distribuições em um mesmo gráfico. Para fazer isso, precisamos saber como visualizar duas variáveis do nosso data frame ao mesmo tempo. Como estamos separando uma distribuição de uma variável contínua (idade em anos) em duas, a partir de uma segunda variável discreta (sexo), precisamos adicionar essa nova variável à "aesthetics". Veja como:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos,
                     fill = sexo),
                 binwidth = 5)
```

Observe que adicionamos o parâmetro `fill` à _aesthetics_, ou seja, dentro do `aes()` porque ele depende de nossos dados. Isso significa que a variável sexo separará as distribuições de idade em cores de preenchimento diferentes. Conseguem ver as duas distribuições, uma atrás da outra? Note que agora temos uma legenda.

A sobreposição dos dois histogramas dificulta a visualização de todos os dados. Podemos ajustar como os dois conjuntos de dados são exibidos um em cima do outro com o argumento `position`. Por exemplo, com `position = "dodge"` podemos organizar os dados lado a lado:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos,
                     fill = sexo),
                 binwidth = 5,
                 position = "dodge")
```

Um pouco melhor?

Vamos tentar algo semelhante com as curvas de densidade. Em vez de `fill`, vamos usar a variável sexo em `color` na "aesthetics" (dentro de `aes()`, desta vez) e separar as distribuições por cores de borda:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo)) 
```

Muito bom! Como estamos trabalhando com densidades (cuja área sob a curva é sempre igual a 1), categorias com poucas observações, como sexo "Ignorado", ganham o mesmo destaque que as demais. Se quiseremos excluir o sexo "Ignorado" na variável **sexo_f**, não precisamos alterar os dados. Basta incluir um `filter()` logo antes da função `ggplot()` e utilizar o pipe (`%>%`):

``` r
obitos_2021 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo)) 
```

Mesmo quando precisamos "remodelar" os dados para produzir um novo gráfico, não precisamos criar um novo data frame. Basta fazer todas as modificações necessárias com os verbos do `dplyr` e emendar, com o pipe, a função `ggplot()`.

Vamos adicionar cores no preenchimnento das curvas com `fill` para melhorar nosso gráfico:

``` r
obitos_2021 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo,
                   fill = sexo)) 
```

Não ficou muito bom. Mas pode melhorar. Com o parâmetro `alpha` podemos deixar as distribuições mais "transparentes" e observar as áreas nas quais se sobrepõem:

``` r
obitos_2021 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo,
                   fill = sexo),
               alpha = 0.5) 
```

Que belezura de gráfico! A comparação de distribuições de uma variável contínua por uma variável discreta (aqui binária  - duas categorias) é uma das mais úteis em ciência, pois é exatamente a forma gráfica de testes de hipóteses clássico. Quem têm mais expectativa de vida, homens ou mulheres? Com o gráfico acima fica fácil responder.

## Gráficos com uma variável contínua e uma variável discreta - Gráficos de boxplot

Vamos repetir o gráfico acima, mas, em vez de separarmos as distribuições por sexo, vamos separar por uma variável com mais categorias: raça/cor.

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos, 
                   fill = racacor_f, 
                   color = racacor_f), 
               alpha = 0.5)
```

Dá par comparar as distribuições de idade por grupo? Certamente não. Podemos ter alguma ideia das diferenças, mas o gráfico é poluído demais.

Uma alternativa sintética para representar distribuições de variáveis numéricas é utilizar boxplot. Vamos ver um exemplo que serve de alternativa ao gráfico anterior.

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f))
```

Nota: na nova _aesthetics_ temos agora `x`, eixo horizontal, e `y`, eixo vertical.

Há quem prefira a geometria "de violino" ao boxplot:

``` r
obitos_2021 %>% 
  ggplot() + 
  geom_violin(aes(x = racacor_f, 
                  y = idadeanos,
                  fill = racacor_f))
```

A leitura do gráfico boxplot não é tão confortável por conta do ordenamento das categorias de raça/cor. Existe um pacote do `tidyverse` chamado `forcats()` apenas para lidar com "factors". Uma função útil deste pacote é `fct_reorder()`, que serve para reordenar factors a partir de uma estatística (no caso abaixo, mediana) de uma segunda variável (idade, no exemplo):

``` r
obitos_2021 %>% 
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f))
```

Ainda que com perda de informação, nessas duas geometrias conseguimos compara as distribuições de idade por raça/cor de forma bastante rápida. A mediana da idade das pessoas amarelas é maior que a de pessoas pardas, e a variação amplitude entre indígenas é grande, indicando mais óbitos infantis no grupo.

## Gráficos com uma variável contínua e duas variáveis discretas

Já vimos que sexo afeta bastante a distribuição das idades. Vamos adicionar, então, uma terceira variável na nossa análise. Vamos eliminar sexo e raça/cor ignorados:

``` r
obitos_2021 %>% 
  filter(sexo_f != 'Ignorado') %>%
  filter(racacor_f != 'Ignorada') %>%
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f)) +
  facet_wrap(.~sexo_f)
```

`facet_wrap()` é uma função que separa o gráfico por uma variável discreta. Pode ser usada em qualquer geometria e é extremamente útil.

Temos agora um gráfico bastante elucidativo. Vamos inserir alguns aspectos estéticos com os quais ainda não lidamos: título, legenda, nomes dos eixos, etc. Nesse tutorial daremos pouca atenção a estes aspectos não diretamente relacionados à geometria, deixados para leitura complementar indicada no roteiro:

``` r
obitos_2021 %>% 
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
    subtitle = 'Registro Civil 2021',
    caption = 'Fonte: SEADE',
    y = 'Idade (anos)',
    x = '') +
  theme(legend.position = 'none')
```

Veja que esta não é a única maneira de combinar as três variáveis. Se invertemos os papéis de sexo e raça/cor no código, temos o seguinte gráfico, que destaca a comparação entre sexos dentro de cada grupo de raça/cor:

``` r
obitos_2021 %>% 
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
    subtitle = 'Registro Civil 2021',
    caption = 'Fonte: SEADE',
    y = 'Idade (anos)',
    x = '') +
  theme(legend.position = 'none')
```

## Registro Civil: nascidos vivos em 2017

Em matemática e a estatística somos frequentemente apresentados a variáveis contínuas. O mundo social, no entanto, é povoado por variáveis discretas. A seguir, vamos trabalhar com geometrias para duas variáveis contínuas, e portanto precisaremos de outra fonte de dados, pois o conjunto de óbitos de 2021 não tem um par de variáveis contínuas adequado ao que faremos.

No lugar de óbitos, utilizaremos a base de nascidos vivos de 2017 do Registro Civil, também do SEADE. Repitamos o ritual para dados em formato .csv:

``` r
nv_2017 <- read_csv2("https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/main/data/nv_2017.csv")

glimpse(nv_2017)
```

Limpando nomes, transformando variáveis de interesse em numéricas (foram importadas como 'character') ou recodificando, e filtrando códigos numéricos utilizados para missing:

``` r
nv_2017 <- nv_2017 %>% 
  clean_names() %>% 
  mutate(peso = as.numeric(peso),
         idademae = as.numeric(idademae),
         idadepai = as.numeric(idadepai),
         sexo_f = recode_factor(sexo,
                                'F' = 'Feminino',
                                'M' = 'Masculino',                  
                                'I' = 'Ignorado')) %>% 
  filter(peso != 9999,
         idademae != 99,
         idadepai != 99,
         sexo != 'Ignorado') 
```

A essa altura do campeonato, você provavelmente consegue ler em R e saber as transformações que foram feitas nos dados.

## Gráficos de duas variáveis contínuas

Até agora trabalhamos com distribuições de uma única variável ou com a distribuição conjunta de uma variável numérica (contínua) por outra discreta (em outras palavras, separados a distribuição de uma variável em várias a partir de um variável categórica).

Como relacionar graficamente duas variáveis contínuas? O padrão é o uso da geometria de gráfico de dispersão, que apresenta cada par de informações como uma coordenada no espaço bidimensional. 

Vejamos um exemplo com idade da mãe em anos (eixo horizontal) e peso em gramas no nascimento (eixo vertical) usando a geometria `geom_point`. Como temos centenas de milhares observações, vamos produzir os gráficos com uma amostra de tamanho 100, gerada com a função `slice_sample()`, e armazenada no objeto `nv_2017_s`. E para garantir que todo mundo tenha a mesma amostra, vamos escolher o _seed_ (ponto de partida) do gerador de números aleatórios com a função `set.seed()` e um número qualquer fixado (que deve ser o mesmo para todos):

``` r
set.seed(3599999)

nv_2017_s <- 
  nv_2017 %>% 
  slice_sample(n = 100)
```

Finalmente, nosso primeiro exemplo de gráfico de dispersão:

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                y = peso)) 
```

Você consegue ler este gráfico? Cada ponto representa um indivíduo, ou seja, posiciona no espaço o par (idade da mãe, peso) daquele indivíduo.

Há alguma tendência nos dados? Podemos representar essa relação entre as variáveis com modelos lineares e não lineares. A geometria `geom_smooth()` cumpre esse papel.

Para utilizá-la, precisamos definir qual é o método (parâmetro `method`) para modelar os dados. O mais convencional é representar a relação entre as variáveis como reta: um _linear model_ (modelo linear) que é representado por `lm`. Veja o exemplo (ignore o parâmetro `se` por enquanto):

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso)) +
  geom_smooth(aes(x = idademae, 
                y = peso), 
            method = "lm", 
            se = FALSE)
```

Legal, não? Se retirarmos o parâmetro `se`, ou voltarmos seu valor para o padrão `TRUE`, obteremos também o intervalo de confiança (95%) da reta que inserimos.

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso)) +
  geom_smooth(aes(x = idademae, 
                  y = peso), 
              method = "lm")
```

Modelos de regressão, lineares ou não, estão fora do escopo deste curso. Tente apenas interpretar o resultado gráfico.

A alternativa não-linear para representar a relação ao dados mais utilizada com essa geometria é o método "loess" (local weighted regression). Veja o resultado:

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso)) +
  geom_smooth(aes(x = idademae, 
                  y = peso), 
              method = "loess")
```

## Gráficos de três ou mais variáveis

Em geral, estamos limitados por papel e telas bidimensionais para exibir apenas geometrias de duas variáveis. Mas existe um truque que podemos usar para mostrar mais informações: incluir os outros parâmetros de uma geometria, tais como cores, tamanhos e formas, dentro de `aes()` com uma variável terceira variável em seu data frame. 

Se, por exemplo, queremos representar uma terceira variável numérica, podemos colocá-la como tamanho dos pontos (raio do círculo, com o argumento `size`). Por exemplo, a idade do pai poderia ser adicionada da seguinte forma:

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 size = idadepai)) +
  theme(legend.position = 'bottom')
```

Se em vez de alterarmos o tamanho dos pontos por uma variável numérica quisermos alterar sua cor (com o argumento `color`) ou forma dos pontos com base em uma variável categória (sexo, por exemplo), fazemos, respectivamente:

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 color = sexo)) +
  theme(legend.position = 'bottom')
```

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 shape = sexo)) +
  theme(legend.position = 'bottom')
```

Nota: cada símbolo é representado por um número e uma lista deles está no [_Cheat Sheet_ do `ggplot2`](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf). 

Agora, alteramos _simultaneamente_ cor (`color`) e forma (`shape`):

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 color = sexo,
                 shape = sexo)) +
  theme(legend.position = 'bottom')
```

E ainda, adicionamos uma reta de regressão para cada categoria de sexo:

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 color = sexo,
                 shape = sexo)) +
  theme(legend.position = 'bottom') +
  geom_smooth(aes(x = idademae, 
                y = peso, 
                color = sexo), 
            method = "lm", 
            se = F)
```

Lindo, não?

Existe mais um outro jeito de mostrar mais de duas variáveis -- podemos criar vários gráficos organizados em uma grade sem ter que repetir nosso código toda vez. 

Como fazer isso? Com `facet_wrap()`. Veja um exemplo:

``` r
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 color = sexo))  +
  facet_wrap(~sexo) +
  geom_smooth(aes(x = idademae, 
                y = peso, 
                color = sexo), 
            method = "lm", 
            se = F)
```

Encerramos aqui essa breve exposição ao pacote `ggplot2` e vimos apenas uma parte pequena de suas funcionalidades. Se quiser aprender mais, procure os livros sobre o pacote na bibliografia indicada do curso.
