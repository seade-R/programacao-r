# A gramática do _dplyr_: mutate, summarise e group\_by

## Novos verbos e dados de survey

No tutorial passado vimos 3 dos principais verbos do _dplyr_: _rename_, _select_ e _filter_ (para seleção de casos). Não produzimos, entretanto, uma das operações mais importantes na manipulação de _data\_frames_: a transformação ou criação de varíáveis; a criação de sumários estatísticos; e o agrupamento de casos a partir de uma ou mais variáveis. 

Neste tutorial, aprederemos um pouco mais sobre a gramática do _dplyr_ utilizando mais alguns de seus verbos. Aprenderemos sobre os verbos _mutate_, _summarise_, _group\_by_, ademais de alguns outros menos essenciais, porém importantes, como _arrange_ e _slice_.

Comece carregando o pacote _tidyverse_, que contém o pacote _dplyr_.

## COVID-19 no Estado de São Paulo

Durante a pandemia de COVID-19 o SEADE passou a dar suporte ao Governo do Estado de São Paulo para a produção, organização e publicização de dados sobre a crise. Uma das bases que o SEADE organizou e levou a público foi a de casos e óbitos por municípios.

Neste tutorial, trabalharemos com uma versão reduzida e levemente modificada (sem acentos) deste conjunto de dados e extraída em 03 de Agosto de 2020. Os dados completos e atuais podem ser encontrados [aqui](https://github.com/seade-R/dados-covid-sp).

O conjunto de dados contém as seguintes informações:

|Variável|Descrição|
|---|---|
|nome_munic| Nome do município|
|codigo_ibge| Código do município no IBGE (7 dígitos)|
|datahora| Data no formato YYYY-MM-DD|
|casos| Casos totais registrados até a data|
|casos_novos| Casos novos registrados na data|
|obitos| Óbitos totais registrados até a data|
|obitos_novos| Óbitos novos registrados na data|
|nome_drs| Nome do Dpto. Regional de Saúde|
|pop| População Estimada (fonte SEADE)|

Cada linha contém, portanto, a infomação de uma combinação de município e data.

## Abrindo os dados de COVID-19 em São Paulo

Sua primeira tarefa é carregar os dados utilizando o botão (aaaaaargh!) "Import Dataset". Os dados estão no URL: https://raw.githubusercontent.com/seade-R/programacao-r/master/data/dados_covid_sp.csv. O separador (delimiter) é ponto e vírgula (semicolon) e você pode dar o nome de 'covid' a esta base.

Melhor do que o botão é utilizar a função _read\_csv2_:

```{r}
covid <- read_csv2('https://raw.githubusercontent.com/seade-R/programacao-r/master/data/dados_covid_sp.csv') 
```

Antes de avançar, utilize as funções que você aprendeu no tutorial anterior para examinar os dados. São elas: View, head, nrow, ncol, names e glimpse. Se habitue aos dados antes de prosseguir.

Dica: examine os últimos dias com tail, que é a versão de 'head' para examinar o fundo do data frame. Há muitos 0 nas primeiras observações e, infelizmente, números maiores vão aparececendo em datas mais recentes.

## Transformando e criando variáveis com mutate

Uma das tarefas mais comuns na preparação de dados para análise é a transformação de variáveis, seja para alterar uma variável já existente, seja para criar uma nova.

Na gramática do _dplyr_, o verbo que utilizamos para operações com variáveis é _mutate_.

Por exemplo, se quisermos criar uma variável de óbitos por COVID-19 acumulados _per capita_ para cada município do Estado de São Paulo, precisamos fazer uma razão entre o total de óbitos acumulados e a população. Vejamos como fazer isso com _mutate_:

```{r}
covid <- covid %>% 
  mutate(obitos_pc = obitos / pop)
```

'obitos\_pc' é o nome dado à nova variável que resulta da divisão, em cada uma das linhas, entre a variável 'obitos' e a variável 'pop'. Note que há uma coluna a mais em seu data frame.

Como fazer para checar se deu certo? Vamos usar o conhecimento do tutorial anterior para observar essa nova variável apenas para o município de São Paulo no dia 03 de Agosto de 2020. Vamos selecionar, portanto, apenas as linhas onde nome_munic é igual a 'Sao Paulo' (sem acento!!!!), data hora é igual a '2020-08-03' e, para facilitar a visualização, vamos manter apenas as colunas pertinentes:

```{r}
covid %>% 
  filter(nome_munic == 'Sao Paulo',
         datahora == '2020-08-03') %>% 
  select(nome_munic, datahora, obitos, pop, obitos_pc)
```

Pronto, produzimos um data frame de uma linha que contém o que queríamos observar.

## E o '<-' ?

Repare que não utilizamos o sinal de atribuição, '<-', na nossa última operação. Por não termos utilizado, nenhum objeto foi criado. Em vez disso, o resultado do código apareceu no Console. Foi impresso. E não foi armazenado.

É possível, portanto, utilizar os verbos do _dplyr_ para examinar os dados mesmo sem criar um novo objeto, como fizemos acima. Se o '<-' não é utilizado, nenhum objeto é criado, mas vemos seu resultado é impresso no Console.

## Voltando ao mutate

Em São Paulo no dia 03 de Agosto de 2020 havia 0.000812 óbitos por COVID-19 per capita. Há muitas casas decimais e nossa variável nova não ficou muito fácil de se lida. Vamos mudar a variável para 'óbitos por 100 mil habitantes', ou seja, vamos multiplicar a nova variável 'obitos_pc' por 100000:

```{r}
covid <- covid %>% 
  mutate(obitos_pc = obitos_pc * 100000)
```

Note que agora não estamos criando uma variável nova, mas transformando uma variável existente. Isso por que o nome 'obitos_pc' já estava ocupado, ou seja, já tinhamos uma variável com esse nome no conjunto de dados. A operação sobrescreve 'obitos_pc' por ela mesma multiplicada por 100 mil.

Podemos reutilizar o código anterior para examinar a variável transformada em São Paulo no dia 03 de Agosto de 2020:

```{r}
covid %>% 
  filter(nome_munic == 'Sao Paulo',
         datahora == '2020-08-03') %>% 
  select(nome_munic, datahora, obitos, pop, obitos_pc)
```

A informação agora é legível: havia 81.2 óbitos por COVID-19 para cada 100 mil habitantes.

Podemos incluir em um único comando de 


## Agrupando com _filter_ e _pull_

Vamos supor que nos interessa comparar a renda entre grupos de sexo. Poderíamos, rapidamente selecionar as linhas de um dos grupos de sexo com o verbo _filter_:

```{r}
fake %>%
  filter(sex == "Male") 
```

```{r}
fake %>%
  filter(sex == "Female") 
```

Com o comando _pull_, podemos 'retirar' de um data frame uma coluna e tratá-la como um vetor destacado. _pull_ é mais um (de vários) verbos do _dplyr_:

```{r}
fake %>%
  filter(sex == "Male") %>%
  pull(income)
```

E, se adicionarmos à 'pipeline' um comando simples de estatística descritiva -- média, por exemplo -- calculamos uma estatística para o grupo para o qual selecionamos com _filter_:

```{r}
fake %>%
  filter(sex == "Male") %>%
  pull(income) %>%
  mean()
```

Note que não utilizamos o símbolo de atribuição '<-' e, portanto, não armazenamos o resultado em nenhum objeto.

Note também que podemos adicionar à pipeline qualquer função que não seja 'verbo' do _dplyr_, como comando _mean_.

Essa estratégia funciona para calcular uma medida qualquer para um grupo. Mas, em geral, interessa 'sumarizar' um variável -- como renda -- por uma variável de grupo -- como sexo -- sem destacar cada uma das categorias. Vamos ver como fazer isso.

## _summarise_

Uma maneira altenartiva ao que acabamos de realizar é utilizar o verbo _summarise_. Com ele, não precisamos extrair a variável do data frame para gerar um sumário estatístico. Veja como é simples:

```{r}
fake %>%
  filter(sex == "Male") %>%
  summarise(media_homens = mean(income))
```

```{r}
fake %>%
  filter(sex == "Female") %>%
  summarise(media_mulheres = mean(income))
```

## Agrupando com _group\_by_ by e _summarise_

Para agrupar os dados por uma ou mais variáveis na 'gramática' do _dplyr_ utilizamos o verbo _group\_by_ em combinação com _summarise_. Veja um exemplo antes de detalharmos seu uso:

```{r}
fake %>%
  group_by(sex) %>%
  summarise(media_renda = mean(income))
```

Veja que o resultado é uma tabela de duas linhas que contém a média de renda para grupo de sexo. O primeiro passo é justamente indicar qual é a variável -- discreta -- pela qual queremos agrupar os dados. Fazemos isso com _group\_by_

Na sequência, utilizamos _summarise_ para criar uma lista das operações que faremos em outras variáveis ao agrupar os dados. Por exemplo, estamos calculando a média da renda, que aparecerá com o nome 'media\_renda', para cada um dos grupos de sexo.

Execute novamente o código acima e observe atentamente sua estrutura antes de avançar.

O verbo _summarise_ permite mais de uma operação por agrupamento. Por exemplo, podemos calcular o desvio padrao da renda, a media da idade ('age') e a soma do número de eleições nas quais votou ('vote\_history'):

```{r}
fake %>%
  group_by(sex) %>%
  summarise(media_renda = mean(income),
            stdev_renda = sd(income),
            media_idade = mean(age),
            soma_eleicoes = sum(vote_history))
```

Simples, não? O comando _summarise_ é bastante flexível e aceita diversas operações. Veremos as mais comuns adiante.

E se quisermos, agora, utilizar mais de uma variável para agrupar os dados? Por exemplo, e se quisermos agrupar por sexo e candidato de preferência, como fazemos?

Basta adicionar outra variável dentro do comando _group\_by_:

```{r}
fake %>%
  group_by(sex, candidate) %>%
  summarise(media_renda = mean(income))
```

Observe bem a estrutura dos resultados que obtivemos. Em primeiro lugar, o resultado é sempre um data frame. Sempre que estivermos preparando os dados para gerar tabelas ou com gráficos, como veremos no tutorial seguinte, produziremos um data frame para servir de 'input' para o gráfico ou tabela.

Em segundo, cada variável utilizada para agrupamento aparece como uma coluna diferente no novo data frame. Os dados estão 'colapsados' ou 'achatados' em um número de linhas que corresponde ao total de combinações de categorias das variáveis de agrupamento (por exemplo, "Female e Rilari", "Female e Trampi", etc).

Se pararmos para pensar, o data frame resultante do último comando tem exatamente o número de células de uma tabela de duas entradas ('crosstab'), mas as informações das margens da tabela estão como variáveis. Veremos como modificar isso adiante.

Finalmente, cada nova variável gerada com _summarise_ em nosso data frame 'achatado' recebe uma coluna. Para 'sumarizar' uma variável -- tirar média, somatória, contar, etc -- precisamos sempre de uma função de sumário.

## Funções de sumário estatístico

Vamos ver exemplos das funções de sumário estatístico mais utilizadas dentro do verbo _summarise_.

1- Média

```{r}
fake %>%
  group_by(sex) %>%
  summarise(media = mean(income))
```

2- Desvio padrão

```{r}
fake %>%
  group_by(sex) %>%
  summarise(desvpad = sd(income))
```


3- Mediana

```{r}
fake %>%
  group_by(sex) %>%
  summarise(mediana = median(income))
```

4- Quantis (no exemplo, quantis 10\%, 25\%, 75\%, 90\%)

```{r}
fake %>%
  group_by(sex) %>%
  summarise(quantil_10 = quantile(income, probs = 0.1),
            quantil_25 = quantile(income, probs = 0.25),
            quantil_75 = quantile(income, probs = 0.75),
            quantil_90 = quantile(income, probs = 0.9))
```

5- Mínimo e máximo

```{r}
fake %>%
  group_by(sex) %>%
  summarise(minimo = min(income),
            maximo = max(income))
```

6- Contagem e soma

```{r}
fake %>%
  group_by(sex) %>%
  summarise(contagem = n(),
            soma = sum(age))
```

Importante: quando houver algum "NA" (missing value) em uma variável numérica, é preciso utilizar o argumento "na.rm = TRUE" dentro da função de sumário. Veja como ficaria o código caso houvesse algum "NA":

```{r}
fake %>%
  group_by(sex) %>%
  summarise(media = mean(income, na.rm = TRUE))
```

A sessão Useful [Summary Functions](https://r4ds.had.co.nz/transform.html#summarise-funs) do livro R for Data Science traz uma relação mais completa de funçoes que podem ser usandas com summarise. O [“cheatsheet” da RStudio](https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf) oferece uma lista para uso rápido.

## Transformando um agrupamento em um "crosstab" e exportando

Vamos retomar o exemplo do agrupamento por duas variáveis, sexo e candidato de preferência:

```{r}
fake %>%
  group_by(sex, candidate) %>%
  summarise(media_renda = mean(income))
```

Esse formato não costuma ser o usual em apresentação de dados. O mais comum é termos a informação que consta em nossas duas primeiras colunas como margens em uma tabela de duas entradas.

Na linguagem de manipulação de dados, o resultado acima está no formato "long" e todas as variáveis são representadas como colunas. Uma tabela de 2 entradas corresponde ao formato "wide".

Há dois verbos no _dplyr_ que transformam "long" em "wide" e vice-versa: _spread_ e _gather_. Como _spread_, tranformamos o nosso resultado acima na tabela desejada:

```{r}
fake %>%
  group_by(sex, candidate) %>%
  summarise(media_renda = mean(income)) %>%
  spread(sex, media_renda)
```

_spread_ precisa de 2 argumentos: a "key", que a variável que irá para a margem superior da tabela, e "value", que é a variável que ficará em seu conteúdo.

É fácil, inclusive, exportá-la para um editor de planilhas com a função _write\_csv_ (do pacote _readr_) ao final do pipeline:

```{r}
fake %>%
  group_by(sex, candidate) %>%
  summarise(media_renda = mean(income)) %>%
  spread(sex, media_renda) %>%
  write_csv("tabela_candidato_sexo_renda.csv")
```

Vá à sua pasta de trabalho e verifique que sua tabela está lá.

Veja que, como introduzimos um comando de exportação ao final do pipelina, não geramos nenhum objeto. Não há símbolo de atribuição em nosso código. Esse é um dos objetivo do uso do pipe (%>%): reduzir o número de objetos intermediários gerados.

### Spread e Gather caindo em desuso

Há notícias de que os verbos _spread_ e _gather_ cairão em desuso. Seus substituos serão _pivot\_wider_ e _pivot\_longer_. As 4 funções são parte do pacote _tidyr_, componente do _tidyverse_. O uso das novas funções é bem similar ao das antigas, e veja como fica a substituição de _spread_ por _pivot\_wider_ no código que produzimos. É possível que sua instalação do _tidyverse_ não contenha as novas funções e que o código abaixo não funcione.

```{r}
fake %>%
  group_by(sex, candidate) %>%
  summarise(media_renda = mean(income)) %>%
  pivot_wider(names_from = sex,
              values_from = media_renda)
```

## Mutate com Group By

Vamos supor que queremos manter os dados no mesmo formato, ou seja, sem 'achatá-los' por uma variável discreta, mas queremos uma nova coluna que represente a soma de uma variável por grupo -- para calcular percentuais de renda dentro de cada grupo de sexo, por exemplo. Vamos observar o resultado do uso conjunto de _group\_by_ e _mutate_. Para podermos observar o resultado, vamos armazenar os novos dados em um objeto chamado 'fake2' e utilizar o comando _View_. A última coluna de nossos dados agora é a soma da renda dentro de cada grupo.

```{r}
fake2 <- fake %>% 
  group_by(sex) %>%
  mutate(renda_grupo = mean(income))

View(fake2)
```

Quando utilizarmos _group\_by_ sem o _summarise_, é importante "desagrupar" os data frame, ou "desligar o agrupamento". Caso contrário, o agrupamento continuará ativo e afetando todas as operações seguintes. Repetindo o código com o desagrupamento:

```{r}
fake2 <- fake %>% 
  group_by(sex) %>%
  mutate(renda_grupo = mean(income)) %>%
  ungroup()
```

## Mais verbos do _dplyr_: _arrange_ e _slice_

Se quisermos ordenar, de forma crescente, nossos dados por idade, por exemplo, basta usar o comando _arrange_:

```{r}
fake %>% 
  arrange(age)
```

Em ordem decrescente teríamos:

```{r}
fake %>% 
  arrange(-age)
```

Se quisermos 'desempatar' o ordenamento por idade por uma segunda variável, basta adicioná-la ao _arrange_:

```{r}
fake %>% 
  arrange(-age, vote_history)
```

Quando trabalhamos com bases de dados de survey faz pouco sentido ordená-las. Entretanto, quando trabalhamos numa escala menor, com poucas linhas, ou com a produção de tabelas, como nos exemplos acima, convém ordenar a tabela (veja que, neste ponto, faz pouco sentido diferenciar tabela de data frame, pois se tornam sinônimos) por alguma variável de interesse.

Por exemplo, podemos ordenar os grupos de candidato de preferência por média de renda:

```{r}
fake %>% 
  group_by(candidate) %>% 
  summarise(media_renda = mean(income)) %>% 
  arrange(media_renda)
```

Fácil e útil.

Finalmente, vamos supor que queremos extrair da base de dados apenas os 10 indivíduos de menor idade Como "recortar" linhas dos dados pela posição das linhas?

Em primeiro lugar, vamos ordenar os dados por idade. A seguir, vamos aplicar o verbo _slice_ para recortar as 10 primeiras linhas:

```{r}
fake %>% 
  arrange(age) %>% 
  slice(1:10)
```

Se quisessemos recortar do 25, por exemplo, ao último, sem precisar especificar qual é o número da última posição, utilizamos _n()_:

```{r}
fake %>% 
  arrange(age) %>% 
  slice(25:n())
```

Note que a aplicação de _slice_ não afeta em nada as colunas.

