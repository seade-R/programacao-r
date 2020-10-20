# A gramática do _dplyr_: mutate, summarise e group\_by

## Novos verbos e dados de survey

No tutorial passado vimos 3 dos principais verbos do _dplyr_: _rename_, _select_ e _filter_ (para seleção de casos). Não produzimos, entretanto, uma das operações mais importantes na manipulação de _data\_frames_: a transformação ou criação de varíáveis; a criação de sumários estatísticos; e o agrupamento de casos a partir de uma ou mais variáveis. 

Neste tutorial, aprederemos um pouco mais sobre a gramática do _dplyr_ utilizando mais alguns de seus verbos. Aprenderemos sobre os verbos _mutate_, _summarise_, _group\_by_, ademais de alguns outros menos essenciais, porém importantes, como _arrange_ e _slice_.

Comece carregando o pacote _tidyverse_, que contém o pacote _dplyr_.

```{r}
library(tidyverse)
```

## COVID-19 no Estado de São Paulo

Durante a pandemia de COVID-19 o SEADE passou a dar suporte ao Governo do Estado de São Paulo para a produção, organização e publicização de dados sobre a crise. Uma das bases que o SEADE organizou e levou a público foi a de casos e óbitos por municípios.

Neste tutorial, trabalharemos com uma versão reduzida e levemente modificada (sem acentos) deste conjunto de dados e extraída em 03 de Agosto de 2020. Os dados completos e atuais podem ser encontrados [aqui](https://github.com/seade-R/dados-covid-sp).

O conjunto de dados contém as seguintes informações:

|Variável|Descrição|
|---|---|
|nome_munic| Nome do município|
|codigo_ibge| Código do município no IBGE (7 dígitos)|
|nome_drs| Nome do Dpto. Regional de Saúde|
|datahora| Data no formato YYYY-MM-DD|
|casos| Casos totais registrados até a data|
|casos_novos| Casos novos registrados na data|
|obitos| Óbitos totais registrados até a data|
|obitos_novos| Óbitos novos registrados na data|
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

Na gramática do _dplyr_, o verbo que utilizamos para operações com variáveis é _mutate_. Há inúmeras transformações possíveis e elas lembram bastante as funções de outros softwares, como MS Excel.

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

## Não faltou o '<-' no código acima?

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

Podemos incluir em um único comando de mutate quantas transformações desejarmos, sempre separadas por vírgula:

```{r}
covid <- covid %>% 
  mutate(obitos_pc = (obitos / pop) * 100000,
         casos_pc = (casos / pop) * 100000,
         letalidade = obitos / casos)
```

Em outro momento veremos um conjunto de funções úteis em para transformar variáveis (recodificar, fazer substituições, mudar de tipo, discretizar, etc). Por enquanto, vamos nos concentrar no funcionamento do verbo.

## Agrupando com _filter_ e _pull_

Vamos supor que nos interessa observar os óbitos novos de uma região do Estado de São Paulo, os Departamentos Regionais de Saúde da Grande São Paulo. Poderíamos, rapidamente selecionar as linhas de um dos Departamentos Regionais de Saúde (DRS) com o verbo _filter_:

```{r}
covid %>%
  filter(nome_drs == "Grande Sao Paulo") 
```
Com o comando _pull_, podemos 'retirar' de um data frame uma coluna e tratá-la como um vetor destacado. _pull_ é mais um (de vários) verbos do _dplyr_:

```{r}
covid %>%
  filter(nome_drs == "Grande Sao Paulo") %>% 
  pull(obitos_novos)
```

E, se adicionarmos à 'pipeline' um comando simples de estatística descritiva -- soma ou média, por exemplo -- calculamos uma estatística para o grupo para o qual selecionamos com _filter_:

```{r}
covid %>%
  filter(nome_drs == "Grande Sao Paulo") %>% 
  pull(obitos_novos) %>% 
  sum()
```

Note que não utilizamos o símbolo de atribuição '<-' e, portanto, não armazenamos o resultado em nenhum objeto.

Note também que podemos adicionar à pipeline qualquer função que não seja 'verbo' do _dplyr_, como comando _mean_.

Essa estratégia funciona para calcular uma medida qualquer para um 'grupo' em uma variável categórica. Mas, em geral, interessa 'sumarizar' um variável -- como novos óbitos -- por uma variável de grupo -- como DRS -- sem destacar cada uma das categorias. Vamos ver como fazer isso.

## _summarise_

Uma maneira altenartiva ao que acabamos de realizar é utilizar o verbo _summarise_. Com ele, não precisamos extrair a variável do data frame para gerar um sumário estatístico. Veja como é simples:

```{r}
covid %>%
  filter(nome_drs == "Grande Sao Paulo") %>% 
  summarise(obitos_totais = sum(obitos_novos))
```

```{r}
covid %>%
  filter(nome_drs == "Baixada Santista") %>% 
  summarise(obitos_totais = sum(obitos_novos))
```

## Agrupando com _group\_by_ by e _summarise_

Para agrupar os dados por uma ou mais variáveis na 'gramática' do _dplyr_ utilizamos o verbo _group\_by_ em combinação com _summarise_. Veja um exemplo antes de detalharmos seu uso:

```{r}
covid %>%
  group_by(nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos))
```

Veja que o resultado é uma tabela de 17 linhas que contém a soma de óbitos para DRS. O primeiro passo é justamente indicar qual é a variável -- discreta -- pela qual queremos agrupar os dados. Fazemos isso com _group\_by_. No nosso exemplo a variável é 'nome_drs'.

Na sequência, utilizamos _summarise_ para criar uma lista das operações que faremos em outras variáveis ao agrupar os dados. Por exemplo, estamos calculando a soma dos óbitos, que aparecerá com o nome 'obitos\_totais', para cada uma das DRS.

Execute novamente o código acima e observe atentamente sua estrutura antes de avançar.

O verbo _summarise_ permite mais de uma operação por agrupamento. Por exemplo:

```{r}
covid %>%
  group_by(nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos),
            media_obitos = mean(obitos_novos),
            desvpad_obitos = sd(obitos_novos),
            maximo_obitos = max(obitos_novos),
            casos_totais = sum(casos_novos))
```

Simples, não? O comando _summarise_ é bastante flexível e aceita diversas operações. Veremos as mais comuns adiante.

E se quisermos, agora, utilizar mais de uma variável para agrupar os dados? Por exemplo, e se quisermos agrupar por DRS e data, como fazemos?

Basta adicionar outra variável dentro do comando _group\_by_:

```{r}
covid %>%
  group_by(datahora, nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos))
```

Como são muitas datas, não conseguimos observar adequadamente este resultado. Vamos utilizar 'filter' novamente para escolher uma única data, 01 de Agosto de 2020:

```{r}
covid %>%
  group_by(datahora, nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos)) %>% 
  filter(datahora == '2020-08-01')
```

Observe bem a estrutura dos resultados que obtivemos. Em primeiro lugar, o resultado é sempre um data frame. Sempre que estivermos preparando os dados para gerar tabelas ou com gráficos, como mais para frente, produziremos um data frame para servir de 'input' para o gráfico ou tabela.

Em segundo, cada variável utilizada para agrupamento aparece como uma coluna diferente no novo data frame. Os dados estão 'colapsados' ou 'achatados' em um número de linhas que corresponde ao total de combinações de categorias das variáveis de agrupamento.

Finalmente, cada nova variável gerada com _summarise_ em nosso data frame 'achatado' recebe uma coluna. Para 'sumarizar' uma variável -- tirar média, somatória, contar, etc -- precisamos sempre de uma função de sumário.

## Colocando ordem com _dplyr_: _arrange_ 

Vamos criar um data frame novo de óbitos e casos totais por DRS:

```{r}
covid_drs <- covid %>%
  group_by(nome_drs) %>% 
  summarise(obitos_totais = sum(obitos_novos),
            casos_totais = sum(casos_novos))
```

Se quisermos ordenar, de forma crescente, nossos dados por idade, por exemplo, basta usar o comando _arrange_:

```{r}
covid_drs %>% 
  arrange(obitos_totais)
```

Em ordem decrescente teríamos:

```{r}
covid_drs %>% 
  arrange(-obitos_totais)
```

Se quisermos 'desempatar' o ordenamento por idade por uma segunda variável, basta adicioná-la ao _arrange_:

```{r}
covid_drs %>% 
  arrange(-obitos_totais, -casos_totais)
```

Simples e útil.

# Fim

Paramos por aqui. Há muito mais sobre o _dplyr_ a aprender, mas já vimos o essencial 