# Programa de Estágio do SEADE - Introdução à Programação e Ciência de Dados para a Gestão Pública

Bem vindas e bem vindos ao curso de _Introdução à Programação e Ciência de Dados para a Gestão Pública_ do Programa de Estágio da Fundação SEADE.

## Informações básicas

* **Instrutor**: Lucas Gelape 
* **Monitor**: André Meyer
* **Local**: virtual
* **Data**: entre  14/02/2023 e 16/02/2023
* **Horário de início**:  9h (manhã) e 14h (tarde)

## Apresentação

O curso oferece uma iniciação à lógica de programação e ao uso da linguagem R para organização, análise e apresentação de dados. O foco do curso é o desenvolvimento da habilidade de programação para solução de problemas diversos relacionados ao manejo de dados, com ênfase na preparação de dados para análise e produção de estatísticas descritivas. 

O R é uma linguagem de código aberto (portanto, gratuito) e desenvolvimento comunitário e se tornou uma das linguagens de programação e análise de dados mais populares em diversos campos científicos e profissionais, especialmente naqueles que estão diretamente relacionados às atividades da Fundação Seade, como Ciências Sociais ou Economia. Dentre outros pontos, ela facilita o manuseio de grandes bancos de dados, a documentação do trabalho para correções e replicabilidade, e permite o uso de dados de diversos formatos (SPSS, Stata, Excel, dados espaciais etc).

Neste curso, pretendemos que os participantes tenham contato direto com a linguagem, compreendam alguns de seus fundamentos, consigam abrir/importar bancos de dados, organizá-los, e realizar algumas análises elementares, especialmente por meio do conjunto de pacotes do `tidyverse`. Para isso, os participantes serão expostos aos códigos seguidos de explicações e terão de resolver algumas atividades práticas (ou seja, escreverão códigos).

## Programa

[**Aula 01 (14/02)**: Entrando de cabeça](/turmas/2023_estagio_turma1/classes/class-01.md) 

Na primeira aula do curso nos habituaremos à linguagem R trabalhando com uma das gramáticas mais populares de manipulação de dados em R, a do pacote `dplyr`. O curso começa, assim, não pelos elementos básicos da linguagem R, mas pelo seu uso mais comum. Dessa forma, nos habituaremos à linguagem observando seu uso a problemas concretos.

* Uma apresentação ao R e ao RStudio
* Pacotes
* Começando pelo meio: manipulação de dados com o `dplyr`
  + Importação de dados
	+ Funções
	+ `mutate`
	+ `filter`
	+ `pull`
	+ `summarise`
	+ `arrange`

[**Aula 02 (15/02)**: Alguns passos atrás, de volta aos fundamentos](/turmas/2023_estagio_turma1/classes/class-02.md) 

Após termos aprendido sobre data frames, vamos fazer um percurso das funcionalidades básicas da linguagem até alguns de seus usos intermediários. O objetivo do percurso é criar um repertório de funções e utilidades da linguagem que serão utilizados adiante.

* Vetores
* Data.frames
* Objetos
* Tipos de dados
* Operações matemáticas
* Operadores relacionais 
* Operadores lógicos
*	Cláusulas condicionais
* Loop
* Boas práticas de redação de códigos
* Boas práticas de organização de trabalho

[**Aula 03 (16/02): Manuseio de dados com o `tidyverse`**](/turmas/2023_estagio_turma1/classes/class-03.md) 

Faremos o caminho de volta ao ponto de partida do curso: a manipulação de dados com a gramática do `dplyr`. Exploraremos agora aspectos diversos da manipulação de dados com mais rigor e profundidade. Além disso, veremos como trabalhar com dados relacionais em R.

* Revendo as funções do `dplyr`
* Importação de dados
* União de bancos de dados: as variedades de `_join`
* Coluna ou linha? As funções `pivot_` 

## Referências bibliográficas

-   Grolemund, Garrett (2014). _Hands-On Programming with R_. Ed: O'Reilly Media. Disponível gratuitamente [aqui](https://rstudio-education.github.io/hopr/).
-   Wichkam, Hadley e Grolemund, Garrett (2016). _R for Data Science_. Ed: O'Reilly Media. Disponível gratuitamente [aqui](http://r4ds.had.co.nz/data-visualisation.html).
-   Damiani, Athos et al. (2022). _Ciência de Dados em R_. Disponível gratuitamente [aqui](https://livro.curso-r.com/index.html).
-   Wichkam, Hadley (2016). _ggplot2: Elegant Graphics for Data Analysis_. Ed: O'Reilly Media. Disponível gratuitamente [aqui](https://ggplot2-book.org/).
-   Chang, Winston. _R Graphics Cookbook_. Ed: O'Reilly Media. Disponível gratuitamente [aqui](https://r-graphics.org/index.html).
-   James, Gareth; Witten, Daniela; Hastie, Trevor; e Tibshirani, Rob (2021). _An Introduction to Statistical Learning with Applications in R_. 2 ed. Ed. Springer. Disponível gratuitamente [aqui](https://hastie.su.domains/ISLR2/ISLRv2_website.pdf).

[The Big Book of R](https://www.bigbookofr.com/index.html) é um livro sobre os muitos livros gratuitos em R que você encontra na internet sobre temas variados e vale muito a pena dar uma olhada.