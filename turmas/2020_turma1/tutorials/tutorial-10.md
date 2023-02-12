# Integrando R e Power BI

R é uma das linguagens que melhor combina com o uso do Power BI. É possível importar e modelar dados dentro do Power BI com scripts de R, tais quais os que trabalhamos no curso, além de produzir gráficos ou rodar algoritmos implementados na linguagem.

Neste breve tutorial, que mescla scritps e vídeos, veremos como realizar 3 tarefas com R no Power BI:

1 - Importar dados, fazendo todas as modificações necessárias
2 - Transformar dados de tabelas já carregadas no Power BI
3 - Produzir uma visualização simples com R no Power BI

Note que os códigos que utilizaremos dentro do Power BI são praticamente idênticos aos que utilizamos no curso, salvo por alguns poucos detalhes. Se você sabe R, também sabe como modelar e produzir gráficos no Power BI.

## Requisitos

Existem alguns requisitos para se trabalhar com R e Power BI:

0 - Não usar Linux, infelizmente.
1 - Ter R instalado no mesmo computador que o Power BI Desktop. O Power BI utiliza a instalação local de R.
2 - Ter instalado, em R, todas as bibliotecas que serão utilizadas nos scripts do Power BI.
3 - Utilizar apenas pacotes da lista de pacotes de R com suporte no Power BI, que você encontra aqui. https://docs.microsoft.com/pt-br/power-bi/connect-data/service-r-packages-support. No curso, até agora, utilizamos apenas pacotes com suporte no Power BI.

## Importando dados (já modelados) com R para o Power BI

O script [Script-1-PBI](https://github.com/seade-R/programacao-r/blob/master/R/pbi-1.R) contém os passos de importação e transformação dos dados utilizados no tutorial sobre bases de dados relacionais. Acesse-o e leia o código. Execute-o em R e veja se compreendeu.

A seguir, assista ao vídeo sobre como utilizar esse script itegralmente no Power BI: [https://www.youtube.com/watch?v=EOp4FZHqFbc](https://www.youtube.com/watch?v=EOp4FZHqFbc)

## Transformando dados no Power BI

Se os dados já estiverem carregados no Power BI, mas não houver possibilidade de transformá-los com as ferramentas padrão do Power BI (ou você tiver que fazer muitos passos documentados), convém utilizar R. Nesta segunda tarefa, faremos algumas transformações simples nos dados de óbitos do Registro Civil com R. O script que utilizaremos é este: [Script-2-PBI](https://github.com/seade-R/programacao-r/blob/master/R/pbi-2.R). Este código, por razões explicadas no vídeo, não funcionará se você executá-lo em R sem modificações, pois o data frame a ser transformado não é gerado pelo próprio código.

Assista ao vídeo: [https://www.youtube.com/watch?v=9XNhaqzb75A](https://www.youtube.com/watch?v=9XNhaqzb75A)

## Visuais com R

Finalmente, utilizando os dados de mortalidade por município que importamos anteriormente, vamos fazer um gráfico de dispersão bastante simples, cujo código você encontra aqui: [Script-3-PBI](https://github.com/seade-R/programacao-r/blob/master/R/pbi-3.R). Pela mesma razão que o anterior, o código sozinho não funcionará em R.

Assista ao vídeo sobre como utilizar esse código para gerar um gráfico no Power BI: [https://www.youtube.com/watch?v=ZITV2q6zLPM](https://www.youtube.com/watch?v=ZITV2q6zLPM)

## Modelagem de dados: R dentro ou fora do Power BI?

Vamos ver como utilizar R dentro do Power BI. Mas você pode utilizar fora também. R é uma linguagem excelente para modelar dados e prepará-los para visualização, mesmo se for utilizar um editor de planilhas ou o Power BI. Você pode exportar os dados de R para o local onde armazena as fontes de dados do Power BI e, assim, não precisa executar scritps dentro do Power BI.
