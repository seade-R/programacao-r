# Lógica de programação em R: operadores relacionais e lógicos e controle de fluxo

## Operadores relacionais

Uma das especialidades do computador é verificar se proposições simples são verdadeiras ou falsas. __Operadores relacionais__ servem para verificar se objetos são iguais, diferentes, maiores ou menores. São seis operadores relacionais e a tabela abaixo apresenta os seus símbolos.

  | Operador       | Símbolo |
  | -------------- |:-------:| 
  | Igual          | ==      |
  | Diferente      | !=      |
  | Maior          | >       |
  | Maior ou igual | >=      |
  | Menor          | <       |
  | Menor ou igual | <=      |

Não discutiremos todas as regras de comparação de objetos, mas passaremos por um conjunto grande de exemplos a partir do qual elas podem ser inferidas.

Vamos começar com alguns exemplos simples:
  
```{r}
42 == 41
42 != 41
(2 + 2) == (3 + 1)
(2 + 2) != (3 + 1)
5 > 3
5 < 3
42 > 42
42 < 41
42 >= 42
42 <= 41
```

Antes de avançar, tenha certeza que entendeu os exemplos acima.

Operadores relacionais também vale para textos:
  
```{r}
"texto" == "texto"
"texto" == "texTo"
"texto" != "texto"
```

Note no segundo exemplo que o R é "case sensitive", ou seja, diferencia maiúsculas de minúsculas ao comparar textos.

Textos também podem ser ordenados (lexicograficamente, isto é, alfabeticamente):

```{r}
"a" > "b"
"a" < "b"
"A" < "b"
"A" > "a"
```

Inclusive palavras inteiras e sentenças:
  
```{r}
"Fundação SEADE" > "Fundação Nacional do Índio"
```

E valores lógicos? Observe os exemplos abaixo:
  
```{r}
TRUE == 1
FALSE == 0
TRUE > FALSE
```

Podemos comparar valores armazenados em variáveis da mesma maneira que fizemos nos exemplos acima:
  
```{r}
x <- 5
y <- 10
x > y
```

## Operadores relacionais e vetores

É possível comparar um vetor com um valor. Neste caso, cada elemento do vetor é comparado individualmente ao valor e o resultado é um vetor lógico de tamanho igual ao vetor comparado.

Abaixo temos vetor com a projeção da população de seiss municípios fictícios em 2020:

```{r}
pop20 <- c(200431, 15325, 49344, 80331, 9075, 39871)
```

Quais são os municípios com menos de 50 mil habitantes?

```{r}
pop20 < 50000
```

Vamos agora comparar com a população desses mesmos municípios em 2010, armazenadas em outra vetor com o mesmo ordenamento:
  
```{r}
pop10 <- c(190434, 18934, 45123, 83621, 8328, 36863)
```

Comparando:

```{r}
pop20 > pop10
```

Veja que, na comparação entre dois vetores, os elementos são comparados par a par de acordo com a sua posição no vetor. O vetor lógico resultante tem o mesmo tamanho dos vetores comparados.

## Operadores Lógicos (Booleanos)

É perfeitamente possível combinar proposições com os __operadores lógicos__ "e", "ou" e "não":
  
  | Operador | Símbolo |
  | -------- |:-------:| 
  | E        | &       |
  | Ou       | \|      |
  | Não      | !       |
  
Por exemplo, se queremos verificar quais municípios têm projeção da população em 2020 entre 10 e 50 mil habitantes, 10 mil inclusive e 50 exclusive:
  
```{r}
pop20 >= 10000 & pop20 < 50000
```

Veja a tabela de possibilidades de combinação de duas proposições com a conjunção "e":
  
  | Proposição 1 | Proposição 2 | Combinação | 
  | ------------ | ------------ | ---------- |
  | TRUE         | TRUE         | TRUE       |  
  | TRUE         | FALSE        | FALSE      |
  | FALSE        | TRUE         | FALSE      |
  | FALSE        | FALSE        | FALSE      |
  
Se o valor atende às duas condições, então o resultado é TRUE. Se ao menos uma proposição é falsa, sob a conjunção "e", então a combinação das proposições também é.

Com o operador "Ou", a combinação de proposições é verdadeira se pelo menos uma delas for verdadeira. Por exemplo, se quisermos municípios com projeção da população em 2020 menor do que 20 mil ou maior do que 100 mil:

```{r}
pop20 < 20000 | pop20 > 100000
```

Veja a tabela de possibilidades de combinação de duas proposições com a conjunção "ou":
  
  | Proposição 1 | Proposição 2 | Combinação | 
  | ------------ | ------------ | ---------- |
  | TRUE         | TRUE         | TRUE       |  
  | TRUE         | FALSE        | TRUE       |
  | FALSE        | TRUE         | TRUE       |
  | FALSE        | FALSE        | FALSE      |
  
Finalmente, o operador lógico "não" tem a função de reverter um proposição:
  
```{r}
!TRUE
!(5 > 3)
!(pop20 >= 10000 & pop20 < 50000)
```

Lembre-se que, quando trabalhamos com vetores lógicos, podemos tratá-los como se fossem zeros e uns. A soma de um vetor lógico é, portanto, a contagem de 'TRUE':
  
```{r}
sum(pop20 >= 10000 & pop20 < 50000)
```

## Cláusulas condicionais

Um dos usos mais importantes dos operadores relacionais e lógicos é na construção de __cláusulas condicionais__, "if", "else" e "else if". Elas são fundamentais para a construção de funções e algoritmos. Veja um uso simples do condicional _if_, para o cálculo do valor absoluto de uma variável:
  
```{r}
# exemplo com x negativo
x <- -23

if (x < 0){
  x <- -x
}

print(x)

# exemplo com x positivo
x <- 23

if (x < 0){
  x <- -x
}

print(x)
```

A condição que o _if_ deve atender vem entre parênteses. A instrução a ser atendida caso a cláusula seja verdadeira vem dentro das chaves. Aliás, é boa prática (na maioria dos casos) abrir as chaves em uma linha, escrever as instruções em outra, e fechar as chaves na linha seguinte ao final das instruções, como no exemplo. Também é boa prática "identar", ou seja, desalinhar as instruções do restante do código. Falaremos sobre "estilo" em algum momento do curso. Por enquanto, apenas observe e não se assuste. Diferentemente de outras linguagens, R não requer identação para funcionar corretamente.

## Repetindo tarefas - while loop

Uma das vantagens dos computadores em relação aos seres humanos é a capacidade de repetir tarefas a um custo baixo. Vamos ver um exemplo simples: contar até 42. Usaremos como recurso um _while_ loop, ou seja, daremos um estado inicial, uma condição e uma instrução para o computador e pediremos para ele repetir a instrução __enquanto__ a condição for atendida.

Em nosso caso, a instrução será: imprima o número "atual" (você já entenderá isso), armazenado na variável "contador", e some mais um. A condição será: enquanto a variável "contador" for menor ou igual a 42. Se vamos começar a contar a partir do 1, nosso estado inicial será igualar o "contador" a 1. Veja como fica o código:
  
```{r}
contador <- 1

while (contador <= 42) {
  print(contador)
  contador <- contador + 1
}

print(contador)

```

Traduzindo para o português: "enquanto o contador for menor ou igual a 42, imprima e some um". A estrutura de um _while_ loop é sempre: "enquanto" (condição), "faça" (instrução).

Veja que precisamos planejar muito bem o _while_ loop. Se, por exemplo, esquecermos de pensar como a condição inicial será alterada a cada __iteração__ (sem o "n" mesmo, pois é diferente de "interação"), corremos o risco de criar um "loop infinito". O critério de parada (condição entre parênteses) deve ser atendido em algum ponto do programa para que ele seja interrompido.

Vamos complicar. Seguiremos contando até 42, mas todas as vezes em que o número for par (ou seja, múltiplo de 2), deixaremos de imprimir o número. Como fazer isso? Com _if_.

Dica: para saber se um número é divisível por outro, basta usar o resto da divisão (consulte o tutorial anterior %%) e checar se é igual a zero.

```{r}
contador <- 1

while (contador <= 42) {
  if ((contador %% 2) != 0){
    print(contador)
  }
  contador <- contador + 1
}

print(contador)
```

Veja que temos agora um código "aninhado", pois colocamos um condicional dentro de um loop. Novamente, combinar estruturas de código é mais um problema de lógica do que de linguagem e, se você consegue fazer no papel, consegue traduzir para o R.

## Repetindo tarefas - for loop

E se em vez de repetir uma tarefa até atingir uma condição já soubermos quantas vezes queremos repetí-la? Neste caso, podemos usar o _for_ loop. O loop não será mais do tipo "enquanto (condição) faça (instrução)" mas "para todo i 'em' a até b faça (instrução)". Veja como o exemplo de contar até 42 ficaria com _for_ loop:
  
```{r}
for (i in 1:42){
  print(i)
}
```

Neste caso, lemos "para cada i 'em' 1 até 42, imprima i". O que o _for_ loop faz é variar o i a cada iteração de acordo com a sequência estabelecida. Outro exemplo, agora na ordem reversa:
  
```{r}
for (i in 10:-10){
  print(i)
}
```

Agora com a condição de não imprimir os pares:
  
```{r}
for (i in 1:42){
  if((i %% 2) != 0){
    print(i)
  }
}
```

_for_ loops não precisam ser apenas com números. Na verdade, você pode colocar após o "in" qualquer vetor. Por exemplo, um vetor das regiões brasileiras (ou UFs, se você tiver paciência de escrever todas):
  
```{r}
vetor_regioes <- c("norte", "nordeste", "sudeste","sul", "centro-oeste")

for (regiao in vetor_regioes){
  print(regiao)
}
```

Se você já trabalhou pesquisa repetidas com alguma peridicidade, você certamente teve de abrir diversos arquivos semelhantes, um para cada período. Ou ainda, se você já obteve informações na internet talvez tenha precisado "passar" por diversas páginas semelhantes. Loops resolvem problemas desse tipo: eles repetem procedimentos variando apenas um índice. Aprender a usar loops economiza um tempo enorme, pois conseguimos automatizar tarefas ou, pelo menos, escrever um código mais curto para aplicar o mesmo comando inúmeras vezes.

Vamos parar por aqui com _loops_ e voltaremos a eles para fazermos exercícios.

## Escrevendo funções

Ao longo dos três tutorais que fizemos usamos diversas funções e já estamos acostumados com elas. Vamos agora aprender a construir funções simples. Vamos do exemplo à aplicação. E nosso exemplo será, novamente, um conversor de farenheit para celsius:
  
```{r}
conversor <- function(farenheit){
  celsius <- ((farenheit - 32) / 9) * 5
  return(celsius)
}

conversor(212)
conversor(32)
```

Temos vários elementos no "construtor" de funções. Em primeiro lugar, criamos a função como criamos um objeto. Quer dizer, escolhemos um nome para ela e atribuímos a função criada a esse nome.

Para criar uma função, usamos _function_. Basicamente, o "construtor" tem duas partes: os argumentos da função, que inserimos no parênteses após _function_; e o corpo da função em chaves, que utiliza os argumentos para realizar uma tarefa e retorna um resultado, indicado pela função _return_.

## Exercício

Crie uma função chamada "quadrado" que recebe um número "x" e retorna o quadrado de x.

## Reposta

```{r}
quadrado <- function(x){
  resultado <- x * x
  return(resultado)
}

quadrado(4)
quadrado(17)
```

## Exercício

- Crie uma função que recebe um valor em reais e retorna o valor em dólares (use a 3.9 como cotação do dólar)
- Crie uma função que recebe um valor em reais e uma cotação do dólar e retorna o valor em dólares (ou seja, que contém 2 parâmetros).

## Paramos por aqui

Hoje percorremos um caminho longo no aprendizado da linguagem R. Vamos parar por aqui para respirar e assentar o que aprendemos.