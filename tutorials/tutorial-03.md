# Apresentação

Na aula passada aprendemos a trabalhar com uma das gramáticas mais populares de R -- a gramática do _dplyr_, que é parte do _tidyverse_. Tidyverse, como conversamos, ademais de uma cole
ão de pacotes (https://www.tidyverse.org/), é um 'movimento' de reescrever a linguagem R para torná-la mais intuitiva, eficiente e consistente.

No entanto, a linguagem R existe bem antes do aparecimento dos pacotes do _tidyverse_, que se popularizaram nos últimos anos. Enquanto R é de 1993, o pacote _dplyr_ foi lançado apenas em 2014 (e levou um par de anos até se tornar o mais popular).

No primeiro tutorial de hoje vamos dar vários passos atrás e conhecer o básico da linguagem R. Faremos o retorno aos poucos, começando novamente por data frames. Veremos classes e tipos de dados e aprenderemos um pouco mais sobre vetores e operações matemáticas no R.

# Construindo vetores e data frames

Em vez de importarmos um conjunto de dados, vamos criá-lo passo a passo a partir de vetores. Começaremos com uma atividade.

Abra 2 ou 3 jornais ou portais de notícias diferentes. Vá em cada um deles e colete 2 notícias quaisquer que aparecerem na tela. Ou seja, separe 4 notícias. Em cada notícia, colete as seguintes informações:
  
- Nome do jornal ou portal (pode abreviar)
- Data da notícia (não precisa coletar a hora)
- Título
- Autor(a) (insira 'NA' se não houver autoria)
- Número de caracteres no texto (use o MS Word ou Libre Office se precisar - invente se tiver preguiça, mas não perca tempo contando)
- Marque 1 se a notícia mencionar a palavra 'investimento' e 0 caso contrário
- Marque TRUE se a notícia mencionar o estado de São Paulo e FALSE canso contrário

Insira as informações nos vetores em ordem de coleta das notícias. Com cada informação, vamos construir um vetor. Vejam meus exemplos. Começando com o nome do jornal ou portal:
  
```{r}
jornal <- c("El país",
            "El país",
            "O Estado de São Paulo", 
            "O Estado de São Paulo")
```

Se você criou corretamente o vetor _jornal_, então nada aconteceu na tela do Console, ou seja, nenhum output foi impresso. Isso se deve ao fato de que criamos um novo __objeto__, chamado _jornal_ e __atribuímos__ a ele os valores coletados sobre os nomes dos veículos nos quais coletamos as notícias. O símbolo de __atribuição__ em R é __<-__, como vimos anteriormente. Note que o símbolo lembra uma seta para a esquerda, indicando que o conteúdo do vetor será armazenado no objeto _jornal_.

Objetos não são nada mais do que um nome usado para armazenar dados na memória RAM (temporária) do seu computador. No exemplo acima, _jornal_ é o objeto e o vetor é a informação armazenada. Uma vez criado, o objeto está disponível para ser usado novamente, pois ele ficará disponível no __environment__. Veremos adiante que podemos criar um _data frame_ a partir de vários vetores armazenados na memória. Especificamente no RStudio, os objetos ficam disponíveis no painel _environment_ (que provavelmente está no canto direito superior da sua tela).

Posso usar o símbolo __=__ no lugar de __<-__? Sim. Funciona. Mas nem sempre funciona e esta substituição é uma fonte grande de confusão, pois há ambiguidade no uso do sinal de igualdade. Quando entendermos um pouco mais da sintaxe da linguagem R ficará claro. Por enquanto, quando for atribuir dados para um objeto, prefira __<-__.

Se o objetivo fosse criar o vetor sem "guardá-lo" em um objeto, bastaria repetir a parte do código acima que começa após o símbolo de atribuição. _c_ ( do inglês "concatenate") é a função do R que combina valores de texto, número ou lógicos (ainda não falamos destes últimos) em um vetor. É um função muito utilizada ao programar em R.

```{r}
c("El país",
  "El país",
  "O Estado de São Paulo", 
  "O Estado de São Paulo")
```

Note que há umas quebras de linha no código. Não há problema algum. Uma vez que o parêntese que indica o fim do vetor não foi encontrado, R entende o que estiver na próxima como continuidade do código (e, portanto, do vetor). Dica: quebras de linha ajudam a vizualizar o código, sobretudo depois de uma vírgula, e com o tempo você também usará.

Vamos seguir com nossa tarefa de criar vetores. Já temos o vetor jornal (que você pode observar no Environment). Os demais vetores criados com as notícias que coletei estão abaixo.

Obs: evite nomear os objetos com nomes de funções já existentes em R, como 'data'.

```{r}
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

Para onde vão os objetos de R criados? Para o Environment. Se quisermos uma 'fotografia' do nosso Environment, usamos a função _ls_, com parêntese vazio (ou seja, sem argumentos além dos pré-estabelecidos):
  
```{r}
ls()
```

## Detalhes importantes nos vetores acima

Mais alguns detalhes importantes a serem notados no exemplo acima:
  
- O formato da data foi arbitrariamente escolhido. Por enquanto, o R entende apenas como texto o que foi inserido. Aprenderemos a trabalhar com datas em outro momento utilizando o pacote _lubridate_, que é parte do _tidyverse_
- Os textos foram inseridos entre aspas. Os números, não. Se números forem inseridos com aspas o R os entenderá como texto também.
- Além de textos e números, temos no vetor _sp_ valores lógicos, TRUE e FALSE. _logical_ é um tipo de dado do R (e é particularmente importante).
- O texto do primeiro título que coletei contém aspas. Como colocar aspas dentro de aspas sem fazer confusão? Se você delimitou o texto com aspas duplas, use aspas simples no texto e vice-versa.
- O que são os _NA_ no meio do vetor _caracteres_ e _sp_? Quando coletei as notícias, não contei os caracteres da terceira notícia e não notei se a segunda notícia mencionava São Paulo. _NA_ é o símbolo do R para __missing values__. Temos que lidar com eles o tempo todo na preparação de dados para a análise.

## Criando um data frame com vetores:

_data frames_ são um conjunto de vetores na vertical. Se você introduziu os valores em cada vetor na ordem correta de coleta dos dados, então eles podem ser __pareados__ e __combinados__. No meu exemplo, a primeira posição de cada vetor contém as informações sobre a primeira notícia, a segunda posição sobre a segunda notícia e assim por diante.

Obviamente, se estiverem pareados, os vetores devem ter o mesmo comprimento. Há uma função bastante útil para checar o comprimento:
  
```{r}
length(jornal)
```

Vamos criar com os vetores que construímos um _data frame_ com o nome _dados_. Vamos produzí-lo, discutir a função _data.frame_ e depois examiná-lo:
  
```{r}
dados <- data.frame(jornal,
                    data_noticia,
                    titulo,
                    autor,
                    caracteres,
                    investimento,
                    sp)
```

Usando as funções que aprendemos na aula anterior, podemos inspecionar o novo data frame:
  
```{r}
# 6 primeiras (e unicas, no caso) linhas
head(dados)

# Estrutura do data frame
str(dados)

# Nome das variaveis (colunas)
names(dados)

# Dimensoes do data frame
dim(dados)
```

O que é, afinal, um data frame? É um conjunto de vetores de mesmo tamanho e pareados dispostos na vertical. Formalmente, é uma _lista_ de vetores de mesmo tamanho e pareados.

# Tipos de dados em R e vetores

Há diversos tipos de dados que podem ser armazenados em vetores: __doubles__, __integers__, __characters__, __logicals__, __complex__, e __raw__. Neste tutorial, vamos examinar os 3 mais comumente usados na análise de dados: _doubles_, _characters_, _logicals_.

## Doubles

_doubles_ são utilizados para guardar números. Por exemplo, o vetor _caracteres_, que indica o número de caracteres em cada texto, é do tipo _double_. Vamos repetir o comando que cria este vetor (agora sem o NA, que foi substituído pelo valor coletado):
  
```{r}
caracteres <- c(10977, 5017, 2980, 2561)
```

Com a função _typeof_ você consegue descobrir o tipo de cada vetor:
  
```{r}
typeof(caracteres)
```

É possível fazer operações com vetores númericos ( _integers_ também são vetores numéricos, mas vamos esquecer deles por enquanto e fazer _double_ sinônimo de numérico). Por exemplo, podemos somar 1 a todos os seus elementos, dobrar o valor de cada elemento ou somar todos:
  
```{r}
caracteres + 1
caracteres * 2
sum(caracteres)
```

Note que as duas primeiras funções retornam vetores de tamanho igual ao original, enquanto a aplicação da função _sum_ a um vetor retorna apenas um número, ou melhor, um __vetor atômico__ (que contém um único elemento).

Tal como aplicamos as operações matemáticas e a função _sum_, podemos aplicar diversas outras operações matemáticas e funções que descrevem de forma sintética os dados (média, desvio padrão, etc) a vetores numéricos. Veremos operações e funções com calma num futuro breve.

## Logicals

O vetor _investimento_ também é do tipo _double_. Mesmo registrando apenas a presença e ausência de uma característica, os valores inseridos são números. Mas o vetor _sp_? Vejamos:
  
```{r}
typeof(investimento)
typeof(sp)
```

Em vez de armazenarmos a sim/não, presença/ausência, etc com os números 0 e 1, podemos em R usar o tipo _logical_, cujos valores são 'TRUE' e 'FALSE' (ou 'T' e 'F' maiúsculos, para poupar tempo e dígitos). Utilizaremos vetores lógicos em R com muita frequência.

O que acontece se fizermos operações matemáticas com vetores lógicos?
  
```{r}
video + 1
```

Automaticamente, o R transforma FALSE em 0 e TRUE em 1 se forem utilizados em uma operação matemática.

## Character

Finalmente, vetores que contêm texto são do tipo _character_. O nome dos jornais, data, título e autor são informações que foram inseridas como texto (lembre-se, o R não sabe por enquanto que no vetor _data\_noticia_ há uma data). Aritmética não vale para estes vetores.

## Tipo é diferente de classe

Veremos em momento oportuno que os objetos em R também tem um atributo denominado __class__. A classe diz respeito às características dos objetos enquanto tipo diz respeito ao tipo de dado armazenado. No futuro ignoraremos o tipo e daremos mais atenção à classe, mas é sempre bom saber distinguir os tipos de dados que podemos inserir na memória do computador usando R.

# Voltando ao zero - O básico do R

Começamos em data frames, passamos por vetores e agora vamos ao 'zero' para aprender sobre os aspectos elementares da linguagem R.

## Operações matemáticas em R

R serve como calculadora é bastante simples realizar operações matemáticas.

Soma:

```{r}
42 + 84
```

Subtração:

```{r}
84 - 42
```

Multiplicação

```{r}
42 * 2
```

Divisão:

```{r}
42 / 6
```

Potência:

```{r}
2 ^ 5
```

Divisão inteira (sem resto):

```{r}
42 %/% 5
```

Resto da divisão:

```{r}
42 %% 5
```

Nos exemplos acima realizamos operações bastante simples sem usar objetos, ou, como costumamos chamar, variáveis. Note que há dois usos para a palavra "variável". O primeiro deles, que vimos nos tutoriais anteriores, é o sinônimo de coluna em um _data frame_, e registra uma característica específica para todas as observações (por exemplo, a coluna com idade em um _data frame_ com informações sobre indivíduos).

O outro uso é sinônimo de objeto no R. Nos referimos à "variável x", quando atribuímos algo -- um número ou um texto, por exemplo -- a "x". 

Nos tutoriais, vamos fazer uso de variável com ambos significados. Com o tempo você se acostumará.

Voltando às operações matemáticas, vamos criar uma variável "x" com o valor 42. Ao criar uma variável que armazena apenas um número, estamos criando um escalar ou vetor atômico (pois vetores atômicos são os vetores de tamanho 1).

```{r}
x <- 42
```

Podemos imprimir o valor de uma variável no console simplesmente digitando seu nome:

```{r}
x
```

Em várias outras linguagens, e em R inclusive, usa-se a função _print_ para imprimir os valores de uma variável:

```{r}
print(x)
```

Quando usar print? Veremos no futuro que, dependendo da situação (por exemplo, dentro de funções ou loops), é preciso explicitar que queremos "imprimir" algo no console, e, nestes casos, usamos a função _print_.

Vamos criar mais uma variável, y, e fazer operações com variáveis:

```{r}
y <- 5
x + y
x - y
x / y
x * y
```

Podemos armazenar o resultado de uma operação matemática em uma variável. Veja os exemplos:

```{r}
z1 <- 42 / 3
z2 <- x + y
z3 <- ((x / 5 ) * 9) + 32
```

Veja que na última operação utilizamos diversos parênteses. (Ei! A fórmula acima é conhecida, não?) As regras para o uso de parênteses em R nas operações matemáticas são semelhantes às da aritmética "de papel e caneta". Os parênteses são executados sempre de dentro para fora. Aliás, essa regra vale em geral no R, ou seja, para aplicação de quaisquer funções, e não apenas para as operações matemáticas.

## Classes dos vetores atômicos

Há três __classes__ fundamentais para os vetores atômicos. Vamos criar três variáveis e examinar suas classes:

```{r}
numero <- 3.14
texto <- 'A cajuína cristalina em Teresina'
logico <- TRUE
```

Usamos a função _class_ para examinar a classe de um objeto:

```{r}
class(numero)
class(texto)
class(logico)
```

Auto-explicativo, certo?

## Mais um pouco sobre vetores

Aproveitando o embalo dos vetores atômicos, vamos ver um pouco mais sobre vetores de tamanho maior que 1. Alguns exemplos e suas classes:

```{r}
vetor_numerico <- c(42, 37, 999, 3.14, -232)
vetor_texto <- c('Peixe', "a", 'jota', "TRUE", "4")
vetor_logico <- c(TRUE, FALSE, F, F, T)
```

```{r}
class(vetor_numerico)
class(vetor_texto)
class(vetor_logico)
```

Detalhes para observarmos:

- No caso do vetor numérico, não importa se usamos números com casas decimais.
- Para vetores do tipo "character", não importa o que há dentro das aspas. Tudo é texto. E não importa se utilizamos aspas simples ou duplas.
- Você pode usar 'TRUE' ou 'T', 'FALSE' ou 'F', alternadamente. R entende o que você quer dizer. Lembre-se de sempre usar maiúsculas para informações do tipo 'logical'.

## Exercícios:

Qual é a classe dos vetores abaixo? Imprima o vetor com _print_ e tente advinhar. Use a função _class_ para descobrir a resposta.

```{r}
v1 <- c(1, 2, TRUE, 4)
v2 <- c("T", "TRUE", "FALSE", "T")
v3 <- c("1", "2", "3", "4")
v4 <- c(1, "4", 4, 1)
v5 <- c(1, 2, "feijao com arroz")
v6 <- c("SEADE", "CEPAM", TRUE)
v7 <- c(T, T, F, T, F, F, 42)
```

Você consegue identificar as regras de combinação de tipos de dados diferentes em um mesmo vetor? Se tiver dúvidas, pergunte.

## Operações matemáticas com vetores

Ei, você advinhou a fórmula de conversão de temperatura de celsius para farenheit um pouco acima no tutorial? Bem, vamos usá-la num exemplo.

Comecemos com um vetor de temperaturas médias dos meses de março a agosto em um lugar qualquer do hemisfério Sul (para podermos trabalhar com o final do ano e temperaturas negativas):

```{r}
temperatura_celsius <- c(30, 22, 13, 7, -3, 5)
```

Da mesma maneira que com vetores atômicos, podemos aplicar as operações matemáticas a vetores maiores. Por exemplo, vamos converter os valores do vetor "temperatura_celsius" para farenheit:

```{r}
temperatura_farenheit <- ((temperatura_celsius / 5) * 9) + 32
```

Veja que as operações são aplicadas a todos os elementos do vetor.

## Operações entre vetores

Criemos dois vetores, cada um registrando os gastos com sorvete e café de um pessoa de segunda a sexta, na ordem:

```{r}
cafe <- c(12, 4, 0, 8, 12)
sorvete <- c(0, 9, 0, 18, 9)
```
Operações entre vetores seguem a mesma lógica das operações com vetores atômicos e com vetores e números, com a ressalva de que as operações são realizadas "pareando" os elementos dos vetores. Dito de outra forma, ao somarmos dois vetores, por exemplo, o vetor resultante terá na primeira posição a soma dos elementos da primeira posição dos vetores originais, a segunda posição terá a soma dos elementos da segunda posição dos vetores originais e assim por diante. Executando o exemplo:

```{r}
soma_gastos <- cafe + sorvete
print(soma_gastos)
```

É bastante simples criar um vetor que seja a combinação de dois vetores. Por exemplo, tivermos um vetor com os gastos com alimentação em dias de semana e outros com os gastos com alimentação no final de semana, e queremos combinar ambos em um único vetor fazemos:


```{r}
dia_de_semana <- c(32, 25, 18, 23, 17)
fim_de_semana <- c(60, 74)
semana_completa <- c(dia_de_semana, fim_de_semana)
```

## Subconjunto de um vetor

E se quisermos extrair elementos em apenas uma ou algumas posições de um vetor?

(Ei, esta é uma parte bem importante da linguagem R! Faça com calma, por mais boba que pareça).

Quando queremos selecionar elementos de um vetor (ou, no futuro, de uma matriz ou de um _data frame_) usamos colchetes [] ao final do objeto. Vetores são objetos com uma única dimensão, então tudo que precisamos fazer para gerar um subconjunto é colocar o número da posição que queremos dentro dos colchetes.

Para extrair o primeiro dia do vetor com dados da semana completa (que, no nosso exemplo, começa na segunda-feira):

```{r}
semana_completa[1]
```

Ou, para extrair o final de semana (domingo na posição 1 e sábado na posição 7):

```{r}
semana_completa[c(6, 7)]
```

Ou ainda, os dias úteis da semana:

```{r}
semana_1[1:5]
```

Note que podemos gerar um vetor que é uma sequência numérica usando ':'.

## Soma, média e estatísticas descritivas dos elementos de um vetor

Ao longo do tempo, nosso repertório de funções de R aumentará rapidamente. Há um conjunto de funções fáceis de lembrar que são muito úteis para calcular estatísticas descritivas de um vetor (ou de uma variável em um _data frame_). Exemplo: seu consumo de litros de café por mês em 2019.

```{r}
litros_cafe <- c(4.3, 3.1, 5.3, 5.5, 6.9, 8.3, 9.7, 9.9, 9.1, 7.0, 6.2, 5.6)
```

Observe as funções de soma, media, desvio padrão, variância, mediana, máximo, mínimo e quantil, na respectiva ordem:

```{r}
sum(litros_cafe)
mean(litros_cafe)
sd(litros_cafe)
var(litros_cafe)
median(litros_cafe)
max(litros_cafe)
min(litros_cafe)
quantile(litros_cafe, probs = c(0, 0.25, 0.5, 0.75, 1))
```

Veja que, com a exceção de _quantile_, todas as funções retornam vetores atômicos. _quantile_ retorna um vetor do tamanho do vetor de probabilidades, que é o segundo argumento da função, e que indica os quantis correspondentes a cada valor.

Note também que o vetor utilizado nas operações não contém nenhum valor faltante, _NA_ (_missing value_). Caso houvesse, precisaríamos utilizar o argumento _na.rm = TRUE_, que removeria todos os _NAs_ do vetor antes de produzir a operação.

Vamos refazer o exemplo com um 'NA' no mês de agosto:

```{r}
litros_cafe <- c(4.3, 3.1, 5.3, 5.5, 6.9, 8.3, 9.7, NA, 9.1, 7.0, 6.2, 5.6)
```

Vamos observar o resultado para soma e média com _na.rm = FALSE_ (que é o padrão da função, e,  portanto, não precisa ser escrito):

```{r}
sum(litros_cafe)
mean(litros_cafe)
```

Finalmente, vamos inserir o argumento _na.rm = TRUE_:

```{r}
sum(litros_cafe, na.rm = TRUE)
mean(litros_cafe, na.rm = TRUE)
```

## Subconjunto de um vetor - parte 2

É possível nomear um vetor em R com a função _names_:

```{r}
litros_cafe <- c(4.3, 3.1, 5.3, 5.5, 6.9, 8.3, 9.7, 9.9, 9.1, 7.0, 6.2, 5.6)

meses <- c("Janeiro", "Fevereiro", "Marco", "Abril", "Maio", "Junho", 
           "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro")

names(litros_cafe) <- meses
```

Mas não dê muito atenção à nomeação de posições de um vetor agora, pois é pouco usual.

Vamos usar operadores relacionais (ao qual voltaremos no início do próximo tutorial) para produzir um exemplo de subconjunto mais interessante. A "Organização Mundial de Bebedores de Café", OMBC, recomenda que o consumo de café não ultrapasse o limite de até 7 litros por mês (ou seja, 7 inclusive). Vamos observar em quais meses de 2019 você tomou mais café do que deveria.

Criando um vetor lógico (TRUE ou FALSE) que indique em quais meses meu consumo ultrapassou o limite recomendado:

```{r}
selecao <- litros_cafe > 7
print(selecao)
```

Usamos o vetor "selecao" para fazer o subconjunto do vetor de dados de consumo de café:

```{r}
litros_cafe[selecao]
```

Para vetores pequenos, o procedimento adotado para gerar subconjuntos parece desnecessariamente trabalhoso. Mas imagine agora que você queira selecionar todos os municípios que atendam a determinada condição -- por exemplo, menos de 50 mil habitantes. Com uma variável (população) você pode gerar um vetor de seleção que permite gerar o subconjunto desejado de um data frame completo. Voltaremos a este no futuro.

