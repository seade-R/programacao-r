# Apresentação

Na aula anterior, aprendemos a trabalhar com uma das gramáticas mais populares de R -- a gramática do `dplyr`, que é parte do `tidyverse`. Além de ser uma coleção de pacotes (<https://www.tidyverse.org/>), o tidyverse é um _movimento_ de reescrever a linguagem R para torná-la mais intuitiva, eficiente e consistente.

No entanto, a linguagem R existe bem antes do aparecimento dos pacotes do `tidyverse`, que se popularizaram nos últimos anos. Enquanto R é de 1993, o pacote `dplyr` foi lançado apenas em 2014 (e levou um par de anos até se tornar o mais popular).

No primeiro tutorial de hoje vamos dar vários passos atrás e conhecer o básico da linguagem R. Faremos o retorno aos poucos, começando novamente por data frames. Veremos classes e tipos de dados e aprenderemos um pouco mais sobre vetores e operações matemáticas no R.

# Construindo vetores e data frames

Em vez de importarmos um conjunto de dados, vamos criá-lo passo a passo a partir de vetores. Começaremos com uma atividade.

Abra 2 ou 3 jornais ou portais de notícias diferentes. Vá em cada um deles e escolha 2 notícias quaisquer que aparecerem na tela. Ao todo, separe 4 notícias. Para cada notícia, colete as seguintes informações:

-   Nome do jornal ou portal (pode abreviar)
-   Data da notícia (não precisa coletar a hora)
-   Título
-   Autor(a) (insira 'NA' se não houver autoria)
-   Número de caracteres no texto (use o Word ou Libre Office se quiser um número preciso ou chute um número de caracteres, apenas para seguir com o exercício, mas **POR FAVOR** não perca tempo contando manualmente!)
-   Marque 1 se a notícia mencionar a palavra "investimento" e 0 caso contrário
-   Marque TRUE se a notícia mencionar o estado de São Paulo e FALSE caso contrário

Vamos criar vetores para armazenar estas informações, na ordem de coleta das notícias. Para cada informação (ou variável), vamos construir um vetor. Vejam meus exemplos. Começando com o nome do jornal ou portal:

``` r
jornal <- c("El país",
            "El país",
            "O Estado de São Paulo", 
            "O Estado de São Paulo")
```

Execute a linha do vetor criado. Se você criou corretamente o vetor `jornal`, então nada aconteceu na tela do Console, ou seja, nenhum output foi impresso. Isso se deve ao fato de que criamos um novo **objeto**, chamado "jornal" e **atribuímos** a ele os valores coletados sobre os nomes dos veículos nos quais coletamos as notícias. O símbolo de **atribuição** em R é `<-`, como vimos anteriormente. Note que o símbolo lembra uma seta para a esquerda, indicando que o conteúdo do vetor será armazenado no objeto `jornal`.

**Objetos** não são nada mais do que um nome usado para armazenar dados na memória RAM (temporária) do seu computador. No exemplo acima, `jornal` é o objeto e o vetor é a informação armazenada. Uma vez criado, o objeto está disponível para ser usado novamente, pois ele ficará disponível no **Environment** (ambiente). Veremos adiante que podemos criar um *data frame* a partir de vários vetores armazenados na memória. Especificamente no RStudio, os objetos ficam disponíveis no painel **Environment** (que provavelmente está no canto direito superior da sua tela).

Eu poderia usar o símbolo `=` no lugar de `<-`? Sim. Regra geral, o `=` funciona. Mas nem sempre ele funciona como esperado, e esta substituição é uma fonte grande de confusão, pois há ambiguidade no uso do sinal de igualdade. Quando entendermos um pouco mais sobre a sintaxe da linguagem R, isso ficará claro. Por enquanto, quando for atribuir dados para um objeto, prefira `<-`.

Se o objetivo fosse criar o vetor sem "guardá-lo" em um objeto, bastaria repetir a parte do código acima que começa após o símbolo de atribuição. `c()` (abreviação do inglês "concatenate") é a função do R que combina valores de texto, número ou lógicos (ainda não falamos destes últimos) em um vetor. É um função muito utilizada ao programar em R.

``` r
c("El país",
  "El país",
  "O Estado de São Paulo", 
  "O Estado de São Paulo")
```

Note que há quebras de linha no código. Não há problema algum quebrar linhas. Uma vez que o parêntese que indica o fim do vetor não foi encontrado, o R entende que o conteúdo da próxima linha é a continuidade do código (e, portanto, do vetor). 

Dica: quebras de linha ajudam a vizualizar o código, sobretudo depois de uma vírgula, e com o tempo você também usará.

Vamos seguir com nossa tarefa de criar vetores. Já temos o vetor `jornal` (que você pode observar no **Environment**). Os demais vetores criados com as notícias que coletei estão abaixo.

Obs: evite nomear os objetos com nomes de funções já existentes em R, como `data`.

``` r
# Data
data_noticia <- c("07/08/2020",
                  "06/08/2020",
                  "10/08/2020",
                  "10/08/2020")

# Titulo
titulo <- c("Livros de Philip Roth voltam para 'casa', a biblioteca onde se formou leitor, em Newark",
            "Redução da biodiversidade favorece o surgimento de novas pandemias",
            "Mercado melhora previsão para o PIB em 2020 e passa a estimar queda de 5,62%",
            "Governo de São Paulo lança indicador para acompanhar retomada econômica no Estado")

# Autor
autor <- c("Pablo Guimón",
           "Daniel Mediavilla",
           "Eduardo Rodrigues",
           "João Ker")

# Numero de caracteres
caracteres <- c(10977, 5017, NA, 2561)

# Contem a palavra investimento
investimento <- c(0, 1, 1, 0)

# Contem Sao Paulo
sp <- c(FALSE, NA, FALSE, TRUE)
```

Para onde vão os objetos de R criados? Para o **Environment**. Se quisermos uma "fotografia" do nosso **Environment**, usamos a função `ls()`:

``` r
ls()
```

## Detalhes importantes nos vetores acima

Mais alguns detalhes importantes a serem notados no exemplo acima:

-   O formato da data foi arbitrariamente escolhido. Por enquanto, R entende apenas como texto o que foi inserido. Aprenderemos a trabalhar com datas em outro momento utilizando o pacote `lubridate`, que é parte do `tidyverse`.
-   Os textos foram inseridos entre aspas. Os números, não. Se números forem inseridos com aspas, R os entenderá como texto também e, nesse caso, você não poderá fazer operações matemáticas com essa informação.
-   Além de textos e números, temos no vetor `sp` valores *lógicos*, `TRUE` e `FALSE`, que podem ser abrevidados para `T` e `F`. *logical* é um tipo de dado do R (e é particularmente importante).
-   O texto do primeiro título que coletei contém aspas. Como colocar aspas dentro de aspas sem fazer confusão? Se você delimitou o texto com aspas duplas, use aspas simples no texto e vice-versa.
-   O que são os `NA` no meio do vetor `caracteres` e `sp`? Quando coletei as notícias, não contei os caracteres da terceira notícia e não notei se a segunda notícia mencionava São Paulo. `NA` é o símbolo do R para **missing values**. Temos que lidar com eles o tempo todo na preparação de dados para análise.

## Criando um data frame a partir de vetores:

*data frames* são um conjunto de vetores reunidos e na vertical. Se você introduziu os valores em cada vetor na ordem correta de coleta dos dados, então eles podem ser **pareados** e **combinados**. No meu exemplo, a primeira posição de cada vetor contém as informações sobre a primeira notícia, a segunda posição sobre a segunda notícia e assim por diante.

Obviamente, se estiverem pareados, os vetores devem ter o mesmo comprimento. Há uma função bastante útil para checar o comprimento:

``` r
length(jornal)
```

Vamos criar um *data frame* com o nome `dados` a partir dos vetores que construímos. Vamos produzi-lo, discutir a função `data.frame()` e depois examiná-lo:

``` r
dados <- data.frame(jornal,
                    data_noticia,
                    titulo,
                    autor,
                    caracteres,
                    investimento,
                    sp)
```

Usando as funções que aprendemos na aula anterior, podemos inspecionar o novo data frame:

``` r
# 6 primeiras (e unicas, no caso) linhas
head(dados)

# Estrutura do data frame
str(dados)

# Nome das variaveis (colunas)
names(dados)

# Dimensoes do data frame
dim(dados)
```

O que é, afinal, um data frame? É um conjunto de vetores de mesmo tamanho e pareados dispostos na vertical. Formalmente, é uma *lista* de vetores de mesmo tamanho e pareados.

# Tipos de dados em R e vetores

Há diversos tipos de dados que podem ser armazenados em vetores: *doubles*, *integers*, *characters*, *logicals*, *complex*, e *raw*. Neste tutorial, vamos examinar os 3 mais comumente usados na análise de dados: *doubles*, *characters*, *logicals*.

## Doubles

*doubles* são utilizados para guardar números. Por exemplo, o vetor `caracteres`, que indica o número de caracteres em cada texto, é do tipo *double*. Vamos repetir o comando que cria este vetor (agora sem o NA, que foi substituído pelo valor coletado):

``` r
caracteres <- c(10977, 5017, 2980, 2561)
```

Com a função `typeof()` você consegue descobrir o tipo de cada vetor:

``` r
typeof(caracteres)
```

É possível fazer operações matemáticas com vetores númericos (*integers* também são vetores numéricos, mas vamos esquecer deles por enquanto e fazer de *double* sinônimo de numérico). Por exemplo, podemos somar 1 a todos os seus elementos, dobrar o valor de cada elemento ou somar todos:

``` r
caracteres + 1
caracteres * 2
sum(caracteres)
```

Note que as duas primeiras funções retornam vetores de tamanho igual ao original, enquanto a aplicação da função `sum` a um vetor retorna apenas um número, ou melhor, um **vetor atômico** (que contém um único elemento).

Tal como aplicamos as operações matemáticas e a função `sum()`, podemos aplicar diversas outras operações matemáticas e funções que descrevem de forma sintética os dados (média, desvio padrão, etc) a vetores numéricos. Veremos operações e funções com calma num futuro breve.

## Logicals

O vetor *investimento* também é do tipo *double*. Mesmo registrando apenas a presença e ausência de uma característica, os valores inseridos são números. Mas e o vetor `sp`? Vejamos:

``` r
typeof(investimento)
typeof(sp)
```

Em vez de armazenarmos sim/não, presença/ausência, etc com os números 0 e 1, podemos em R usar o tipo *logical*, cujos valores são `TRUE` e `FALSE` (ou `T` e `F` maiúsculos, para poupar tempo e dígitos). Utilizaremos vetores lógicos em R com muita frequência.

E o que acontece se fizermos operações matemáticas com vetores lógicos?

``` r
sp + 1
```

Automaticamente, o R transforma FALSE em 0 e TRUE em 1 se forem utilizados em uma operação matemática.

## Character

Finalmente, vetores que contêm texto são do tipo *character*. O nome dos jornais, data, título e autor são informações que foram inseridas como texto (lembre-se, o R não sabe por enquanto que no vetor *data_noticia* há uma data). Aritmética não vale para estes vetores.

### Tipo é diferente de classe

Veremos em momento oportuno que os objetos em R também têm um atributo denominado **class**. A classe diz respeito às características dos objetos enquanto tipo diz respeito ao tipo de dado armazenado. No futuro ignoraremos o tipo e daremos mais atenção à classe, mas é sempre bom saber distinguir os tipos de dados que podemos inserir na memória do computador usando R.

# Voltando ao zero - O básico do R

Começamos em data frames, passamos por vetores e agora "voltaremos ao zero"" para aprender sobre os aspectos elementares da linguagem R.

## Operações matemáticas em R

R serve como calculadora. É bastante simples realizar operações matemáticas em R.

``` r
# Soma
42 + 84

# Subtracao
84 - 42

# Multiplicacao
42 * 2

# Divisao
42 / 6

# Potencia
2 ^ 5

# Divisao inteira (sem resto)
42 %/% 5

# Resto da divisao:
42 %% 5
```

Nos exemplos acima, realizamos operações bastante simples sem usar objetos ou, como costumamos chamar, variáveis. 

Note que há dois usos para a palavra "variável". O primeiro deles, que vimos nos tutoriais anteriores, é o sinônimo de coluna em um *data frame*, e registra uma característica específica para todas as observações (por exemplo, a coluna com idade em um *data frame* com informações sobre indivíduos). 

O outro uso é sinônimo de objeto no R. Nos referimos à "variável x", quando atribuímos algo -- um número ou um texto, por exemplo -- a "x".

Nos tutoriais, vamos fazer uso de variável com ambos significados. Com o tempo você se acostumará.

Voltando às operações matemáticas, vamos criar uma variável "x" com o valor 42. Ao criar uma variável que armazena apenas um número, estamos criando um escalar ou vetor atômico. Vetores atômicos são aqueles que contém um único tipo de dados.

``` r
x <- 42
```

Podemos imprimir o valor de uma variável no console simplesmente digitando seu nome:

*Lembre-se, o console é aquela janela que fica abaixo de onde você digita o código. Se tiver dúvida sobre os nomes, reveja o vídeo da aula anterior (<https://www.youtube.com/watch?v=7yhw_xYWqlU>).*

``` r
x
```

Em várias outras linguagens, e em R inclusive, usa-se a função `print()` para imprimir os valores de uma variável:

``` r
print(x)
```

Quando usar `print()`? Veremos no futuro que, dependendo da situação (por exemplo, dentro de funções ou loops), é preciso explicitar que queremos "imprimir" algo no console, e, nestes casos, usamos a função `print()`.

Vamos criar mais uma variável, y, e fazer operações com variáveis:

``` r
y <- 5
x + y
x - y
x / y
x * y
```

Podemos armazenar o resultado de uma operação matemática em uma outra variável. Veja os exemplos:

``` r
z1 <- 42 / 3
z2 <- x + y
z3 <- ((x / 5 ) * 9) + z1
```

Veja que na última operação utilizamos diversos parênteses. As regras para o uso de parênteses em R nas operações matemáticas são semelhantes às da aritmética "de papel e caneta". Os parênteses são executados sempre de dentro para fora. Aliás, essa regra vale em geral no R, ou seja, para aplicação de quaisquer funções, e não apenas para as operações matemáticas.

## Classes dos vetores atômicos

Há três **classes** fundamentais para os vetores atômicos. Vamos criar três variáveis e examinar suas classes:

``` r
numero <- 3.14
texto <- 'A cajuína cristalina em Teresina'
logico <- TRUE
```

Usamos a função `class()` para examinar a classe de um objeto:

``` r
class(numero)
class(texto)
class(logico)
```

Auto-explicativo, certo?

## Mais um pouco sobre vetores

Aproveitando o embalo dos vetores atômicos, vamos ver um pouco mais sobre vetores de tamanho maior que 1. Alguns exemplos e suas classes:

``` r
vetor_numerico <- c(42, 37, 999, 3.14, -232)
vetor_texto <- c('Peixe', "a", 'jota', "TRUE", "4")
vetor_logico <- c(TRUE, FALSE, F, F, T)

class(vetor_numerico)
class(vetor_texto)
class(vetor_logico)
```

Detalhes para observarmos:

-   No caso do vetor numérico, não importa se usamos números com casas decimais ou negativos.
-   Para vetores do tipo "character", não importa o que há dentro das aspas. Tudo é texto. E não importa se utilizamos _aspas simples ou duplas_.
-   Você pode usar `TRUE` ou `T`, `FALSE` ou `F`, alternadamente. R entende o que você quer dizer. Lembre-se de sempre usar maiúsculas para informações do tipo logical'.

## Exercícios:

Qual é a classe dos vetores abaixo? Imprima o vetor com `print()` e tente advinhar. Use a função `class()` para descobrir a resposta.

``` r
v1 <- c(1, 2, TRUE, 4)
v2 <- c("T", "TRUE", "FALSE", "T")
v3 <- c("1", "2", "3", "4")
v4 <- c(1, "4", 4, 1)
v5 <- c(1, 2, "feijao com arroz")
v6 <- c("SEADE", "CEPAM", TRUE)
v7 <- c(T, T, F, T, F, F, 42)
```

Você consegue identificar as regras de combinação de tipos de dados diferentes em um mesmo vetor?

Quando objetos de diferentes tipos são misturados, ocorre a **coerção**, para que cada elemento possua a mesma classe. Nos exemplos acima, nós vemos o efeito da coerção implícita, quando o R tenta representar todos os objetos de uma única forma.

Nós podemos forçar um objeto a mudar de classe, através da coerção explícita, realizada pelas funções `as.character()`, `as.logical()` ou `as.numeric()`.

## Operações matemáticas com vetores

Comecemos com um vetor de temperaturas médias dos meses de março a agosto em graus Celsius:

``` r
temperatura_celsius <- c(30, 22, 13, 7, -3, 5)
```

Como vimos anteriormente, podemos aplicar operações matemáticas aos vetores. Por exemplo, vamos converter os valores do vetor `temperatura_celsius` para Fahrenheit, usando a fórmula padrão para essa conversão:

``` r
temperatura_farenheit <- ((temperatura_celsius / 5) * 9) + 32
```

Veja que as operações são aplicadas a todos os elementos do vetor sem precisarmos recorrer a _loops_ como em outras linguagens.

## Operações entre vetores

Criemos dois vetores, cada um registrando os gastos com sorvete e café de um pessoa de segunda a sexta, na ordem:

``` r
cafe <- c(12, 4, 0, 8, 12)
sorvete <- c(0, 9, 0, 18, 9)
```

Operações entre vetores seguem a mesma lógica das operações com vetores atômicos, com a ressalva de que as operações são realizadas "pareando" os elementos dos vetores. Dito de outra forma, ao somarmos dois vetores, por exemplo, o vetor resultante terá na primeira posição a soma dos elementos da primeira posição dos vetores originais, a segunda posição terá a soma dos elementos da segunda posição dos vetores originais e assim por diante. Executando o exemplo:

``` r
soma_gastos <- cafe + sorvete
print(soma_gastos)
```

É bastante simples criar um vetor que seja a combinação de dois vetores. Por exemplo, se tivermos um vetor com os gastos com alimentação em dias de semana e outros com os gastos com alimentação no final de semana, e queremos combinar ambos em um único vetor fazemos:

``` r
dia_de_semana <- c(32, 25, 18, 23, 17)
fim_de_semana <- c(60, 74)
semana_completa <- c(dia_de_semana, fim_de_semana)
```

Uma peculiaridade do R é a forma como ele lida com operações entre vetores de tamanhos diferentes. O vetor menor tem seus elementos repetidos em ordem até atingirem o tamanho do vetor mais longo envolvido na operação. Veja o exemplo para entender:

``` r
v1 <- c(3, 5, 88, 90)
v2 <- c(2, 1)
v1 + v2
```

E se o vetor mais longo não é múltiplo do mais curto, o R imprime automaticamente um aviso (mas não um erro, ou seja, ele nos dá um resultado para o qual devemos ter atenção). Faça o teste com o exemplo:

``` r
v1 <- c(3, 5, 88, 90)
v2 <- c(2, 1, 3)
v1 + v2
```

## Subconjunto de um vetor

E se quisermos extrair elementos em apenas uma ou algumas posições de um vetor?

(Esta é uma **parte bem importante** da linguagem R! Faça com calma, por mais boba que pareça).

Quando queremos selecionar elementos de um vetor (ou, no futuro, de uma matriz ou de um *data frame*) usamos colchetes `[ ]` ao final do objeto. Vetores são objetos com uma única dimensão, então tudo que precisamos fazer para gerar um subconjunto é colocar o número da posição que queremos dentro dos colchetes.

Para extrair o primeiro dia do vetor com dados da semana completa (que, no nosso exemplo, começa na segunda-feira):

``` r
semana_completa[1]
```

Ou, para extrair o final de semana (sábado na posição 6 e domingo na 7):

``` r
semana_completa[c(6, 7)]
```

Ou ainda, os dias úteis da semana:

``` r
semana_completa[1:5]
```

Note que podemos gerar um vetor que é uma sequência numérica usando `:` (como no exemplo acima `1:5`).

## Soma, média e estatísticas descritivas dos elementos de um vetor

Ao longo do tempo, nosso repertório de funções de R aumentará rapidamente. Há um conjunto de funções fáceis de lembrar que são muito úteis para calcular estatísticas descritivas de um vetor (ou de uma variável em um *data frame*). Exemplo: seu consumo de litros de café por mês em 2022.

``` r
litros_cafe <- c(4.3, 3.1, 5.3, 5.5, 6.9, 8.3, 9.7, 9.9, 9.1, 7.0, 6.2, 5.6)
```

Observe as funções de soma, média, desvio padrão, variância, mediana, máximo, mínimo e quantil, na respectiva ordem:

``` r
sum(litros_cafe)
mean(litros_cafe)
sd(litros_cafe)
var(litros_cafe)
median(litros_cafe)
max(litros_cafe)
min(litros_cafe)
quantile(litros_cafe, probs = c(0, 0.25, 0.5, 0.75, 1))
```

Veja que, com a exceção de `quantile()`, todas as funções retornam vetores com um único elemento. `quantile()` retorna um vetor do tamanho do vetor de probabilidades, que é o segundo argumento da função, e que indica os quantis correspondentes a cada valor.

Note também que o vetor utilizado nas operações não contém nenhum valor faltante, `NA` (*missing value*). Caso houvesse, precisaríamos utilizar o argumento `na.rm = TRUE`, que removeria todos os `NAs` do vetor antes de produzir a operação.

Vamos refazer o exemplo com um `NA` no mês de agosto:

``` r
litros_cafe <- c(4.3, 3.1, 5.3, 5.5, 6.9, 8.3, 9.7, NA, 9.1, 7.0, 6.2, 5.6)
```

Vamos observar o resultado para soma e média com `na.rm = FALSE` (que é o padrão da função, e, portanto, não precisa ser escrito):

``` r
sum(litros_cafe)
mean(litros_cafe)
```

Finalmente, vamos inserir o argumento `na.rm = TRUE`:

``` r
sum(litros_cafe, na.rm = TRUE)
mean(litros_cafe, na.rm = TRUE)
```

## Subconjunto de um vetor - parte 2

É possível nomear um vetor em R com a função `names()`:

``` r
litros_cafe <- c(4.3, 3.1, 5.3, 5.5, 6.9, 8.3, 9.7, 9.9, 9.1, 7.0, 6.2, 5.6)

meses <- c("Janeiro", "Fevereiro", "Marco", "Abril", "Maio", "Junho", 
           "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro")

names(litros_cafe) <- meses

litros_cafe
```

Mas não dê muito atenção à nomeação de posições de um vetor agora, pois é pouco usual.

Vamos usar operadores relacionais (ao qual voltaremos no início do próximo tutorial) para produzir um exemplo de subconjunto mais interessante. A "Organização Mundial de Bebedores de Café", OMBC, recomenda que o consumo de café não ultrapasse o limite de até 7 litros por mês (ou seja, 7 inclusive). Vamos observar em quais meses de 2022 você tomou mais café do que deveria.

Criando um vetor lógico (`TRUE` ou `FALSE`) que indique em quais meses meu consumo ultrapassou o limite recomendado:

``` r
selecao <- litros_cafe > 7
print(selecao)
```

Usamos o vetor `selecao` para fazer o subconjunto do vetor de dados de consumo de café:

``` r
litros_cafe[selecao]
```

Para vetores pequenos, o procedimento adotado para gerar subconjuntos parece desnecessariamente trabalhoso. Mas imagine agora que você queira selecionar todos os municípios que atendam a determinada condição -- por exemplo, menos de 50 mil habitantes. Com uma variável (população) você pode gerar um vetor de seleção que permite gerar o subconjunto desejado de um _data frame_ completo. Nesse caso, com uma única linha de código, você conseguiria resolver seu problema!
