# Visualização de dados com a gramática do _ggplot2_

Em conjunto com a gramática de manipulação de dados do _dplyr_, a gramática de gráficos _ggplot2_ é um dos destaques da linguagem R. Além de flexível e aplicável a diversas classes de objetos (data frames, objetos de mapa e redes, por exemplo), a qualidade dos gráficos é excepcionalmente boa.

Existe uma forte ligação entre a gramática de _dplyr_ e a gramática de _ggplot2_: toda a informação para o nosso gráfico vem de um data frame; cada linha em nosso data frame é uma 'unidade' a ser exibida no gráfico, e cada coluna em nosso data frame é uma variável que determina um aspecto visual específico do gráfico, incluindo posição, cor, tamanho e forma.

Neste tutorial vamos priorizar a compreensão da estrutura do código para produzir gráficos com _ggplot2_ a partir de alguns exemplos simples e propositalmente não cobriremos todas as (inúmeras) possibilidades de visualização.

Você verá, depois de um punhado de gráficos, que a estrutura pouco muda de um tipo de gráfico a outro. Quando precisar de um "tipo" novo de gráfico, ou, como denominaremos a partir de agora, de uma nova geometria, bastará aprender mais uma linha de código a ser adicionada ao final de um código já conhecido.

## Registro Civil: óbitos em 2018

Na primeira parte deste tutorial vamos trabalhar com dados de óbitos de 2018 do Registro Civil (SEADE), os mesmos que utilizamos anteriormente.

Vamos começar carregando os pacotes que utilizaremos. Note que o _ggplot2_ é parte do _tidyverse_ e não precisamos carregá-lo diretamente.

```{r}
library(tidyverse)
library(readxl)
library(janitor)
```

Vamos abrir os dados, que estão em formato .xlsx:

```{r}
obitos_2018_url <- 'http://www.seade.gov.br/produtos/midia/2020/02/DO2018.xlsx'
download.file(obitos_2018_url, 'obitos_2018.xlsx')
obitos_2018 <- read_excel('obitos_2018.xlsx')
```

Examinar:

```{r}
obitos_2018 %>% 
  glimpse()
```

E utilizar os pacotes _janitor_ e _dplyr_ para prepará-los:

```{r}
obitos_2018 <- obitos_2018 %>% 
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

Além de limpar os nomes, vamos transformar idade em variável numérica e recodificar sexo e raça/cor, transformando-as em factor. Finalmente, vamos eliminar idades com código '999'.

Começaremos conhecendo a distribuição de óbitos por raça/cor no Registro Civil de 2018. Veja como apresentar essa informação com o pacote _ggplot2_:

```{r}
ggplot(obitos_2018) +
  geom_bar(aes(racacor_f))
```

O código é bastante estranho, não? Vamos olhar cada uma de suas partes.

Comecemos pela primeira linha. A principal função do código é, como era de se esperar, _ggplot_ (sem o 2 mesmo). Note que não estamos fazendo uma atribuição, por enquanto, pois queremos apenas "imprimir" o gráfico (não no console, mas aba 'Plots'), e não guardá-lo como objeto.

O argumento da função _ggplot_ é "data", ou seja, o objeto que contém os dados a serem visualizados. No nosso caso, é o data frame _obitos_2018_.

Podemos colocar os dados no início do nosso código como 'pipe' (%>%) para não precisar inserí-lo dentro da função _ggplot_. Você verá que isso será bem útil num futuro breve.

```{r}
obitos_2018 %>% 
  ggplot() +
  geom_bar(aes(racacor_f))
```

Ao usarmos a função _ggplot_ iniciamos um gráfico sem conteúdo, por enquanto.

Para adicionarmos uma geometria, colocamos um símbolo de "+" após fecharmos o parêntesis da função _ggplot_. Cada "+" nos permite adicionar mais uma camada em nosso gráfico. Mas qual camada? Nós definimos um gráfico por sua _geometria_ - o tipo de representação visual dos nossos dados que queremos. _geom\_bar_ indica que queremos uma geometria de barras, como um 'bar chart' em editores de planilha.

A escolha da geometria depende do tipo de dados que você deseja visualizar de seu dados frame. Como analisamos a distribuição de óbitos pela variável raça/cor, que é discreta (_factor_), utilizamos uma geometria adequada a dados discretos. A lógica de um gráfico de barras é representar a contagem de cada categoria discreta, então faz sentido usar a geometria _geom\_bar_. Vamos ver exemplos de outras geometrias que corespondam a outros dados abaixo.

Na linha de código da geometria, as 3 letrinhas "aes" causam estranheza. "aes" é a abreviação de "aesthetics". Aqui definiremos quais variáveis de nosso data frame farão parte do gráfico. Estamos trabalhando por enquanto com apenas uma variável, representada no eixo horizontal, ou eixo "x". Por esta razão preenchemos o parâmetro "x" da "aesthetics" e nada mais.

## Gráficos com uma variável contínua - Gráficos de histogramas

Vamos trabalhar agora com uma variável numérica, idade em anos, alterando o valor de "x" dentro de "aesthetics".

Precisamos mudar o geometria - o equivalente de um gráfico de barras para variáveis contínuas é um histograma, então usamos _geom\_histogram_.

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos))
```

Faz mais sentido? Espero que sim. Compare os dois códigos acima com calma e compreenda as diferenças. Note que o tipo de variável que demanda a geometria a ser escolhida, e não contrário.

### Parâmetros fixos 

As geometrias, cada uma com sua utilidade, também têm parâmetros que podem ser alterados. Por exemplo, as barras do histograma que acabamos de produzir são muito "fininhas". Vamos aumentar sua largura, ou seja, vamos representar mais valores do eixo "x" em cada barra do histograma:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos), binwidth = 5)
```

Uma observação importante aqui: o _binwidth_ é especificado _fora_ do _aes()_. Por que? Porque existe uma regra importante no _ggplot2_: parâmetros que dependem de nossos dados devem ficar dentro de _aes()_; parâmetros fixos, que não dependem de nossos dados, devem ficar fora do _aes()_. Então, em nosso código, temos dentro de _aes()_ uma variável, idade em anos, e fora de _aes()_ um número que independe dos dados, 5. 

O gráfico está muito cinza. Se quisemos mudar algumas cores, onde vamos especificar novos parâmetros de cores? Como as cores são fixas para todo o gráfico e não depende de nossos dados, inserimos o parâmetro fora de _aes()_.

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos), 
                 binwidth = 5,
                 color = 'orange',
                 fill = 'green')
```

Melhor, não? Certamente não! Mas note que podemos trocar as contornos das barras e seu preenchimento. Em geral, os argumentos "color" e "fill" servem a várias geometrias.

Curiosidade: R aceita as duas grafias em inglês para a palavra cor, "colour" (britânico) e "color" (americano).

## Gráficos com uma variável contínua - Gráficos de densidade

Histogramas são normalmente bastante adequados para variáveis numéricas com valores bastante espaçados, como é o caso de variáveis discretas numéricas (valores inteiros apenas, como acontece com anos inteiros ou número de televisores em um residência).

Uma alternativa mais elegante ao histograma, e convencionalmente utilizada para variáveis verdadeiramente contínuas, são os gráficos de densidade. Vamos, assim, apenas alterar a geometria para a mesma variável, idadeanos, e observar novamente sua distribuição. A lição é que, embora a geometria deva corresponder ao tipo de dados, existem várias geometrias que podem funcionar para um tipo de dado específico (histogram ou densidade, por exemplo).

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos))
```

Lindo, mas ainda cinza demais. Vamos adicionar cor à borda:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'darkblue')
```

Melhor (melhor?), mas ainda muito branco. Vamos adicionar cor ao interior da curva:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'darkblue')
```

Muito pior. E se deixássemos a curva mais "transparente"?

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) 
```

Agora sim melhorou. Mas nos falta uma referência para facilitar a leitura do gráfico. Por exemplo, seria legal adicionar uma linha vertical que indicasse onde está a moda da distribuição. Vamos calcular a moda:

```{r}
obitos_2018 %>% 
    tabyl(idadeanos) %>% 
    filter(n == max(n))
```

Estamos tratando de curvas de densidade, não estamos? Nessa geometria não há possibilidade de representar valores com uma linha vertical. Vamos, então, adicionar uma nova geometria, com uma "aesthetics" própria, com novos dados (no caso, um valor único), ao gráfico que já havíamos construído:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) +
  geom_vline(aes(xintercept = 82))
```

Veja que, com _ggplot2_ podemos adicionar novas geometrias e dados sempre que precisarmos. Agora, temos duas camadas e duas geometrias. É por esta razão que a estrutura do código deste pacote difere tanto da estrutura para gráficos no pacote base. A flexibilidade para adicionar geometrias (usando ou não os dados inicialmente apontados) é uma das vantagens do _ggplot2_.

Para tornarmos o gráfico mais interessante, vamos alterar a forma e a cor da linha adicionada no gráfico anterior:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos),
               color = 'blue',
               fill = 'blue',
               alpha = 0.2) +
  geom_vline(aes(xintercept = 82),
             linetype = "dashed",
             color = "red")
```

"linetype" é outro parâmetro comum a diversas geometrias (obviamente, as geometrias de linhas).

Dica: cuidado para não usar o pipe (%>%) no lugar de + ao construir gráficos (esse é um deslize comum inclusive entre programadoras e programadores experientes). O pipe serve para aplicar uma nova função ao resultado produzido na linha anterior. O + serve para adicionar um novo aspecto estético dentro de um gráfico produzido com a função _ggplot_.

## Gráficos com uma variável contínua e uma variável discreta

Vamos dar alguns passos para traz e retornar aos histogramas. E se quisermos comparar as distribuições de idade por sexo ou raça/cor, por exemplo? Precisamos filtrar os dados e fazer um gráfico para cada categoria de sexo?

Poderíamos. Mas mais interessante é comparar as distribuições em um mesmo gráfico. Para fazer isso, precisamos saber como visualizar duas variáveis do nosso data frame ao mesmo tempo. Como estamos separando uma distribuição de uma variável contínua (idade em anos) em duas, a partir de uma segunda variável discreta (sexo), precisamos adicionar essa nova variável à "aesthetics". Veja como:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos,
                     fill = sexo),
                 binwidth = 5)
```

Observe que adicionamos o parâmetro "fill" à "aesthetics" (dentro do _aes()_ porque ele depende de nossos dados). Isso significa que a variável sexo separará as distribuições de idade em cores de preenchimento diferentes. Conseguem ver as duas distribuições, uma atrás da outra? Note que agora temos uma legenda.

A sobreposição dos dois histogramas dificulta a visualização de todos os dados. Podemos ajustar como os dois conjuntos de dados são exibidos um em cima do outro com o argumento 'position'. Por exemplo, com _position="dodge"_ podemos organizar os dados lado a lado:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_histogram(aes(x = idadeanos,
                     fill = sexo),
                 binwidth = 5,
                 position = "dodge")
```

Um pouco melhor?

Vamos tentar algo semelhante com as curvas de densidade. Em vez de "fill", vamos usar a variável sexo em "color" na "aesthetics" (dentro da 'aes', desta vez) e separar as distribuições por cores de borda:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo)) 
```

Muito bom! Como estamos trabalhando com densidades (cuja área sob a curva é sempre 1), categorias com poucas observações, como sexo 'Ignorado', ganham o mesmo destaque que as demais. Se quiseremos excluir o sexo 'Ignorado' na variável 'sexo_f', não precisamos alterar os dados. Basta incluir um _filter_ logo antes da função _ggplot_ e utilizar o 'pipe':

```{r}
obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo)) 
```

Mesmo quando precisamos 'remodelar' os dados para produzir um novo gráfico, não precisamos criar um novo data frame. Basta fazer todas as modificações necessárias com os verbos do _dplyr_ e emendar, como pipe, a função _ggplot_.

Vamos adicionar cores no preenchimnento das curcas com "fill" para melhorar nosso gráfico:

```{r}
obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo,
                   fill = sexo)) 
```

Não ficou muito bom. Mas pode melhorar. Com o parâmetro "alpha", que já usamos no passado, podemos deixar as distribuições mais "transparentes" e observar as áreas nas quais se sobrepõem:

```{r}
obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos,
                   color = sexo,
                   fill = sexo),
               alpha = 0.5) 
```

Que belezura de gráfico! A comparação de distribuições de uma variável contínua por uma variável discreta (aqui binária  - duas categorias) é uma das mais úteis em ciência, pois é exatamente a forma gráfica de testes de hipóteses clássico. Quem tem mais expectativa de vida, homens ou mulheres? Com os gráficos fica fácil responder.

## Gráficos com uma variável contínua e uma variável discreta - Gráficos de boxplot

Vamos repetir o gráfico acima, mas, em vez de separarmos as distribuições por sexo, vamos separar por uma variável com mais categorias: raça/cor.

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_density(aes(x = idadeanos, 
                   fill = racacor_f, 
                   color = racacor_f), 
               alpha = 0.5)
```

Dá par comparar as distribuições de idade por grupo? Certamente não. Podemos ter alguma ideia das diferenças, mas o gráfico é poluído demais.

Uma alternativa sintética para representar distribuições de variáveis numéricas é utilizar boxplot. Vamos ver um exemplo que serve de alternativa ao gráfico anterior.

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f))
```

Nota: na nova "aesthetics" temos agora "x", eixo horizontal, e "y", eixo vertical.

Há quem prefira a geometria 'de violino' ao boxplot:

```{r}
obitos_2018 %>% 
  ggplot() + 
  geom_violin(aes(x = racacor_f, 
                  y = idadeanos,
                  fill = racacor_f))
```

A leitura do gráfico boxplot não é tão confortável por conta do ordenamento das categorias de raça/cor. Existe um pacote do _tidyverse_ chamado _forcats_ apenas para lidar com factors. E uma função útil deste pacote é _fct\_reorder_, que serve para reordenar factors a partir de uma estatística (no caso abaixo, mediana) de uma segunda variável (idade, no exemplo):

```{r}
obitos_2018 %>% 
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f))
```

Ainda que com perda de informação, nessas duas geometrias conseguimos compara as distribuições de idade por raça/cor de forma bastante rápida. A mediana idade das pessoas amarelas é maior que a de pessoas pardas, e a variação amplitude entre indígenas é grande, indicando mais óbitos infantis no grupo.

## Gráficos com uma variável contínua e duas variáveis discretas

Já vimos que sexo afeta bastante a distribuição das idades. Vamos adicionar, então, uma terceira variável na nossa análise. Vamos eliminar sexo e raça/cor ignorados:

```{r}
obitos_2018 %>% 
  filter(sexo_f != 'Ignorado') %>%
  filter(racacor_f != 'Ignorada') %>%
  mutate(racacor_f = fct_reorder(racacor_f, idadeanos, median)) %>% 
  ggplot() + 
  geom_boxplot(aes(x = racacor_f, 
                   y = idadeanos,
                   fill = racacor_f)) +
  facet_wrap(.~sexo_f)
```

facet\_wrap é uma função que separa o gráfico por uma variável discreta. Pode ser usada em qualquer geometria e é extremamente útil.

Temos agora um gráfico bastante elucidativo. Vamos inserir alguns aspectos estéticos com os quais ainda não lidamos: título, legenda, nomes dos eixos, etc. Nesse tutorial daremos pouca atenção a estes aspectos não diretamente relacionados à geometria, deixados para leitura complementar indicada no roteiro:

```{r}
obitos_2018 %>% 
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
    subtitle = 'Registro Civil 2018',
    caption = 'Fonte: SEADE',
    y = 'Idade (anos)',
    x = '') +
  theme(legend.position = 'none')
```

Veja que esta não é a única maneira de combinar as três variáveis. Se invertemos os papéis de sexo e raça/cor no código, temos o seguinte gráfico, que destaca a comparação entre sexos dentro de cada grupo de raça/cor:

```{r}
obitos_2018 %>% 
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
    subtitle = 'Registro Civil 2018',
    caption = 'Fonte: SEADE',
    y = 'Idade (anos)',
    x = '') +
  theme(legend.position = 'none')
```

## Registro Civil: nascidos vivos em 2017

Em matemática e a estatística somos frequentemente apresentados a variáveis contínuas. O mundo social, no entanto, é povoado por variáveis discretas. Como vamos, a seguir, trabalhar com geometrias para duas variáveis contínuas, precisaremos de outra fonte de dados, pois o conjunto de óbitos de 2018 não tem um par de variáveis contínuas adequado ao que faremos.

Vamos utilizar, no lugar de óbitos, a base de nascidos vivos de 2017 do Registro Civil, também do SEADE. Repitamos o ritual para dados em formato .xlxs:

```{r}
nv_2017_url <- 'http://www.seade.gov.br/produtos/midia/2020/02/DN2017.xlsx'
download.file(nv_2017_url, 'nv_2017.xlsx')
nv_2017 <- read_excel('nv_2017.xlsx')
```

Examinando:

```{r}
glimpse(nv_2017)
```

Limpando nomes, transformando variáveis de interesse em numéricas (foram importadas como 'character') ou recodificando, e filtrando códigos numéricos utilizados para missing:

```{r}
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

Vamos ver agora como relacionar graficamente duas variáveis contínuas. O padrão é usarmos a geometria de gráfico de dispersão, que presenta cada par de informações como uma coordenada no espaço bidimensional. 

Vamos ver um exemplo com idade da mãe em anos (eixo horizontal) e peso em gramas no nascimento (eixo vertical) usando a geometria _geom\_point_. Como temos 606 mil observações, vamos produzir os gráficos com uma amostra de tamanho 100, gerada com a função sample\_n, e armazenada no objeto 'nv_2017_s'. E para garantir que todo mundo tenha a mesma amostra, vamos escolher o 'seed' (ponto de partida) do gerador de números aleatórios com a função 'set.seed' e um número qualquer fixado:

```{r}
set.seed(3599999)

nv_2017_s <- 
  nv_2017 %>% 
  sample_n(100)
```

Finalmente, nosso primeiro exemplo de gráfico de dispersão:

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                y = peso)) 
```

Você consegue ler este gráfico? Cada ponto representa um indivíduo, ou seja, posiciona no espaço o par (idade da mãe, peso) daquele indivíduo.

Há alguma tendência nos dados? Podemos representar essa relação entre as variávaeis com modelos lineares e não lineares. A geometria _geom\_smooth_ cumpre esse papel.

Para utilizá-la, precisamos definir qual é o método (parâmetro "method") para modelar os dados. O mais convencional é representar a relação entre as variáveis como reta: um 'linear model' que é representado por 'lm'. Veja o exemplo (ignore o parâmetro "se" por enquanto):

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso)) +
  geom_smooth(aes(x = idademae, 
                y = peso), 
            method = "lm", 
            se = FALSE)
```

Legal, não? Se retirarmos o parâmetro "se", ou voltarmos seu valor para o padrão "TRUE", obteremos também o intervalo de confiança (95\%) da reta que inserimos.

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso)) +
  geom_smooth(aes(x = idademae, 
                  y = peso), 
              method = "lm")
```

Modelos de regressão, linear ou não, estão bastante fora do escopo deste curso. Tente apenas interpretar o resultado gráfico.

A alternativa não linear para representar a relação ao dados mais utilizada com essa geometria é o método "loess" (local weighted regression). Veja o resultado:

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso)) +
  geom_smooth(aes(x = idademae, 
                  y = peso), 
              method = "loess")
```

## Gráficos de três ou mais variáveis

Em geral, estamos limitados por papel e telas bidimensionais para exibir apenas geometrias de duas variáveis. Mas existe um truque que podemos usar para mostrar mais informações: incluir os outros parâmetros de uma geometria, tais como cores, tamanhos e formas, dentro de _aes_ segundo uma variável terceira variável em seu data.frame. 

Se, por exemplo, queremos representar uma terceira variável numérica, podemos colocá-la como o tamanho dos pontos (raio do círculo). Por exemplo, a idade do pai poderia ser adicionada da seguinte forma:

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 size = idadepai)) +
  theme(legend.position = 'bottom')
```

Se em vez de alterar o tamanho dos pontos por uma variável numérica quisermos alterar sua cor ou forma dos pontos com base em uma variável categória (sexo, por exemplo), fazemos, respectivamente:

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 color = sexo)) +
  theme(legend.position = 'bottom')
```

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 shape = sexo)) +
  theme(legend.position = 'bottom')
```

Nota: cada símbolo é representado por um número e você encontra facilmente no [Cheat Sheet do ggplot2](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf). 

Alterando simultaneamente cor e forma:

```{r}
nv_2017_s %>% 
  ggplot() + 
  geom_point(aes(x = idademae,
                 y = peso,
                 color = sexo,
                 shape = sexo)) +
  theme(legend.position = 'bottom')
```

Adicionando uma reta de regressão para cada categoria de sexo:

```{r}
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

Existe mais um outro jeito de mostrar mais de duas variáveis - podemos criar vários gráficos organizados em uma grade sem ter que repetir nosso código toda vez. Como fazer isso? Com _facet\_wrap_. Veja um exemplo:

```{r}
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