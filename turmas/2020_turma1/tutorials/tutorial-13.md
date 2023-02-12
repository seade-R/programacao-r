# Manipulação de dados com a gramática básica do R

A esta altura do campeonato, você já tem bastante recursos para programar em R. Você sabe o principal da gramática de manipulação de dados do _dplyr_. Além disso, combinando seu conhecimento sobre vetores, _data frames_, tipos de dados, loops, condicionais e funções dá para fazer um bocado de coisas legais. 

Não vimos ainda, porém, como manipular variáveis e observações em um _data frame_ com a gramática do pacote 'base', ainda muito encontrada e fundamental para se tornar uma usuária ou usuário avançado de R.

A "gramática" básica do R é pouco elegante e essa é era uma das barreiras ao aprendizado da linguagem no passado. Ela é bem mais confusa e "verbosa" (ou seja, tem que escrever muito para realizar pouco) do que as dos demais softwares de análise de dados e do que a gramática do _dplyr_. Mas sem conhecer como funciona a "gramática" básica da linguagem R, nossa capacidade de aprender mais no futuro fica limitada.

## Variáveis e data frames

Neste tutorial, vamos trabalhar com um banco de dados falso criado para a atividade.

Abra o banco de dados usando _read\_delim_:

```{r}
library(tidyverse)
url_fake_data <- "https://raw.githubusercontent.com/seade-R/programacao-r/master/data/fake_data.csv"
fake <- read_delim(url_fake_data, delim = ";", col_names = T)
```

Fakeland é uma democracia muito estável que realiza eleições presidenciais a cada 4 anos. Vamos trabalhar com o conjunto de dados falso de cidadãos de Fakeland que contém informações sobre suas características básicas e opiniões / posições políticas (falsas). A descrição das variáveis está abaixo:

- _age_: idade
- _sex_: sexo
- _educ_: nível educacional
- _income_: renda mensal medida em dinheiro falso (FM \ $)
- _savings_: Dinheiro falso total (FM \ $) na conta de poupança
- _marriage_: estado civil (sim = casado)
- _kids_: número de filhos
- _party_: afiliação partidária
- _turnout_: intenção de votar nas próximas eleições
- _vote\_history_: número de eleições presidenciais votou desde as eleições de 2002
- _economy_: opinião sobre o desempenho da economia nacional
- _incumbent_: opinião sobre o desempenho do presidente
- _candidate_: candidato preferido

## Exercício

Utilize as funções que você já conhece -- _head_, _dim_, _names_, _str_, etc -- para conhecer os dados. Quantas linhas há no _data frame_? Quantas colunas? Como estão armazenadas cada variável (tipo de dados e classe dos vetores colunas)?

## Data frame como conjunto de vetores

Anteriormente construímos um _data frame_ a partir de vetores de mesmo tamanho e "pareados", ou seja, com as posições das informações representando cada observação. Para trabalhar com variáveis do _data frame_ como vetores usamos o símbolo "$" separando o nome do _data frame_ da variável. Por exemplo, escrevemos fake\$age para indicar a variável "age" no _data frame_ "fake":

```{r}
print(fake$age)
```

Podemos fazer uma cópia do vetor "age" que não seja variável do "fake"? Sim:

```{r}
idade <- fake$age
print(idade)
```

Porque não podemos simplesmente usar "age" e precisamos colocar o nome do _data frame_ seguido de "$" para indicar o vetor do conjunto de dados? Por que podemos ter mais de um _data frame_ no mesmo __Environment__ com uma variável de nome "age". Pense no _data frame_ + nome da variável como um endereço composto da variável no seu Environment, que evita ambiguidade. Para quem está aconstumada a trabalhar com SPSS, Stata ou SAS, ter que indicar qual é o _data frame_ ao qual a variável pertence parece estranho, mas faz todo sentido para o R.

Outros exemplos simples de como usar variáveis de um _data frame_ em outras funções (algumas das quais veremos no futuro, mas você já pode ir se acostumando à linguagem).

Gráfico de distribuição de uma variável contínua:

```{r}
plot(density(fake$age), main = "Distribuição de Idade", xlab = "Idade")

```

Gráfico de dispersão de duas variáveis contínuas:

```{r}
plot(fake$age, fake$savings, main = "Idade x Poupança", xlab = "Idade", ylab = "Poupança")
```

Tabela de uma variável categórica (contagem):

```{r}
table(fake$party)
```

Tabela de duas entradas para duas variávels categóricas (contagem):

```{r}
table(fake$party, fake$candidate)
```

No começo pode parecer um pouco irritante usar o "endereço" completo da variável, mas você logo se acostuma.

## Dimensões em um data frame

Tal como uma matriz, um _data frame_ tem duas dimensões: linha e coluna. Se queremos selecionar elementos de um _data frame_, podemos usar colchetes separados por uma vírgula, e inserir antes da vírgula uma seleção de linhas e depois da vírgula uma seleção de colunas -- [linhas, colunas]. Vejamos alguns exemplos de seleção de linhas:

Quinta linha fazemos:

```{r}
fake[5, ]
```

Quinta e a oitava linhas:

```{r}
fake[c(5,8), ]
```

As linhas 4 a 10:

```{r}
fake[4:10,]
```

Agora alguns exemplos de colunas. Segunda coluna:

```{r}
fake[, 2]
```

Note que o resultado é semelhante ao de:

```{r}
fake$sex
```

No entanto, no primeiro caso estamos produzindo um _data frame_ de uma única coluna, enquanto no segundo estamos produzinho um vetor. Exceto pela classe, são idênticos.

Segunda e sétima colunas:

```{r}
fake[, c(2,7)]
```

Três primeiras colunas:

```{r}
fake[, 1:3]
```

## Exercício

Qual é a idade do 17o. indivíduo? Qual é o candidato de preferência do 25o. indivíduo?

## Seleção de colunas com nomes das variáveis

Neste _data frame_ as linhas não têm nomes (mas poderiam ter). As colunas, no entanto, sempre têm. A regra é trabalharmos com muito mais linhas do que colunas e por esta razão os nomes das colunas costumam ser mais úteis do que os das linhas. Podemos usar os nomes das colunas no lugar de suas posições para selecioná-las.

```{r}
fake[, c("age", "income", "party")]
```

Mas o código seguinte não é válido, pois o operador ":" serve somente para gerar sequências de números inteiros.

```{r, error = T}
fake[, "age":"sex"]
```

Frequentemente, há um número grande de colunas desnecessárias em bancos de dados públicos. Para liberar memória do computador e trabalhar com um _data frame_ menor, fazemos uma seleção de colunas exatamente como acima, seja usando sua posição ou seu nome e geramos um _data frame_ novo (ou sobrescrevemos o atual). Veja um exemplo com "fake":

```{r}
new_fake <- fake[, c("age", "income", "party", "candidate")]
```

E se quiseremos todas as colunas menos "turnout" e "vote_history"? Podemos usar a função _setdiff_, que gera a diferença entre dois vetores, por exemplo, o vetor com todos os nomes de colunas (gerado com a função _names_) e o vetor com as colunas que desejamos excluir. Vamos guardar o resultado em "new\_fake2"

```{r}
selecao_colunas <- setdiff(names(fake), c("turnout", "vote_history"))
print(selecao_colunas)
new_fake2 <- fake[,selecao_colunas]
```

## Selecionando linhas com operadores relacionais

No item acima fizemos uma seleção de colunas nos dados usando os nomes das colunas. Bancos de dados com muitas colunas, como os Censos Populacional e Escolar, ou o Latinobarômetro, não são tão comuns e raramente o número de colunas ultrapassa as poucas centenas.

O que fazer, então, com as linhas, que são normalmente muito mais numerosas, as vezes na casa dos milhões? Precisamos utilizar operadores relacionais. Vamos fazer isso dando passos curtos para entendermos todo o processo.

Vamos supor que queremos selecionar apenas os indivíduos que pretendem votar na próxima eleição (variável "turnout"). Podemos gerar um vetor lógico que represente essa seleção:

```{r}
fake$turnout == "Yes"
```

Vamos guardar esse vetor lógico em um objeto denominado "selecao\_linhas"

```{r}
selecao_linhas <- fake$turnout == "Yes"
print(selecao_linhas)
```

Agora, podemos inserir esse vetor lógico na posição das linhas dentro dos colchetes para gerar um novo conjunto de dados que atenda à condição (intenção de votar):

```{r}
fake_will_vote <- fake[selecao_linhas, ]
```

Basicamente, para fazermos uma seleção podemos usar a posição das linhas (ou das colunas), seus nomes ou um vetor lógico do mesmo tamanho das linhas (ou colunas). Sequer precisamos fazer o passo a passo acima. Veja um exemplo que gera um _data frame_ de indivíduos que se identificam como "Independent":

```{r}
fake_independents <- fake[fake$party == "Independent", ]
```

Podemos, obviamente, combinar condições e usar os operador lógicos ("ou", "e" e "não") para fazer seleções mais complexas:

```{r}
fake_married_young_no_college <- fake[fake$marriage == "Yes" & 
                                       fake$age <= 30 & 
                                       !(fake$educ == "College Degree or more"), ]
```

## Exercício

Produza um novo _data frame_ com apenas 5 variáveis -- "sex", age", "income", "economy" e "candidate" -- e que contenha apenas eleitores homens, ricos ("income" maior que FM\$ 3 mil, que é dinheiro pra caramba em Fakeland) e inclinados a votar no candidato "Trampi".

Quais as dimensões do novo _data frame_? Qual é a idade média dos eleitores no novo _data frame_? Qual é a soma da renda no novo _data frame_?

## Criando uma nova coluna

Criar uma nova coluna em um _data frame_ é trivial. Por exemplo, vamos criar a coluna "vazia", onde colocaremos apenas "missing values", que são representados no R por "NA"

```{r}
fake$vazia <- NA
```

Podemos criar uma coluna a partir de outra(s). Por exemplo, vamos criar duas novas colunas, "poupança", que será igual a coluna "savings" mas em real (cotação de um FM\$ -- fake money -- é R\$ 17) e a coluna "savings\_year", que será a divisão de "savings" por anos do indíviduo a partir dos 18.

```{r}
fake$poupanca <- fake$savings / 17
fake$savings_year <- fake$savings / (fake$age - 18)
```

Você pode fazer qualquer operação com vetores que vimos em tutoriais anteriores para criar novas variáveis. A única imposição é que os vetores tenham sempre o mesmo tamanho, o que não é um problema em um _data frame_.

Se quiser substituir o conteúdo de uma variável em vez de gerar uma nova, o procedimento é o mesmo. Basta atribuir o resultado da operação entre vetores à variável existente, tal qual no exemplo, que transforma "age" em uma variável medida em meses:

```{r}
fake$age <- fake$age  * 12
```

Vamos ver agora como substituir valores em uma variável para depois aprendermos a recodificarmos variáveis.

## Substituindo valores em um variável

Vamos "traduzir" para o português a variável "party". Faremos isso alterando cada uma das categorias individualmente e, por enquanto, sem usar nenhuma função que auxilie a substituição de valores. Começemos com uma tabela simples da variável "party"

```{r}
table(fake$party)
```

Agora, observe o resultado do código abaixo:

```{r}
fake$party[fake$party == "Independent"]
```

Fizemos um subconjunto de apenas uma variável do _data frame_, e não do _data frame_ todo. Note a ausência da vírgula dentro dos colchetes. Se atribuirmos algo a essa selação, por exemplo, o texto "Independente", substituiremos os valores da seleção:

```{r}
fake$party[fake$party == "Independent"] <- "Independente"
```

Observe o resultado na tabela:

```{r}
table(fake$party)
```

## Exercício

Traduza para o português as demais categorias da variável "party".

## Substituição com o comando replace

O procedimento de substituir valores em uma mesma variável pode ser alternativamente realizado com a função _replace_. Vamos traduzir para o português a variável "sex"

```{r}
fake$sex <- replace(fake$sex, fake$sex == "Female", "Mulher")
fake$sex <- replace(fake$sex, fake$sex == "Male", "Homem")
table(fake$sex)
```

## Recodificando uma variável

Vamos supor que não nos interessa trabalhar com renda ("income") como variável contínua. Vamos transformá-la na variável "rich", que receberá valor "rich" se a renda for maior que FM\$ 3 mil e "not rich" caso contrário. Seguiremos o seguinte procedimento: criaremos uma variável com "missing values"; substituiremos os valores para os indivíduos ricos; e depois substituiremos os valores para os não-ricos. Note que a seleção da variável "rich" para a substituição de valores é feita utilizando a variável "income":

```{r}
fake$rich <- NA
fake$rich[fake$income > 3000] <- "rich"
fake$rich[fake$income <= 3000] <- "not rich"
table(fake$rich)
```

## Exercício

Utilize o que você aprendeu sobre transformações de variáveis neste tutorial e o sobre fatores ("factors") no tutorial 2 para transformar a variável "rich" em um fator.

## Exercício (mais um)

Crie a variável "kids2" que indica se o indivíduo tem algum filho (TRUE) ou nenhum (FALSE). Dica: essa é uma variável de texto, e não numérica.

## Recodificando uma variável contínua com a função cut

Quando vamos recodificar uma variável contínua para uma variável categórica, podemos usar a função _cut_. Vamos repetir o exemplo da criação da variável "rich", agora com "rich2":

```{r}
fake$rich2 <- cut(fake$income, 
                  breaks = c(-Inf, 3000, Inf), 
                  labels = c("não rico", "rico"))
table(fake$rich2)
```

Algumas observações importantes: (1) se a nova variável tiver 2 categorias, precisamos de 3 "break points"; (2) "-Inf" e "Inf" são os símbolos do R para menos e mais infinito, respectivamente; por padrão, o R não inclui o primeiro "break point" na primeira categoria, exceto se o argumento "include.lowest" for alterado para TRUE; (3) também por padrão, os intervalos são fechados à direita, e abertos à esquerda (ou seja, incluem o valor superior que delimita o intervalor, mas não o inferior), exceto se o argumento "right" for alterado para FALSE.

## Exercício

Crie a variável "poupador", gerada a partir de savings\_year (que criamos anteriormente), e que separa os indivíduos que poupam muito (mais de FM/$ 1000 por ano) dos que poupam pouco. Use a função _cut_.

## Recodificando uma variável contínua com a função recode

O equivalente da função _cut_ para variáveis categóricas, estejam elas como texto ou como fatores, é a função _recode_ (do pacote _dplyr_ no tidyverse). Seu uso é simples e intuitivo. Vamos recodificar como exemplo a variável "educ":

```{r}
fake$college <- recode(fake$educ, 
                       "No High School Degree" = "No College",
                       "High School Degree" = "No College",
                       "College Incomplete" = "No College",
                       "College Degree or more" = "College")

table(fake$college)
```

Podemos comparar as mudanças com uma tabela de 2 entradas:

```{r}
table(fake$college, fake$educ)
```

## Exercício

Crie a variável "economia", que os indivíduos que avaliam a economia (variável "economy") como "Good" ou "Very good" recebem o valor "positivo" e os demais recebem "negativo".

## Ordenar linhas e remover linhas duplicadas:

Finalmente, vamos ordenar linhas em um banco de dados e aprender a remover duplicidades. Com a função _order_, podemos gerar um vetor que indica qual a posição que cada linha deveria receber no ordenamento desejado. Vamos ordernar "fake" por renda.

```{r}
ordem <- order(fake$income)
print(ordem)
```

Se aplicarmos um vetor numérico com um novo ordenamento à parte destinada às linhas no colchetes, receberemos o _data frame_ ordenado:

```{r}
fake_ordenado <- fake[ordem, ]
head(fake_ordenado)
```

Poderíamos ter aplicado a função order diretamente dentro dos colchetes:


```{r}
fake_ordenado <- fake[order(fake$income), ]
```

Para encerrar, vamos duplicar articialmente parte dos nossos dados (as 10 primeiras linhas) usando o comando _rbind_, que "empilha" dois _data frames_:

```{r}
fake_duplicado <- rbind(fake, fake[1:10, ])
```

Vamos ordenar para ver algumas duplicidades:

```{r}
fake_duplicado[order(fake_duplicado$income), ]
```

E agora removemos da seguinte maneira:

```{r}
fake_novo <- fake_duplicado[!duplicated(fake_duplicado),]
```

Note que precisamos da exclamação (operador lógico "não") para ficar com todas as linhas __não__ duplicadas.

## Renomeando variáveis

Em breve veremos como renomear variáveis de uma maneira bastante mais simples. Por enquanto, vamos aprender o jeito trabalhoso de renomear um variável.

Podemos observar os nomes das variáveis de um _data frame_ usando o comando _names_:

```{r}
names(fake)
```

Os nomes das colunas são um vetor. Para renomear as variáveis, basta substituir o vetor de nomes por outro. Por exemplo, vamos manter todas as variáveis com o mesmo nome, exceto as três primeiras:

```{r}
names(fake) <- c("idade", "sexo", "educacao", "income", "savings", "marriage", "kids", "party", "turnout", "vote_history", "economy", "incumbent", "candidate", "vazia", "poupanca", "savings_year", "rich", "rich2", "college")
head(fake)
```

Você não precisa de um vetor com todos os nomes sempre que precisar alterar algum. Basta conhecer a posição da variável que quer alterar. Veja um exemplo com "marriage", que está na sexta posição:

```{r}
names(fake)[6] <- "casado"
```

Simples, porém um pouco mala.
