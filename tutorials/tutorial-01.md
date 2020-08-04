# Apresentação

Um dos aspectos mais incríveis da linguagem R é o desenvolvimento de novas funcionalidades pela comunidade de usuárias e usuários. 

Há diversas "gramática para bases de dados", ou seja, formas de importar, organizar, manipular e extrair informações das bases de dados, que foram desenvolvidas ao longo da última década.

A "gramática" mais popular da linguagem é a do no pacote _dplyr_, parte do _tidyverse_. Neste oficina veremos como utilizar algumas das principais funções, ou "verbos", do pacote _dplyr_.

Existem outras formas de se trabalhar com conjuntos de dados mais, digamos, antigas. É comum encontrarmos códigos escritos na "gramática" original da linguagem, que chamaremos de "base" ou "básico".

Podemos pensar na linguagem R como uma língua com diversos dialétos. Os dois dialétos mais falados para manipulação de dados são o "base" e o do pacote _dplyr_.

# Instalando e carregando pacotes no R

Quando você abre R ou RStudio, diversas funções estão disponíveis para uso. Elas são parte do pacote "base", que é carregado automaticamente. "base" é a linguagem tal como ela foi desenhada originalmente.

Se quiseremos utilizar funções de pacotes desenvolvidos na comunidade de R que não sejam parte do "base", precisamos instalar pacotes e carregá-los ao iniciar uma nova seção. Vamos ver como fazer isso.

Em primeiro lugar, vamos instalar um pacote. Começaremos com o tidyverse:

```{r}
install.packages('tidyverse')
```

Pronto. Seu computador (ou seu usuário no servidor RStudio) tem o pacote _tidyverse_ instalado.

Lembre-se de colocar aspas no nome do pacote, pois, até agora, _tidyverse_ é um nome desconhecido para a linguagem R no seu computador. E qualquer texto arbitrário deve vir entre aspas.

A partir da instalação, sempre que queremos utilizar o pacote _tidyverse_ devemos carregá-lo com a função _tidyverse_. Você deve fazer isso toda vez que abrir R.

```{r}
library(tidyverse)
```

Pronto!
  
Antes de avançar, treine com mais outro pacote: _lubridate_, que é um pacote para tratamento de datas e horas. 

# Introdução ao pacote _dplyr_

## Começando pelo meio: data frames

Uma característica distintiva da linguagem de programação R é ter sido desenvolvida para a análise de dados. E quando pensamos em análise de dados, a protagonista do show é a _base de dados_ ou, como vamos conhecer a partir de agora, __data frame__.

Por esta razão, em vez de aprender como fazer aritmética, elaborar funções ou executar loops para repetir tarefas e outros aspectos básicos da linguagem, vamos começar olhando para o R como um software concorrente dos demais utilizados para análise de dados em ciências sociais, como SPSS, Stata, SAS e companhia.

As principais características de um data frame são: (1) cada coluna representa uma variável (ou característica) de um conjunto de observações; (2) cada linha representa uma observação e contém os valores de cada variável para tal observação. Vejamos um exemplo:
  
  | Município             | Área (km2)| População | 
  | --------------------- | ---------:| ---------:|
  | Santo André           |    175,78 |   693.867 | 
  | São Bernardo do Campo |    409,53 |   812.086 | 
  | São Caetano do Sul    |     15,33 |   151.244 | 
  | Diadema               |     30.73 |   404.477 | 
  
Fonte: SEADE

Note que em uma linha os elementos são de tipos de diferentes: na primeira coluna há uma nome (texto), na segunda uma medida de área (números com casa decimais) e na terceira uma contagem (número inteiros). 

Por outro lado, em cada coluna há somente elementos de um tipo. Por exemplo, há apenas números inteiros na coluna população. Colunas são variáveis e por isso aceitam registros de um único tipo. Se você já fez um curso de estatísticas básica ou de métodos quantitativos deve se lembrar que as variáveis são classificadas da seguinte maneira:
  
  1- Discretas

- Nominais, que são categorias (normalmente texto) não ordenadas

- Ordinais, que são categorias (normalmente texto) ordenadas

- Inteiros, ou seja, o conjunto dos números inteiros

2- Contínuas, números que podem assumir valores não inteiros

Se destacamos uma coluna do nosso data frame, temos um __vetor__. Por exemplo, a variável "População" pode ser presentado da seguinte maneira: {693.867, 812.086, 151.244, 404.477}. Um data frame é um conjunto de variáveis (vetores!) dispostos na vertical e combinados um ao lado do outro.

Nota: guarde bem a definição de data frame acima. pois data frame é a principal classe de objetos no uso quotidiano da linguagem. 

Data frame e vetores são __objetos__ na linguagem R. 

Vamos ver como o R representa vetores e data frames na tela. Antes disso, é preciso "abrir" um data frame.

## Pesquisa de Investimentos Anunciados no Estado de São Paulo (PIESP)

Neste primeiro tutorial vamos trabalhar com dados de uma pesquisa a [PIESP](https://www.piesp.seade.gov.br/), que capta anúncios de investimento realizados por empresas públicas e privadas no Estado de São Paulo. Vamos abrir os dados antes e depois examinar do que se trata exatamente.

Os dados estão armazenados em um arquivo de texto no formato .csv (comma separated values), ou seja, em cada linha os dados de cada coluna são separados por ponto e vírgula (;). Outros separadores, como vírgula ou tab são possíveis nesse formato.

## Abrindo dados em R com botão (aaaaaaargh!)

Se você decidiu aprender a programar em R, provavelmente quer substituir a análise de dados com cliques no mouse que fazemos no editor de planilhas pela construção de scripts que documentam o passo a passo da análise. Daqui em diante estaremos num mundo sem botões. Exceto um, por enquanto, aí no canto direito superior chamado "Import Dataset".

Clique no botão (aaaaaaargh!). Veja que temos a opção de importar arquivos de texto com duas bibliotecas diferentes, _base_ e _readr_ (que é o pacote de abertura de dados do _tidyverse_) e dados em alguns outros formatos, como MS Excel e outros softwares de análise estatística.

Use a segunda opção, "From Text (readr)" para carregar os dados da PIESP.

Note que você pode escolher um arquivo na pasta local ou um URL, ou seja, um arquivo que esteja armazenado na web.


## Abrindo dados em R (com script)

(Lembre-se de carregar o pacote _tidyverse_ antes de prosseguir)

```{r}
library(tidyverse)
```

Use o recurso "Import Dataset" enquanto não se sentir confortável com a linguagem. Mas, aos poucos, vá abandonando. Abrir dados em R é muito simples.

Repetindo o procedimento, para abrir os dados da PIESP basta fazer:
  
```{r}
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv')
```

Em R, as funções "read." são as funções de abertura de dados do _base_ e as funções "read_" são as análogas do pacote _readr_, parte do _tidyverse_. Há funções "read" para abrir todos os tipos de dados, de arquivos de texto a páginas em HTML.

No nosso caso, utilizamos a função _read\_csv2_ para abrir um arquivo de texto cujos valores das colunas são separados por ponto e vírgula. Veremos no futuro e com mais calma outras possibilidades para carregar dados em R.

Note que utilizamos o URL dos dados diretamente. Não precisamos fazer download para uma pasta local para depois abrir os dados se os dados estiverem na web.

Um jeito mais confortável, na minha opinião, de fazer a abertura de dados com um URL é guardar o URL em um objeto de texto e, depois, utilizar esse objeto como input da função. O resultado é idêntico e você pode testar se quiser.
  
```{r}
url_piesp <- "https://raw.githubusercontent.com/seade-R/programacao-r/master/data/piesp.csv"
piesp <- read_csv2(url_piesp)
```

Note que, pela segunda vez, utilizamos o símbolo "<-". Ele é um símbolo de atribuição, e é um das marcas mais importantes da linguagem. Atribuir, significa "guardar na memória com um nome". O nome, é o que vai do lado esquerdo. A parte do lado direito da equação de atribuição é o objeto a ser guardado.

Você pode usar "=" no lugar de "<-". Mas, aviso desde já, há casos em que há ambiguidade e os símbolos não funcionam como esperado.

Vamos avançar.

### Nossos dados são objetos

Ao utilizarmos o símbolo de atribuição criamos um _objeto_. R é uma linguagem voltada a objetos e, basicamente, tudo que você armazenar na memória do computador é um objeto.

O 'importarmos' os dados da PIESP criamos um objeto com um nome arbitrário (escolhemos 'piesp' para facilitar) em nosso ambiente. Na aba 'Environment' do RStudio podemos visualizar todos os objetos existentes. 'piesp' está lá, com alguma informação sobre o que é e qual é o seu tamanho. Dê um clique (aaaaaaargh!) no botão azul ao lado do nome do objeto conseguimos ver um pouco de sua estrutura.

### Explorando sem olhar para a matriz de dados

No editor de planilhas estamos acostumados a ver os dados, célula a célula. Mas será que é realmente útil ficar olhando para os dados? Você perceberá com o tempo que olhar os dados é desnecessário e até contraproducente.

Você pode ver os dados clicando (aaaaaaargh!) no nome do objeto que está no "Environment" ou utilizando a função _View_ (cuidado, o "V" é maiúsculo, algo raro em nomes de funções de R).

```{r}
View(piesp)
```

Ao lado da aba do script no qual você está trabalhando aparecerá uma aba com a matriz de dados da PIESP. Vamos aproveitar para entender o que são esses dados.

O SEADE disponibiliza a informação detalhada de todos os investimentos anunciados por empresas privadas em públicas de São Paulo (1) captados na imprensa e (2) confirmados em contato com as empresas. O dado que carregamos para nossa atividade é o de investimentos confirmados de 2012 até o dia 03 de Agosto de 2020.

Cada linha representa um investimento confirmado e temos, resumidamente, informações sobre a data e tipo do investimento, a empresa investidora e sua atividade econômica, o valor investido, o local da empresa.

Podemos rapidamente olhar para uma "amostra" dos dados com a função _head_, que nos apresenta as 6 primeiras linhas do conjunto de dados e as primeiras colunas à esquerda.

```{r}
head(piesp)
```

Com apenas as 6 primeiras linhas do data frame temos noção dos dados. 

Mas quantos investimentos há ao todo no conjunto de dados? Com _nrow_ descobrimos quantas linhas tem nosso data frame.

```{r}
nrow(piesp)
```

Quantas informações temos disponíveis para cada investimento? Ou seja, quantas variáveis há no conjunto de dados?
  
```{r}
ncol(piesp)
```

Qual é o nome das variáveis do conjunto de dados?
  
```{r}
names(piesp)
```

Há diversas maneiras de examinarmos os dados sem olharmos diretamente para a matriz de dados. Habitue-se a usar as funções que acabamos de conhecer quando abrir um novo conjunto de dados.


## Pausa para um comentário

Podemos fazer comentários no meio do código. Basta usar # e tudo que seguir até o final da linha não será interpertado pelo R como código. Por exemplo:

```{r}
# Imprime o nome das variaveis do data frame da PIESP
names(piesp)

names(piesp) # Repetindo o comando acima com comentario em outro lugar
```

Comentários são extremamente úteis para documentar seu código. Use e abuse. Documentar é parte de programar e você deve pensar nas pessoas com as quais vai compartilhar o código e no fato de que com certeza não se lembrará do que fez em pouco tempo (garanto, você vai esquecer).

Durante o curso, comente todos os seus scripts.

## Argumentos ou parâmetros das funções

R é uma linguagem. Tem sintaxe, léxico e ortografia. Vamos falar um pouco sobre a sintaxe de R.

Note que em todas as funções que utilizamos até agora, _piesp_ está dentro do parênteses que segue o nome da função. Essa __sintaxe__ é característica das funções de R. O que vai entre parêntesis são os __argumentos__ ou __parâmetros__ da função, ou seja, os "inputs" que serão transformados.

Uma função pode receber mais de um argumento. Pode também haver argumentos não obrigatórios, ou seja, para os quais não é necessário informar nada se você não quiser alterar os valores pré-definidos. Por exemplo, a função _head_ contém o argumento _n_, que se refere ao número de linhas a serem __impressas__ na tela, pré-estabelecido em 6 (você pode conhecer os argumentos da função na documentação do R usando _?_ antes do nome da função). Para alterar o parâmetro _n_ para 20, por exemplo, basta fazer:
  
```{r}
head(x = piesp, n = 20)
```

_x_ é o argumento que já havíamos utilizado anteriormente e indica em que objeto a função _head_ será aplicada. Dica: você pode omitir tanto "x =" quanto "n =" se você já conhecer a ordem de cada argumento no uso da função.

Se essa discussão lhe parecer um pouco confusa, não se preocupe. Voltaremos a ela com alguma frequência e aos poucos vamos nos habituar com os aspectos formais da linguagem. Sigamos.

## Mais funções para explorar os dados

Todos os objetos em R tem uma estrutura. Você pode investigar essa estrutura utilizando a função _str_. No caso de data frames, o output é legível (para outras classes de objeto isso não é verdade necessariamente):
  
```{r}
str(piesp)
```

Há informações sobre o nome das variáveis, dispostas na vertical, tipo de dados (texto -- char -- ou números -- num ou int) e uma amostra das primeiras observações. No final há informações sobre a classe das colunas (vetores!) do data frame.


Uma função semelhante, e com resultado um pouco mais "limpo", é _glimpse_:
  
```{r}
glimpse(piesp)
```

'chr', 'num' ou 'dbl' que aparecem nos outputs dizem respeito aos tipos de dados armazenados em cada vetor. Aprenderemos mais sobre isso no futuro.

Vamos agora renomear os dados.

## Renomeando variáveis

Quando trabalhamos com dados que não coletamos, em geral, não vamos gostar dos nomes das variáveis que quem produziu os dados escolheu. Mais ainda, com certa frequência, obtemos dados cujos nomes das colunas são compostos ou contêm acentuação, cecedilha e demais caracteres especiais. Dá um tremendo trabalho usar nomes com tais característica, apesar de possível. O ideal é termos nomes sem espaço (você pode usar ponto ou subscrito para separar palavras em um nome composto) e que contenham preferencialmente letras minísculas sem acento e números.

Vamos começar renomeando algumas variáveis no nosso banco de dados, cujos nomes vemos com o comando abaixo:
  
  ```{r}
names(escolas)
```

O primeiro argumento da função _rename_ deve ser a base de dados cujos nomes das variáveis serão renomeados. Depois da primeira vírgula, inserimos todos as modificações de nomes, novamente separadas por vírgulas, e da seguinte maneira. Exemplo: nome\_novo = nome\_velho. Exemplo: nome\_novo = Nome_Velho. Veja o exemplo, em que damos novos nomes às variáveis "tipoesc", "latitute" e "longitude":
  
  ```{r}
escolas <- rename(escolas, tipo = tipoesc, lat = latitude, lon = longitude)
```

Simples, não? 
  
  ## Uma gramática, duas formas
  
  No _tidyverse_, existe uma outra sintaxe para executar a mesma tarefa de (re)nomeação. Vamos olhar para ela (lembre-se de carregar novamente os dados, pois os nomes velhos já não existem mais e não existe Ctrl+Z em R):
  
  ```{r, eval = F}
escolas <- read_csv2(url_escolas)

escolas <- escolas %>%
  rename(tipo = tipoesc,
         lat = latitude,
         lon = longitude)
```

Usando o operador %>%, denominado _pipe_, retiramos de dentro da função _rename_ o banco de dados cujas variáveis serão renomeadas. As quebras de linha depois do %>% e dentro da função _rename_ são opcionais. Porém, o pardão é 'verticalizar o código' e colcar os 'verbos' à esquerda, o que torna sua leitura mais confortável.

Compare com o código que havíamos executado anteriormente:
  
  ```{r, eval = F}
escolas <- read_csv2(url_escolas)

escolas <- rename(escolas, tipo = tipoesc, lat = latitude, lon = longitude)
```

Essa outra sintaxe tem uma vantagem grande sobre a anterior: ela permite emendar uma operação de transformação do banco de dados na outra. Veremos adiante como fazer isso. Por enquanto, tenha em mente que o resultado é o mesmo para qualquer uma das duas formas.

Vamos trabalhar com várias variáveis (sic) de uma única vez. Reabra o banco de dados:
  
  ```{r, include = F, echo=F}
escolas <- read_csv2(url_escolas)
```

Renomeie as variáveis "dre", "codesc", "tipoesc", "nomesc", "diretoria", "latitude", "longitude" e "codinep".

```{r, include = F, echo=F}
escolas <- escolas %>%
  rename(dre_abreviatura = dre,
         codigo = codesc,
         tipo = tipoesc,
         nome = nomesc,
         dre = diretoria,
         lat = latitude,
         lon = longitude,
         codigo_inep = codinep)
```

## Selecionando colunas

Algumas colunas podem ser dispensáveis em nosso banco de dados a depender da análise. Por exemplo, pode ser que nos interessem apenas as variáveis que já renomeamos. Para selecionar um conjunto de variáveis, utilizaremos o segundo verbo do _dplyr_ que aprenderemos: _select_

```{r}
escolas <- select(escolas, dre_abreviatura, codigo, tipo, nome, dre, lat, lon, codigo_inep)
```

ou usando o operador %>%, chamado __pipe__,

```{r}
escolas <- escolas %>%
  select(dre_abreviatura,
         codigo,
         tipo,
         nome,
         dre,
         lat,
         lon,
         codigo_inep)
```

## Operador %>% para "emendar" tarefas

O que o operador __pipe__ faz é simplesmente colocar o primeiro argumento da função (no caso acima, o _data frame_), fora e antes da própria função. Ele permite lermos o código, informalmente, da seguinte maneira: "pegue o data frame x e aplique a ele esta função". Veremos abaixo que podemos fazer uma cadeia de operações ("pipeline"), que pode ser lida informalmente como: "pegue o data frame x e aplique a ele esta função, e depois essa, e depois essa outra, etc".

A grande vantagem de trabalharmos com o operador %>% é não precisar repetir o nome do _data frame_ diversas vezes ao aplicarmos a ele um conjunto de operações.

Vejamos agora como usamos o operador %>% para "emendar" tarefas, começando da abertura desde dados. Note que o primeiro input é o url da base de dados e, que, uma vez carregados, vai sendo transformado a cada novo verbo.

```{r}
escolas <- read_csv2(url_escolas) %>%
  rename(dre_abreviatura = dre,
         codigo = codesc,
         tipo = tipoesc,
         nome = nomesc,
         dre = diretoria,
         lat = latitude,
         lon = longitude,
         codigo_inep = codinep)  %>%
  select(dre_abreviatura,
         codigo,
         tipo,
         nome,
         dre,
         lat,
         lon,
         codigo_inep)
```

Em uma única sequência de operações, abrimos os dados, alteramos os nomes das variáveis e selecionamos as que permaneceriam no banco de dados. Esta forma de programa, tenha certeza, é bastante mais econômica e mais fácil de ler, para que possamos identificar erros mais facilmente.

## Transformando variáveis

Usaremos a função _mutate_ para operar transformações nas variáveis existentes e criar variáveis novas. Há inúmeras transformações possíveis e elas lembram bastante as funções de outros softwares, como MS Excel. Vamos ver algumas das mais importantes.

No nosso caso, o formato dos valores de latitude e longitude estão em formato diferente do convenional. Latitudes são representadas por números entre -90 e 90, com 8 casas decimais, e Longitudes por números entre -180 e 180, também com 8 casas decimais. Em nosso par de variáveis, latitude está sem separador de decimal está omitido. Faremos a correção divindo latitude por 1 milhão.

No caso de longitude, a situação é ainda pior. Há vários separadores e a variável foi lida como texto. Teremos que limpar todos os separadores, transformar a variável em número e, ao final, dividir por 1 milhão para colocar o separador no lugar certo.

```{r}
escolas <- escolas %>% 
  mutate(lat = lat / 1000000, 
         lon = str_replace_all(lon, "\\.", ""),
         lon = as.numeric(lon),
         lon = lon / 1000000) 
```

Como utilizamos os nomes das próprias variáveis à esquerda da operação de transformação, produziremos uma substituição e não haverá novas colunas na base de dados.

Voltaremos ao verbo _mutate_ no próximo tutorial e no exemplos abaixo. 

## Filtrando linhas

Por vezes, queremos trabalhar apenas com um conjunto de linhas do nosso banco de dados. Por exemplo, se quisermos selecionar apenas escolas municipais de educação infantil, utilizamos o verbo 'filter' com a condição desejada. Note que estamos criando um novo data frame (ou seja, um novo objeto) que contém a seleção de linhas produzida:
  
  ```{r}
emeis <- escolas %>% 
  filter(tipo == "EMEI")
```

Além da igualdade, poderíamos usar outros símbolos: maior (>). maior ou igual (>=), menor (<), menor ou igual (<=) e diferente (!=) para selecionar casos. Para casos de _NA_, podemos usar a função is.na(), pois a igualdade '== NA' é inválida em R.

Vamos supor agora que todos centros de educação infantil (creche) da rede direta, indireta e conveniada. Como combinar condições?
  
  ```{r}
creches <- escolas %>% 
  filter(tipo == "CEI DIRET" | tipo == "CEI INDIR" | tipo == "CR.P.CONV")
```

Note que, para dizer que para combinarmos as condições de seleção de linha, utilizamos uma barra vertical. A barra é o símbolo "ou", e indica que todas as observações que atenderem a uma ou outra condição serão incluídas.

Vamos supor que queremos estabelecer agora condições para a seleção de linhas a partir de duas variáveis. Por exemplo, queremos incluir as mesmas escolas já escolhidas e que também sejam da Diretoria Regional do Ipiranga. O símbolo da conjunção "e" é "&". Veja como utilizá-lo:
  
  ```{r}
creches <- escolas %>% 
  filter(tipo == "CEI DIRET" | 
           tipo == "CEI INDIR" | 
           tipo == "CR.P.CONV")

```

Ao usar duas variáveis diferentes para filter e a conjunção "e", podemos escrever o comando separando as condições por vírgula e dispensar o operador "&":
  
  ```{r}
creches_ipiranga <- escolas %>% 
  filter((tipo == "CEI DIRET" | 
            tipo == "CEI INDIR" | 
            tipo == "CR.P.CONV"),
         dre == "DIRETORIA REGIONAL DE EDUCACAO IPIRANGA")
```

Você pode combinar quantas condições precisar. Se houver ambiguidade quanto à ordem das condições, use parênteses, como fizemos acima.

Vamos uma aplicação interessante dos dados com os quais trabalhamos.

## Produzindo mapas no R

Criamos acima um data frame que contém apenas centros de educação infantil com a informação de latitude e longitude já corrigida. Conseguimos "reduzir" e alterar os dados usando quatro "verbos" (funções) fundamentais de manipulação de dados: _rename_, _select_, _mutate_ e _filter_.

Precisaremos do pacote _ggmap_ e _osmdata_ para "importar" mapas de rua de serviços da web (Google e Open Street Maps, por exemplo) para, depois, fazer a combinação dos mapas com os pontos (escolas, a partir da latitude e longitude).

```{r}
# install.packages('osmdata')
# install.packages('ggmap')
library(ggmap)
library(osmdata)
```

Sem entrar em detalhes, vamos utilizar as funções _get\_map_ e _getbb_ para obter um mapa sobre o qual inseriremos nossos pontos.

```{r}
map_sp <- get_map(getbb("Sao Paulo"), 
                  maptype = "toner-background",
                  zoom = 13)
```

Podemos plotar o mapa que baixamos com a função _plot_:
  
  ```{r}
plot(map_sp)
```

Mas ainda não é isso que queremos. Precisamos sobrepor ao mapa que baixamos os pontos correspondentes a cada uma dos CEIS. Veja como:
  
  ```{r}
ggmap(map_sp) +
  geom_point(aes(lon, lat), data = creches)
```

Legal, não? Não muito bonito, mas estamos no caminho.

O código acima tem uma estrutura bastante diferente do que havíamos visto. Ele é parte de outra "gramática" do R, a "grammar o graphics" do pacote _ggplot2_. Veremos um pouco sobre ela em outro tutorial, mas vamos tentar destrinchar o código do mapa acima desde já.

Começamos plotando o mapa de São Paulo obtido nas APIs do Open Street Maps e Google com a função _ggmap_. Criamos, assim, a primeira camada do mapa e "organizará" o sistema de coordenadas. Com _geom\_point_, adicionaremos pontos ao mapa. Os pontos vem do data frame "creches" -- por isso "data = creches" -- e a informação utilizada, "lat" e "lon", faz parte da "aesthetics" do mapa -- por isso dentro do parênteses "aes".

Se você quiser aprender um pouco mais sobre mapas no R (e fazer mapas mais bonitos) [aqui](https://jonnyphillips.github.io/FLS6397_2019/class06.html).

## Fim

Espero que com este tutorial você tenha se familiarizado com a linguagem R e compreendido como utilizá-la trabalhar com os dados abertos da educação municipal. Organizando o que fizemos em um único "bloco" de cógido, vemos que é preciso pouco código para fazer algo relevante:
  
  ```{r}
library(tidyverse)
library(ggmap)
library(osmdata)

creches <- read_csv2(url_escolas) %>%
  rename(dre_abreviatura = dre,
         codigo = codesc,
         tipo = tipoesc,
         nome = nomesc,
         dre = diretoria,
         lat = latitude,
         lon = longitude,
         codigo_inep = codinep)  %>%
  select(dre_abreviatura,
         codigo,
         tipo,
         nome,
         dre,
         lat,
         lon,
         codigo_inep) %>% 
  mutate(lat = lat / 1000000, 
         lon = str_replace_all(lon, "\\.", ""),
         lon = as.numeric(lon),
         lon = lon / 1000000) %>% 
  filter(tipo == "CEI DIRET" | 
           tipo == "CEI INDIR" | 
           tipo == "CR.P.CONV")

map_sp <- get_map(getbb("Sao Paulo"), 
                  maptype = "toner-background",
                  zoom = 13)

ggmap(map_sp) +
  geom_point(aes(lon, lat), data = creches)

```







