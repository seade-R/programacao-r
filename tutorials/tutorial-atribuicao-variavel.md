
A preferência por '<-' em vez de '=' para atribuir valores é uma combinação de razões históricas, clareza de intenção e convenção comunitária. Apesar disso, R permite o uso de ambos os operadores, dando flexibilidade aos programadores em seu estilo de codificação, embora o uso de '<-' seja encorajado em muitos guias de estilo e padrões de codificação dentro da comunidade R. Alguns exemplos de estilos de codificação que adotam preferencialmente o '<-' podem ser vistos [aqui](http://adv-r.had.co.nz/Style.html), [aqui](https://google.github.io/styleguide/Rguide.html), [aqui](https://style.tidyverse.org/) e [aqui](https://jef.works/R-style-guide/).


Há algumas razões para preferir <- a = para atribuição em R:

1) Tradição Histórica: O uso de '<-' como operador de atribuição é uma tradição que vem da linguagem S, que inspirou R. Os criadores de R optaram por manter consistência com S para facilitar a transição dos usuários de S para R.

2) Escopo e Estilo: Em R, '=' é usado preferencialmente para atribuir valores a argumentos dentro de funções e loops, enquanto '<-' é usado para atribuição de variáveis no ambiente global ou dentro de funções. Essa distinção ajuda a esclarecer a intenção do código, seja definindo uma variável ou passando um argumento para uma função.

3) Clareza e Distinção: '<-' oferece uma distinção clara entre atribuição e teste de igualdade ('=='). Embora '=' também possa ser usado para atribuição em R, '<-' torna o código mais legível, indica claramente a intenção de atribuir um valor a uma variável. Essa distinção é particularmente útil em um ambiente de computação estatística, onde a clareza do código é crucial.

4) Rigor e Intenção: Matematicamente falando, o sinal '=' não é rigoroso o suficiente na intenção do código. O fato de R ser escrito por estatísticos e majoritariamente para estatísticos transparece na preferência de '<-' a '='. Compare as seguintes atribuições de valores:

``` r
x = 1
y <- 2
```

Até aqui, não parece haver tanta diferença entre os símbolos de atribuição. Mas e se começarmos e complexificar a relação de nossos objetos? Por exemplo:

``` r
x = x / y
x <- x / y
```

De um ponto de vista de ciência de computação, os códigos ainda são os mesmos. O que o sinal de atribuição '=' faz é meramente alocar parte da memória de seu computador (ou, no nosso caso, do servidor) para os objetos 'x' e 'y'. 

Porém, de um ponto de vista matemático, estas relações _não_ são iguais!

Nos perguntemos: o que queremos dizer quando escrevemos 'x = x / y'? Lendo este pedaço de código isoladamente, sua intenção não é clara o suficiente. Por exemplo, será que estamos criando uma equação matemática, onde x = x / y? 

Portanto, quando escrevemos '<-' a _intenção_ de nosso código é muito mais clara: não estamos descrevendo uma função matemática, mas sim assinalando valores a objetos distintos. 


_Curiosidade_:

Quando dissemos que há 2 maneiras de atribuir valores a objetos, na verdade estávamos mentindo! Existe uma terceira forma, o operador '->', embora esteja em desuso sob um ponto de vista de estilo de escrita.

Dado o que aprendemos sobre a 'intenção' do usuário ao usar distintos símbolos de atribuição, veja o seguinte código:

``` r
w = 1
x = 2
x = w
y <- x
y -> z
```

Dada a existência dos formatos '<-' e '->' consegue perceber como o sinal de '=' pode ser ambíguo?

Quando escrevemos 'x = w' fica difícil de se entender quem está sendo modificado, x ou w. Porém, quando escrevemos 'y <- x' ou 'y -> z' claramente conseguimos identificar a intenção do código.

Lembre-se, uma das principais funções de um código é que ele seja facilmente legível. Isto ajuda não só seus colegas, mas também você mesmo no futuro. Nada é pior do que gastar tempo tentando compreender o que você fez no passado. Gastar alguns segundos a mais tornando seu código mais claro pode te salvar horas no futuro!

