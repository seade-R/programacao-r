# Apresentação

Um dos aspectos mais incríveis da linguagem R é o desenvolvimento de novas funcionalidades pela comunidade de usuárias e usuários.

Há diversas "gramática para bases de dados", ou seja, formas de importar, organizar, manipular e extrair informações das bases de dados, que foram desenvolvidas ao longo da última década.

A "gramática" mais popular da linguagem é a do pacote `dplyr`, parte do`tidyverse` (um verdadeiro universo dentro do R!). Neste primeiro tutorial veremos como utilizar algumas das principais funções, ou "verbos", do pacote`dplyr`. Começaremos com os verbos `rename()`, para renomear variáveis, `select()` para selecionar colunas (variáveis) e `filter()` para selecionar linhas.

Existem outras formas de se trabalhar com conjuntos de dados mais, digamos, antigas. É comum encontrarmos códigos escritos na "gramática" original da linguagem, que chamaremos de "base" ou "básico".

Podemos pensar na linguagem R como uma língua com diversos dialetos. Os dois dialetos mais falados para manipulação de dados são o "base" e o do "tidyverse".

# Instalando e carregando pacotes no R

Quando você abre R ou RStudio, diversas funções estão disponíveis para uso. Elas são parte do pacote "base", que é carregado automaticamente. "base" é a linguagem tal como ela foi desenhada originalmente.

Se quiseremos utilizar funções de pacotes desenvolvidos na comunidade de R que não sejam parte do "base", precisamos instalar pacotes e carregá-los ao iniciar uma nova seção. Vamos ver como fazer isso.

Em primeiro lugar, vamos instalar um pacote. Começaremos com o `tidyverse`, do qual o pacote `dplyr` faz parte:

``` r
install.packages('tidyverse')
```

Pronto. Seu computador (ou seu usuário no servidor RStudio) tem o pacote `tidyverse` instalado (e ele contém o pacote `dplyr`).

Lembre-se de colocar aspas no nome do pacote, pois, até agora, `tidyverse` é um nome desconhecido para a linguagem R no seu computador. E qualquer texto arbitrário em R deve vir entre aspas, não importa se simples ('') ou duplas ("").

A partir da instalação, sempre que quisermos utilizar o pacote `tidyverse` devemos carregá-lo com a função `tidyverse`. Você deve fazer isso toda vez que abrir o RStudio. É importante notar que você só precisará instalar os pacotes uma vez em sua máquina ou em seu servidor remoto, mas precisará carregá-los toda vez que for iniciar uma nova sessão.

``` r
library(tidyverse)
```

Pronto!

Antes de avançar, treine com mais outro pacote: `magrittr`, que é um pacote de operadores em R, que ajudam a estruturar seu código. Não vamos usar este pacote agora, mas ele serve para testarmos os procedimentos de instalação.

# Introdução ao pacote `dplyr`: rename, select e filter

## Começando pelo meio: data frames

Uma característica distintiva da linguagem de programação R é ter sido desenvolvida para a análise de dados. E quando pensamos em análise de dados, a protagonista do show é a *base de dados* ou, como vamos conhecer a partir de agora, o **data frame**.

Por esta razão, em vez de aprender como fazer aritmética, elaborar funções ou executar loops para repetir tarefas e outros aspectos básicos da linguagem, vamos começar olhando para o R como um software concorrente dos demais utilizados para análise de dados em estatística, ciências sociais e demais ciências, como SPSS, Stata, SAS e companhia.

As principais características de um data frame são: (1) cada coluna representa uma **variável** (ou característica) de um conjunto de observações; (2) cada linha representa uma **observação** e contém os valores de cada variável para tal observação. Vejamos um exemplo:

| Município             | Área (km2) | População |
|-----------------------|-----------:|----------:|
| Santo André           |     175,78 |   693.867 |
| São Bernardo do Campo |     409,53 |   812.086 |
| São Caetano do Sul    |      15,33 |   151.244 |
| Diadema               |      30.73 |   404.477 |

Fonte: SEADE

Note que em uma linha os elementos são de tipos de diferentes: na primeira coluna há uma nome (texto), na segunda uma medida de área (números com casa decimais) e na terceira uma contagem (números inteiros).

Por outro lado, em cada coluna há somente elementos de um tipo. Por exemplo, há apenas números inteiros na coluna população. Colunas são variáveis e por isso aceitam registros de um único tipo. Se você já fez um curso de estatística básica ou de métodos quantitativos deve se lembrar que as variáveis são classificadas da seguinte maneira:

1- Discretas

-   Nominais, que são categorias (normalmente texto) não ordenadas

-   Ordinais, que são categorias (normalmente texto) ordenadas

-   Inteiros, ou seja, o conjunto dos números inteiros

2- Contínuas, números que podem assumir valores não inteiros

Se destacamos uma coluna do nosso data frame, temos um **vetor**. Por exemplo, a variável "População" pode ser representada da seguinte maneira: {693.867, 812.086, 151.244, 404.477}. Um data frame é um conjunto de variáveis (vetores!) dispostos na vertical e combinados um ao lado do outro de forma pareada.

Nota: guarde bem a definição de data frame acima, pois data frame é a principal classe de objetos no uso quotidiano da linguagem.

Data frame e vetores são **objetos** na linguagem R.

Vamos ver como o R representa vetores e data frames na tela. Antes disso, é preciso "abrir" um data frame.

## Pesquisa de Investimentos Anunciados no Estado de São Paulo (PIESP)

Neste primeiro tutorial vamos trabalhar com dados de uma pesquisa do SEADE, a [SEADE Investimentos](https://investimentos.seade.gov.br), que capta anúncios de investimento realizados por empresas públicas e privadas no Estado de São Paulo. Vamos abrir os dados antes e depois examinar do que se trata exatamente.

Para este exercício, os dados estão armazenados em um arquivo de texto no formato .csv (comma separated values), ou seja, em cada linha os dados de cada coluna são separados por ponto e vírgula (;). Outros separadores, como vírgula ou tab são possíveis nesse formato.

## Abrindo dados em R com botão (aaaaaaargh!)

Se você decidiu aprender a programar em R, provavelmente quer substituir a análise de dados com cliques no mouse que fazemos no editor de planilhas pela construção de scripts que documentam o passo a passo da análise. Daqui em diante estaremos num mundo sem botões. Exceto um, por enquanto, aí no canto direito superior chamado "Import Dataset".

Clique no botão (aaaaaaargh!). Veja que temos a opção de importar arquivos de texto com duas bibliotecas diferentes, `base` e `readr` (que é o pacote de abertura de dados do `tidyverse`) e dados em alguns outros formatos, como MS Excel e outros softwares de análise estatística.

Use a segunda opção, "From Text (readr)" para carregar os dados da PIESP.

Note que você pode escolher um arquivo na pasta local ou um URL, ou seja, um arquivo que esteja armazenado na web. Os dados da PIESP não estão no seu computador, mas no endereço do repositório do curso: <https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv>

Cole o URL no campo "File/URL" e clique em 'Update'.

A seguir, no campo "Name" digite 'piesp' (minísculo), que é um nome arbitrário que daremos aos nossos dados.

Finalmente, no campo "Delimiter" escolha 'Semicolon' (Ponto e vírgula). Clique em "Import".

Esses são os únicos parâmetros que precisamos alterar ou informar para abrir a PIESP. Para outras bases pode ser necessário fazer outras modificações.

Se tiver dúvidas, você pode assistir a um vídeo sobre como utilizar o botão 'Import Dataset': <https://www.youtube.com/watch?v=6y-9%60h7okH4>

## Abrindo dados em R (com script)

(Lembre-se de carregar o pacote `tidyverse` antes de prosseguir)

``` r
library(tidyverse)
```

Use o recurso "Import Dataset" enquanto não se sentir confortável com a linguagem. Mas, aos poucos, vá abandonando. Abrir dados em R é muito simples.

Repetindo o procedimento, para abrir os dados da PIESP basta fazer:

``` r
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv')
```

Em R, as funções "read." são as funções de abertura de dados do `base` e as funções *read_* são as análogas do pacote `readr`, parte do `tidyverse`. Há funções *read_* para abrir todos os tipos de dados, de arquivos de texto a páginas em HTML.

No nosso caso, utilizamos a função `read_csv2()` para abrir um arquivo de texto cujos valores das colunas são separados por ponto e vírgula. Veremos no futuro e com mais calma outras possibilidades para carregar dados em R.

Note que utilizamos o URL dos dados diretamente. Não precisamos fazer download para uma pasta local para depois abrir os dados se os dados estiverem na web.

Um jeito mais confortável, na minha opinião, de fazer a abertura de dados com um URL é guardar o URL em um objeto de texto e, depois, utilizar esse objeto como input da função. O resultado é idêntico e você pode testar se quiser.

``` r
url_piesp <- "https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv"
piesp <- read_csv2(url_piesp)
```

Note que, pela segunda vez, utilizamos o símbolo `<-`. Ele é um símbolo de atribuição, e é um das marcas mais importantes da linguagem. Atribuir, significa "guardar na memória com um nome". O nome, é o que vai do lado esquerdo. A parte do lado direito da equação de atribuição é o objeto a ser guardado.

Você pode usar `=` no lugar de `<-`. Mas, aviso desde já, há casos em que há ambiguidade e os símbolos não funcionam como esperado.

Vamos avançar.

### Nossos dados são objetos

Ao utilizarmos o símbolo de atribuição criamos um *objeto*. R é uma linguagem voltada a objetos e, basicamente, tudo que você armazenar na memória do computador é um objeto.

Ao 'importarmos' os dados da PIESP criamos um objeto com um nome arbitrário (escolhemos 'piesp' para facilitar) em nosso ambiente. Na aba 'Environment' do RStudio podemos visualizar todos os objetos existentes. 'piesp' está lá, com alguma informação sobre o que é e qual é o seu tamanho. Dê um clique (aaaaaaargh!) no botão azul ao lado do nome do objeto conseguimos ver um pouco de sua estrutura.

### Explorando a matriz de dados sem olhar diretamente para ela

No editor de planilhas estamos acostumados a ver os dados, célula a célula. Mas será que é realmente útil ficar olhando para os dados? Você perceberá com o tempo que olhar os dados é desnecessário e até contraproducente.

Você pode ver os dados clicando (aaaaaaargh!) no nome do objeto que está no "Environment" ou utilizando a função `View()` (cuidado, o "V" é maiúsculo, algo raro em nomes de funções de R).

``` r
View(piesp)
```

Ao lado da aba do script no qual você está trabalhando aparecerá uma aba com a matriz de dados da PIESP. Vamos aproveitar para entender o que são esses dados.

O SEADE disponibiliza a informação detalhada de todos os investimentos anunciados por empresas privadas e públicas de São Paulo (1) captados na imprensa e (2) confirmados em contato com as empresas. O dado que carregamos para nossa atividade é o de investimentos confirmados de 2012 até o dia 03 de Agosto de 2020. A versão dos dados é uma modificação da original (sem acentos nos textos e com colunas de valores em formato numérico) realizada para fins didáticos.

Cada linha representa um investimento confirmado e temos, resumidamente, informações sobre a data e tipo do investimento, a empresa investidora e sua atividade econômica, o valor investido e o local da empresa.

Podemos rapidamente olhar para uma "amostra" dos dados com a função `head()`, que nos apresenta as 6 primeiras linhas do conjunto de dados e as primeiras colunas à esquerda.

``` r
head(piesp)
```

Com apenas as 6 primeiras linhas do data frame temos noção dos dados.

Mas quantos investimentos há ao todo no conjunto de dados? Com `nrow()` descobrimos quantas linhas tem nosso data frame.

``` r
nrow(piesp)
```

Quantas informações temos disponíveis para cada investimento? Ou seja, quantas variáveis há no conjunto de dados?

``` r
ncol(piesp)
```

Qual é o nome das variáveis do conjunto de dados?

``` r
names(piesp)
```

Há diversas maneiras de examinarmos os dados sem olharmos diretamente para a matriz de dados. Habitue-se a usar as funções que acabamos de conhecer quando abrir um novo conjunto de dados.

## Pausa para um comentário

Podemos fazer comentários no meio do código. Basta usar `#` e tudo que seguir até o final da linha não será interpertado pelo R como código. Por exemplo:

``` r
# Imprime o nome das variaveis do data frame da PIESP
names(piesp)

names(piesp) # Repetindo o comando acima com comentario em outro lugar

# Se colocamos o comentário a esquerda deixamos de rodar a linha toda. O código a seguir não será rodado: names(piesp)
```

Comentários são extremamente úteis para documentar seu código. Use e abuse. Documentar é parte de programar e você deve pensar nas pessoas com as quais vai compartilhar o código e no fato de que com certeza não se lembrará do que fez em pouco tempo (garanto, você vai esquecer).

Durante o curso, comente todos os seus scripts e, especialmente, as linhas de código que podem lhe parecer mais úteis para suas atividades futuras. Será mais fácil voltar a elas e estudar se estiverem documentadas.

## Argumentos ou parâmetros das funções

R é uma linguagem. Tem sintaxe, léxico e ortografia. Vamos falar um pouco sobre a sintaxe de R.

Note que em todas as funções que utilizamos até agora, *piesp* está dentro do parênteses que segue o nome da função. Esse é um aspecto característico da **sintaxe** das funções de R. O que vai entre parêntesis são os **argumentos** ou **parâmetros** da função, ou seja, os inputs que serão transformados.

Uma função pode receber mais de um argumento. Pode também haver argumentos não obrigatórios, ou seja, para os quais não é necessário informar nada se você não quiser alterar os valores pré-definidos. Por exemplo, a função `head()` contém o argumento *n*, que se refere ao número de linhas a serem **impressas** na tela, pré-estabelecido em 6 (você pode conhecer os argumentos da função na documentação do R usando `?` antes do nome da função). Para alterar o parâmetro *n* para 20, por exemplo, basta fazer:

``` r
head(x = piesp, n = 20)
```

*x* é o argumento que já havíamos utilizado anteriormente e indica em que objeto a função `head()` será aplicada. Dica: você pode omitir tanto "x =" quanto "n =" se você já conhecer a ordem de cada argumento no uso da função.

Se essa discussão lhe parecer um pouco confusa, não se preocupe. Voltaremos a ela com alguma frequência e aos poucos vamos nos habituar com os aspectos formais da linguagem. Sigamos.

## Mais funções para explorar os dados

Todos os objetos em R tem uma estrutura. Você pode investigar essa estrutura utilizando a função `str()`. No caso de data frames, o output é legível (para outras classes de objeto isso não é verdade necessariamente):

``` r 
str(piesp)
```

Há informações sobre o nome das variáveis, dispostas na vertical, tipo de dados (texto -- char -- ou números -- num ou int) e uma amostra das primeiras observações. No final há informações sobre a classe das colunas (vetores!) do data frame.

Uma função semelhante, e com resultado um pouco mais "limpo", é `glimpse()`:

``` r 
glimpse(piesp)
```

'chr', 'num' ou 'dbl' que aparecem nos outputs dizem respeito aos tipos de dados armazenados em cada vetor. Aprenderemos mais sobre isso no futuro.

Vamos agora renomear os dados.

## NA quer dizer 'missing'

O símbolo `NA` (_Not Avaliable_) em R quer dizer valor faltante (_missing value_). Na coluna de valores dos investimentos há diversos `NA`. Isso quer dizer que não temos a informação daquela variável para aquela observação.

## Renomeando variáveis

Quando trabalhamos com dados que não coletamos, em geral, não vamos gostar dos nomes das variáveis que quem produziu os dados escolheu. Mais ainda, com certa frequência, obtemos dados cujos nomes das colunas são compostos ou contêm acentuação, cedilha e demais caracteres especiais, como no caso da PIESP. Dá um tremendo trabalho usar nomes com tais característica, apesar de possível. O ideal é termos nomes sem espaço (você pode usar ponto ou subscrito para separar palavras em um nome composto, por exemplo) e que contenham preferencialmente letras minísculas sem acento e números.

Vamos começar renomeando algumas variáveis no nosso banco de dados, cujos nomes vemos com o comando abaixo:

``` r
names(piesp)
```

O primeiro argumento da função `rename` deve ser a base de dados cujos nomes das variáveis serão renomeados. Depois da primeira vírgula, inserimos todos as modificações de nomes, novamente separadas por vírgulas, e da seguinte maneira. Exemplo: nome_novo = Nome_Velho. Veja o exemplo, em que damos novos nomes às variáveis "Ano", "Real (em milhoes)" e "Tipo Investimento":

``` r
piesp <- rename(piesp, ano = Ano, valor = `Real (em milhoes)`, tipo = `Tipo Investimento`)
```

Simples, não?

No caso de nomes com mais de uma palavra ou espaços, é preciso colocar o texto entre dois acentos graves (crase) para sabermos onde começa e onde termina o nome da variável, como em "Tipo Investimento".

## Uma gramática, duas formas

No `tidyverse`, existe uma outra sintaxe para executar a mesma tarefa de (re)nomeação. Vamos olhar para ela (lembre-se de carregar novamente os dados, pois os nomes velhos já não existem mais e não existe Ctrl+Z em R):

``` r
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv')

piesp <- piesp %>% 
  rename(ano = Ano,
         valor = `Real (em milhoes)`,
         tipo = `Tipo Investimento`)
```

Usando o operador `%>%`, denominado *pipe*, retiramos de dentro da função `rename()` o banco de dados cujas variáveis serão renomeadas. As quebras de linha depois do `%>%` e dentro da função `rename()` são opcionais. Porém, o padrão é 'verticalizar o código' e colocar os 'verbos' (no caso, o verbo `rename()`) à esquerda, o que torna sua leitura mais confortável.

Compare com o código que havíamos executado anteriormente:

``` r
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv')

piesp <- rename(piesp, ano = Ano, valor = `Real (em milhoes)`, tipo = `Tipo Investimento`)
```

A sintaxe com o uso do *pipe* tem uma vantagem importante: ela permite emendar uma operação de transformação do banco de dados em outra. Veremos adiante como fazer isso. Por enquanto, tenha em mente que o resultado é o mesmo para qualquer uma das duas formas.

Vamos trabalhar com mais variáveis de uma única vez. Reabra os dados para que tenhamos uma versão não renomeada e limpa:

``` r
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv')
```

E renomeie as variáveis "Ano", "Real (em milhoes)" e "Tipo Investimento" e mais 4 de sua escolha. Em R a convenção é utilizar nomes de variáveis com letras minúsculas, sem caracteres especiais (acento e cedilha) e com nomes separados por "\_", como no exemplo:

``` r
piesp <- piesp %>% 
  rename(ano = Ano,
         empresa_alvo = `Empresa alvo do investimento`,
         empresa_investidora = `Empresa(s) investidora(s)`,
         valor = `Real (em milhoes)`,
         valor_dolar = `Dolar (em milhoes)`,
         munic = Municipio,
         tipo = `Tipo Investimento`)
```

## Selecionando colunas

Algumas colunas podem ser dispensáveis em nossos dados a depender da análise ou do que se quer exportar. Por exemplo, pode ser que nos interessem apenas as variáveis que já renomeamos. Para selecionar um conjunto de variáveis, utilizaremos o segundo verbo do `dplyr` que aprenderemos: `select()`

``` r
piesp <- select(piesp, ano, valor, tipo)
```

ou usando o operador `%>%` (_pipe_),

``` r
piesp <- piesp %>%
  select(ano,
         valor,
         tipo)
```

Agora nosso data frame contém apenas "ano", "valor" e "tipo". As demais colunas foram descartadas.

E se quisermos selecionar todas as colunas EXCETO uma? Para isso, podemos incluir o sinal negativo ('-') antes da variável que queira excluir:

``` r
piesp %>%
  select(-ano,
         -valor
         )
```

Note que podemos excluir mais de uma variável simultaneamente.

## Operador %>% para "emendar" tarefas

O que o operador **pipe** faz é simplesmente colocar o primeiro argumento da função (no caso acima, o *data frame*), fora e antes da própria função. Ele permite lermos o código (informalmente) da seguinte maneira: "pegue o data frame x e aplique a ele esta função". Veremos abaixo que podemos fazer uma cadeia de operações ("pipeline"), que pode ser lida (informalmente) como: "pegue o data frame x e aplique a ele esta função, e depois essa, e depois essa outra, etc".

A grande vantagem de trabalharmos com o operador `%>%` é não precisar repetir o nome do *data frame* diversas vezes ao aplicarmos a ele um conjunto de operações.

Vejamos agora como usamos o operador `%>%` para "emendar" tarefas, começando da abertura dos dados, passando pela ação de renomear as variáveis e, enfim, pela seleção de variáveis. Note que o primeiro input (entrada de dados) é o url da base de dados e, que, uma vez carregada, vai sendo transformada a cada novo verbo.

``` r
piesp <- read_csv2('https://raw.githubusercontent.com/seade-R/egesp-seade-intro-programacao/master/data/piesp.csv') %>% 
  rename(ano = Ano,
         empresa_alvo = `Empresa alvo do investimento`,
         empresa_investidora = `Empresa(s) investidora(s)`,
         valor = `Real (em milhoes)`,
         valor_dolar = `Dolar (em milhoes)`,
         munic = Municipio,
         tipo = `Tipo Investimento`) %>%
  select(ano,
         valor,
         tipo)
```

Em uma única sequência de operações, abrimos os dados a partir do url onde estão armazenados, alteramos os nomes das variáveis e selecionamos as que devem permanecer no conjunto de dados. Esta forma de programar, tenha certeza, é bastante mais econômica e mais fácil de ler.

## Filtrando linhas

Por vezes, queremos trabalhar apenas com um conjunto de linhas dos nossos dados. Por exemplo, se quisermos selecionar apenas os investimentos confirmados em 2019, utilizamos o verbo `filter()` com a condição desejada para restringir o número de linhas. 'Filtrar' é selecionar linhas de acordo com os valores de algumas variáveis.

Note que agora vamos criar um novo data frame (ou seja, um novo objeto) que contém a seleção de linhas produzida em vez de sobrescrever na memória o data frame anterior:

``` r
piesp19 <- piesp %>% 
  filter(ano == 2019)
```

Além da igualdade `==` (com dois símbolos "="), poderíamos usar outros símbolos: maior `>`. maior ou igual `>=`, menor `<`, menor ou igual `<=` e diferente `!=` para selecionar casos. Para casos de `NA`, podemos usar a função `is.na` (ou o seu negativo, `!is.na`), pois a igualdade `== NA` é inválida em R (veremos um exemplo adiante).

Vamos supor agora que queremos os anos de 2016 a 2018. Há mais de uma maneira de gerar essa seleção de linhas:

``` r
piesp1518 <- piesp %>% 
  filter(ano == 2016 | ano == 2017 | ano == 2018)
```

Note que, para combinarmos as condições de seleção de linha, utilizamos uma barra vertical `|`. A barra é o símbolo "ou", e indica que todas as observações que atenderem a uma OU outra condição serão incluídas.

Outra maneira de escrever a mesma condição seria:

``` r
piesp1518 <- piesp %>% 
  filter(ano >= 2015 & ano <= 2018)
```

Neste caso, utilizamos `&`, que é o símbolo da conjunção "e". Dizemos, então, que queremos filtrar os anos maiores ou iguais a 2015 e menores ou iguais a 2018.

Vamos supor que queremos estabelecer agora condições para a seleção de linhas a partir de duas variáveis. Por exemplo, queremos apenas os investimentos cujo tipo é 'Implantacao' para os anos de 2016 a 2018. Novamente, precisaremos da conjunção `&`.

``` r
piesp1518_implantacao <- piesp %>% 
  filter(ano >= 2015 & ano <= 2018 & tipo == 'Implantacao')
```

Ao usar duas variáveis diferentes para filter e a conjunção "e", podemos escrever o comando separando as condições por vírgula e dispensar o operador `&` (a quebra de linha é opcional):

``` r
piesp1518_implantacao <- piesp %>% 
  filter(ano >= 2015,
         ano <= 2018,
         tipo == 'Implantacao')
```

Você pode combinar quantas condições precisar. Se houver ambiguidade quanto à ordem das condições, use parênteses.

Se a seleção de linhas envolver excluir ou manter observações com NA, precisamos utilizar a função `is.na`. Por exemplo, para excluir todas os investimentos cujo tipo é desconhecido fazemos (o sinal de exclamação serve para inverter a operação):

``` r
piesp <- piesp %>% 
  filter(!is.na(tipo))
```

## Características dos verbos do dplyr

Vimos até agora 3 verbos do pacote `dplyr`: `rename()`, `select()` e `filter()`. Eles têm algumas características em comum:

-   O primeiro argumento é sempre o data frame que será transformado. Podemos retirar o primeiro argumento de dentro do parênteses se utilizamos o operador pipe (`%>%`).

-   Dentro do parênteses escrevemos uma lista de transformações utilizando vírgula para separá-las.

-   O resultado é sempre um data frame modificado.

Há mais 3 outros verbos do `dplyr` com as mesmas características: `arrange()`, que serve para ordenar as linhas por uma ou mais variáveis; `mutate()`, utilizado para transformar variáveis ou criar novas; e `summarise()` que serve para reduzir/colapsar os dados a um sumário (por exemplo, calculando média ou outra estatística a partir de uma variável).

Esse conjunto de verbos são os mais utilizados para a manipulação e transformação de dados na gramática do `dplyr`, ademais do `group_by()`, que veremos no tutorial seguinte.

## Fim

Chegamos ao final do primeiro tutorial. Espero que você tenha se habituado ao uso da interface e começado a assimilar um pouco a linguagem R.

A ideia é começar a usar a linguagem tal como aplicada no quotidiano da análise de dados para depois darmos alguns passos atrás e aprendermos todos os seus fundamentos.

Não é preciso salvar ou exportar nada. Basta seguir para o tutorial seguinte.
