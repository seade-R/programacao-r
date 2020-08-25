# Janitor, factors e tabelas simples na gramática do dplyr

No tutorial anterior vimos que a produção de tabelas na gramática do tidyverse pode ser feita utilizando o verbo _group\_by_ acompanhado de _count_ ou _summarise_. As tabelas de frequência eram sempre novos data frames, menores, compactados.

Neste tutorial vamos explorar um pouco mais a confecção de tabelas na gramática do dplyr utilizando um pacote que é uma baita mão na roda: _janitor_. Em vez de utilizarmos _group\_by_ para produzir tabelas de frequência, teremos funções simples que entregam o mesmo resultado e, de quebra, formatam a tabela para seu uso em relatórios ou para exportação.

No processo de confecção de tabelas aprenderemos sobre um novo tipo de variável em R: _factor_. Factors são utilizados variáveis categóricas. Até agora, mantivemos tais variáveis como texto. Entretanto, trabalhar variáveis categóricas como texto é incoveniente, sobretudo no caso de categoriais ordenáveis, nas quais a ordem das categorias não corresponde à ordem alfabética. Para quem vêm de outros softwares de análise de dados, factors correspondem a variáveis categóricas armazenadas com códigos numéricos acompanhados de rótulos de valores.

Comece instalando e carregando o pacote que vamos utilizar, _janitor_: 

```{r}
install.packages('janitor')
library(janitor)
```

## Dados de óbitos de 2018

Neste tutorial utilizaremos dados de óbitos do Registro Civil de 2018, produzidos pelo SEADE. Você encontra os dados aqui: https://www.seade.gov.br/produtos/arquivos-para-governo-aberto-sp/. Antes de obter os dados, vamos carregar os pacotes que vamos utilizar, ademais de _janitor_: _tidyverse_ e _readxl_.

```{r}
library(tidyverse)
library(readxl)
```

Precisamos do pacote _readxl_ para abrir os dados, que estẽo em formato .xlsx.

Comecaremos fazendo o download dos dados

```{r}
download.file('http://www.seade.gov.br/produtos/midia/2020/02/DO2018.xlsx', 'obitos_2018.xlsx')
```

A seguir, vamos carregá-los usando a função _read\_excel_. Como só há uma aba no arquivo .xlsx, não precisamos especificar qual aba queremos abrir:

```{r}
obitos_2018 <- read_excel('obitos_2018.xlsx')
```

Com _glimpse_, vamos examinar o arquivo:

```{r}
obitos_2018 %>% 
  glimpse()
```

## Nomes bonitos para variáveis com janitor

Os nomes das variáveis dos dados de óbitos do registro civil estão razoavelmente dentro das convenções. Poderiam, porém, estar em minúscula. No pacote _janitor_ há uma função excelente para lidar com nomes com espaços, acentos e maísculas: _clean\_names_. No próximos tutorial esta função será bastante útil. Por ora, vamos aplicá-la para tornar os nomes deste conjunto de dados mais próximos das convenção e conhecer a função:

```{r}
obitos_2018 <- obitos_2018 %>% 
  clean_names() 
```

Vamos usar novamente _glimpse_ para observar o resultado:

```{r}
obitos_2018 %>% 
  glimpse()
```

Ótimo. Guarde _clean\_names_ para utilizar no futuro.

## tabyl: seu novo melhor amigo para produzir tabelas

No tutorial passado vimos que podemos produzir tabelas de frequência na gramática do _dplyr_ com _group\_by_ e _count_. Por exemplo, vamos fazer a contagem de óbitos por sexo em nossos dados:

```{r}
obitos_2018 %>% 
  group_by(sexo) %>% 
  count
```

Em vez de precisarmos de 2 funções, podemos utilizar simplesmente _tabyl_, do pacote _janitor_:

```{r}
obitos_2018 %>% 
  tabyl(sexo)
```

Ademias de produzir a contagem, _tabyl_ produz também a frequência relativa de cada categoria da variável escolhida.

A tabela é, digamos, feia. Vamos melhorá-la. Porém, não começaremos pela estética da tabela, mas produzindo uma mudança na variável _sexo_, transformando-a de character em factor.

## Factors em R

Factors são certamente uma das maiores pedras no sapato em R (e por isso evitamos até agora). E a razão disso é que diversas funções da 'gramática do R base' convertem automaticamente texto em factors.

Entretanto, factors são muito úteis e, as vezes, inevitáveis. Olhe novamente para a tabela que produzimos: as categorias da variável sexo são 'F', 'I' e 'M', e você deve ter deduzido que correspondem a 'Feminino', 'Ignorado' e 'Masculino', respectivamente. Incovenientemente, 'Ignorado' aparece no meio da tabela, quando esperaríamos que figurasse como última categoria.

A tabela respeita o ordenamento da variável que, por ser do tipo _character_, é alfabética. Como fazer uma tabela na qual a ordem será 'Feminino', 'Masculino' e 'Ignorado'?

Em primeiro lugar, vamos recodificar a variável e escrever o nome das categorias por extenso. Fazemos isso com _mutate_, já que estamos transformando uma coluna, e _recode_, que é a função de transformação que aplicaremos:

```{r}
obitos_2018 <- obitos_2018 %>% 
  mutate(sexo = recode(sexo,
                          'F' = 'Feminino',
                          'M' = 'Masculino',                  
                          'I' = 'Ignorado'))
```

Repetindo a tabela, vamos que os textos das categorias mudaram, mas a ordem continua inconveniente. Após a recodificação, 'sexo' ainda é uma variável de texto.

```{r}
obitos_2018 %>% 
  tabyl(sexo)
```

Para transformar texto em factor usamos a função _factor_. E especificamos no argumento 'level' um vetor com a ordem das categorias da nova variável. Assim, vamos criar uma nova variável, 'sexo_f', que será a versão de sexo como factor, e cuja ordem das categorias é definida pelo vetor "c('Feminino', 'Masculino', 'Ignorado')". Veja:

```{r}
obitos_2018 <- obitos_2018 %>% 
  mutate(sexo_f = factor(sexo, 
                         levels = c('Feminino', 'Masculino', 'Ignorado')))
```

Produzindo a tabela com nossa nova variável temos:

```{r}
obitos_2018 %>% 
  tabyl(sexo_f)
```

Muito melhor, não?

Vamos fazer o mesmo para variável 'racacor', que contém a informação sobre raça/cor nos dados de óbitos de 2018. Veja a tabela antes da transformação:

```{r}
obitos_2018 %>% 
  tabyl(racacor) 
```

Puxa, está tudo em código numérico! Não tem problema, vamos recodificar (se precisar, faça download do dicionário de dados na página do SEADE).

Dessa vez, porém, não utilizaremos _recode_. Como sabemos que queremos uma variável do tipo factor ao final, utiliaremos _recode\_factor_. A ordem das recodificações corresponderá à ordem dos 'levels' da nova variável:

```{r}
obitos_2018 <- obitos_2018 %>% 
  mutate(racacor_f = recode_factor(racacor,
                     '1' = 'Branca',
                     '2' = 'Preta',                  
                     '3' = 'Amarela',
                     '4' = 'Parda',
                     '5' = 'Indígena',
                     '9' = 'Ignorada'))
```

A tabela para nossa nova variável, 'racacor_f' é:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) 
```

Excelente! Porém, ainda não muito bonita.

## 'Enfeitando' as tabelas produzidas com tabyl

Se as tabelas produzidas com tabyl são data frames, renomear suas margens é exatamente como renomear variáveis de um data frame:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)
```

No pacote _janitor_, há um conjunto de funções de prefixo _adorn\_*_ que serve para alterar a estética da tabela. _adorn\_pct\_formatting_ transforma a coluna 'percent' em percentual, ou seja, multiplica por 100, delimita o número de casas decimais e adiciona o símbolo %. 

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting()
```

Se objetivo for apenas arrendodar as casas decimais, _adorn\_rounding_ cumpre bem a função. Você pode escolher o número de dígitos:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_rounding(digits = 2)
```

Como adicionar totais? Com _adorn\_totals_:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_totals()
```
Você pode combinar mais de uma função _adorn\_*_:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)
```

Chegamos, finalmente, a uma tabela razoavelmente bonita em R. Lembre-se que você sempre pode guardar sua tabela como objeto fazendo uma atribuição

```{r}
tabela_racacor <- obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent)
```

E pode usá-la novamente quando quiser.

```{r}
tabela_racacor
```

Uma curiosidade. Se invertermos o símbolo de atribuição, ou seja, se no lugar de '<-' usarmos '->' a operação de atribuição funciona?

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent) -> tabela_racacor 
```

Sim, funciona

## Exportando tabelas com _readr_

Chegamos, finalmente, a uma tabela razoavelmente bonita em R. Como exportá-la?

Aprendemos no passado sobre as funções _read\_*_ para abrirmos arquivos de texto. Para exportar arquivos de texto não temos nenhuma surpresa: usamos funções com prefixo _write\_*_, também do pacote _readr_.

Por exemplo, se quiseremos exportar nossa tabela (que é um data frame) em formato .csv separado por ponto e vírgula fazemos:

```{r}
write_csv2(tabela_racacor, 'tabela_racacor.csv')
```
O primeiro argumento é o objeto a ser exportado e o segundo é o nome do arquivo que será criado.

Outra forma de escrever o mesmo comando é usando pipe (%>%):

```{r}
tabela_racacor %>% 
  write_csv2('tabela_racacor.csv')
```

Se você quiser, pode emendar a exportação de uma tabela ao final do código que a produz para evitar uma atribuição:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f) %>% 
  adorn_pct_formatting() %>% 
  adorn_totals() %>% 
  rename(`Raça/cor` = racacor_f,
         percentual = percent) %>% 
  write_csv2('tabela_racacor.csv')
```

Voltaremos à exportação de data frames no próximo tutorial.

## Crosstabs com tabyl

Sim, há como fazer crosstabs em R. Basta usar _tabyl_ com duas variáveis:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f)
```

_tabyl_ é a sua melhor amiga na produção de tabelas em R

Como se trata de uma tabela de duas entradas, temos que o conteúdo da célula é uma contagem. Com adorn\_percentages_ transformamos o conteúdo das células em percentuais dentro de cada linha.

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages()
```

Convém usar _adorn\_pct\_formatting_ para conseguir ler alguma coisa na tabela:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages() %>% 
  adorn_pct_formatting()
```

Se alterarmos o denominador (argumento 'denominator') dentro da função para 'col', temos agora percentuais calculados dentro de cada coluna:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'col') %>% 
  adorn_pct_formatting()
```

Ou ainda sobre o total da tabela, se usarmos 'all' como denominador:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_pct_formatting()
```

Tal como na tabela para apenas uma variável, podemos adicionar a soma da linhas com _adorn\_totals_:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals()
```

Ou a soma de colunas se utilizarmos "where = 'col'" dentro de _adorn\_totals_

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = 'col')
```

Ou ainda a soma de linhas e colunas se a opção em "where" for o vetor "c('col', 'row')"

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = c('col', 'row'))
```

Os totais valem para percentuais, obviamente:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_pct_formatting()  
```

Não faz nenhum sentido usar _rename_ para alterar uma tabela de duas entradas produzida com _tabyl_, pois ambas as margens contêm as categorias das variáveis utilizadas em sua produção. Mas há uma solução. O último 'enfeite' à nossa tabela, que se aplica apenas à tabela de duas entradas, é escrever o nome das variáveis de linha e de coluna com _adorn\_title_. Veja seu uso:

```{r}
obitos_2018 %>% 
  tabyl(racacor_f, sexo_f) %>% 
  adorn_percentages(denominator = 'all') %>% 
  adorn_totals(where = c('col', 'row')) %>% 
  adorn_pct_formatting() %>% 
  adorn_title(placement = 'top',
              row_name = 'Raça/cor', 
              col_name =  'Sexo')
```

Fim