# R, dplyr e SQL

Uma das soluções mais simples para trabalharmos com bases de dados grandes em R é conectar-se a uma fonte remota de dados, como SGBD (Sistemas de Gerenciamento de Bancos de dados) em SQL, e usar a gramática do _dplyr_ manipularmos a tabelas.

Neste tutorial, veremos como manipular dados da PIESP armazenados em um servidor MySQL mantido pelo SEADE. O roteiro, porém, vale para outros sistemas como PostgreSQL, MariaDB, Amazon Redshift ou Google BigQuery.

O uso regular de R utiliza a memória RAM para armazenar dados. O MySQL, por sua vez, não armazena os dados na memória RAM, mas no disco rígido. A combinação R se MySQL expande bastante o limite do tamanho dos dados que conseguiremos gerenciar, sem, no entanto, precisar de outra "gramática" para manipulação de dados. É a solução mais simples para se trabalhar com grandes bases, como RAIS, Censo populacional ou bases do INEP.

Vamos começar instalando um pacote que utilizaremos para a conexão ao MySQL

```{r}
install.packages("RMySQL")
```

e carregá-lo, em conjunto ao tidyverse.

```{r}
library(tidyverse)
library(RMySQL)
```

## Conectando-se ao um servidor MySQL

Nosso primeiro passo será estabelecer uma conexão ao servidor de MySQL. Precisamos, para tanto, das seguintes informações: (1) o nome da 'base' (schema) que utilizaremos; (2) o endereço do 'host', que, no nosso exemplo, é o servidor no qual o RStudio Server que estamos utilizando está instalado; e um (3) usuário e (4) senha. Pode ser necessário informar o argumento 'port' em algumas conexões.

Para utilizar o servidor do nosso exemplo é preciso estar conectado à rede do SEADE ou utilizar o RStudio do servidor no navegador. Por segurança, senha será enviada por mensagem às e aos participantes do curso. Você deve colá-la no lugar de 'coleAquiASenha' no argumento 'password'.


```{r}
conexao <- src_mysql(dbname = 'piespCursoR',
                     host = "rstudio.seade.gov.br", 
                     user = "db_usu",
                     password = "coleAquiASenha")
```

## Tabelas do MySQL como objetos e 'lazy evaluation'

Vamos investigar quais tabelas (data frames) existem nessa base de dados à qual nos conectamos:

```{r}
src_tbls(conexao)
```

Há 61 tabelas! Nenhuma delas está na memória RAM utilizada por R, mas estão disponíveis para nosso uso. Vamos escolher a tabela 'noticias', que contém informações sobre as notícias coletadas em diversos veículos a partir de termos chave e que potencialmente contém informações sobre investimentos no Estado de São Paulo.

Utilizamos o comando _tbl_, que têm 2 parâmetros: a conexão a uma fonte de dados e a tabela buscada.

```{r}
df_noticias <- tbl(conexao, 'noticias')
```

Simples, não? A partir deste ponto, basta trabalhar com objeto 'df\_noticias' da mesma maneira que trabalhamos _data frames_ até agora. A gramática oferecida pelo pacote _dplyr_ funciona normalmente.

Note, porém, que o objeto 'df\_noticias' não contém os dados da tabela. Ele 'representa' a tabela existente no servidor de MySQL como se fosse um 'data frame', ou, para usar a linguagem do _dplyr_, uma tibble (tbl).

```{r}
class(df_noticias)
```

A manipulação de tabelas do MySQL em R é feita de maneira 'preguiçosa' (lazy evaluation): se você ainda não precisou de seu conteúdo, nenhuma consulta aos dados é produzida. Mesmo quando executarmos algumas transformações no objeto que representa alguma tabela, enquanto não fose exigido que os dados sejam apresentados no console ou transportados para a memória RAM utilizada por R, nada acontece no servidor de MySQL.

Vamos ver um exemplo de 'lazy evaluation':

```{r}
df_noticias %>% glimpse
```

Perceba que o comando _glimpse_ produz o mesmo efeito que se aplicado a um data frame, mas na primeira linha do output temos 'Observations: ??'. _glimpse_ precisou apenas das primeiras linhas para produzir o resultado e não sabemos ainda quantas linhas existem na tabela. A avaliação da tabela completa, desnecessária nesse momento, não é feita na 'lazy evaluation'

Para investigar o número de linhas podemos usar _count_

```{r}
df_noticias %>% count
```

Pronto. Agora sabemos que temos uma tabela com 27 variáveis e quase 150 mil linhas, cada uma contendo uma notícia.

## Uma tabela simples de frequência e sua tradução para SQL

Vamos produzir uma tabela de frequência usando a gramática do dplyr e guardá-la como objeto.

```{r}
query_contagem_fonte <- df_noticias %>% 
  group_by(fonte) %>% 
  count
```

Obs: _tabyl_, do pacote _janitor_, não funciona para queries em SQL. Temos que utilizar _group\_by_ e _count_ no lugar.

O resultado é uma 'lazy query'. A execução da query só ocorrerá quando tentarmos trazer a tabela para a memória ("fetch") ou explicitarmos que ela deve ser computada.

Se quisermos trazer os dados para a memória, utilizamos a função _collect_.

```{r}
contagem_fonte <- collect(query_contagem_fonte)
```

O objeto criado agora não é mais uma representação de algo no servidor de MySQL, mas um data frame no nosso Environment.

O que está por traz do uso do _dplyr_ com sistemas em SQL é a tradução das 'queries' escritas com a gramática deste pacote para a linguagem SQL. Podemos, inclusive, pedir para ver essa tradução:

```{r}
show_query(query_contagem_fonte)
```

Se você conhece um pouco de SQL, pode, inclusive, utilizar a linguagem diretamente dentro do R para fazer consultas no servidor de MySQL. O código abaixo tem o mesmo efeito que a query anterior, escrita 'em dplyr':

```{r}
tbl(conexao, sql("SELECT `fonte`, COUNT(*) AS `n`
				  FROM `noticias`
				  GROUP BY `fonte`"))
```

## Tabelas temporárias _versus_ criação de tabelas no MySQL

Quando utilizamos os verbos do _dplyr_ para manipulação de dados em servidor MySQL, todas as consultas são geradas como tabelas temporárias no servidor. Como fazer com que as consultas se tornem tabelas permanentes no servidor?

Ao usar o comando _collect_, uma query é executada no servidor e os dados enviados ao ambiente de R. O caminho inverso -- subir ao servidor uma tabela -- é feito com a função _copy\_to_. No nosso servidor de exemplo o carregamento de dados está desabilitado, então os códigos abaixo não funcionarão.

```{r}
copy_to(dest = conexao, df = contagem_fonte, name = "contagem_fonte")
```

_copy\_to_ não gera uma nova tabela no servidor por padrão. Para que uma nova tabela seja gerada, é preciso definir o argumento "temporary" como "FALSE" (o padrão é "TRUE"): 

```{r}
copy_to(dest = conexao, df = contagem_fonte, name = "contagem_fonte", temporary = FALSE)
```

Para executar a query no servidor sem que precisemos trazer a tabela e reenviá-la devemos usar a função _compute_, que também tem o argumento "temporary".

```{r}
compute(query_contagem_fonte, name = "pagamentos201701_es", temporary = FALSE)
```

Sem definir "temporary" como "FALSE", a query será executada e a tabela gerada será temporária, apenas.

## Um exemplo completo

Vamos treinar um pouco mais o uso do _dplyr_ e sua integração com SQL em um exemplo mais completo a partir dos dados da PIESP. Vamos observar quais são as principais fontes da PIESP (em número de notícias captadas):

```{r}
df_noticias %>% 
  group_by(fonte) %>% 
  count %>% 
  collect %>%
  arrange(-n)
```

Note o uso do _collect_ no meio do pipeline, sem o qual o ordenamento com _arrange_ não funcionaria. Conhecendo as fontes, vamos recodificar a variável fonte com uma função bastante útil que ainda não tivemos a oportunidade de utilizar: case\_when.

```{r}
df_noticias <- df_noticias %>% 
  mutate(fonte2 = case_when(
    fonte == 'Estadão' ~ 'Estadão',
    fonte == 'Folha de S. Paulo' ~ 'Folha',
    fonte == "Valor Econômico - Impresso - Flip" |
      fonte == "Valor Econômico - Impresso" ~ 'Valor',
    TRUE ~ 'Outros'
  )) 
```

Lembre-se: ao criar o objeto ainda não executamos a 'query', que nada mais é do que a própria tabela com uma variável adicional. Vamos agora observar o 'termo' de busca mais frequentes para cada categoria da nova variável. Faremos os seguintes passos: eliminaremos as observações com vazio na variável 'palavra'; agruparemos e contaremos por fonte e termo (variáveis 'fonte2' e 'palavra'); faremos um desagrupamento para que possamos fazer outro; agruparemos por fonte e, dentro de cada grupo, faremos um filtro para que a contagem do termo seja igual ao máximo da contagem dentro de cada fonte.

```{r}
termos_frequentes <- df_noticias %>% 
  filter(palavra != '') %>% 
  group_by(fonte2, palavra) %>% 
  count %>% 
  ungroup() %>% 
  group_by(fonte2) %>% 
  filter(n == max(n))
```

Há alguns novos usos do _dplyr_ que ainda não havíamos visto: o uso do 'ungroup' necessário para produzir novos agrupamentos ou eliminar a variável utilizada para agrupar; e a combinação de _group\_by_ com _filter_, para fazer a seleção de linhas dentro de cada grupo.

Vamos usar _collect_ para trazer o resultado da query como data frame:

```{r}
termos_frequentes <- collect(termos_frequentes)
```

Façamos uma comparação com o código em SQL:

```{r}
show_query(termos_frequentes)
```

Usar R ou SQL é, em alguns casos, questão de gosto (ironia). Com algumas poucas novas funções src_mysql, src_tbls, _tbl_ e _collect_, você pode usar tudo que aprendeu sobre a gramática do _dplyr_ para trabalhar com R e sistemas de gerenciamento de dados em SQL.



