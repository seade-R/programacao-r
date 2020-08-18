library(tidyverse)

piesp <- read_delim("data/piesp_20200803.csv", ";",
                    escape_double = FALSE, locale = locale(encoding = "ISO-8859-1"),
                    trim_ws = TRUE)

remove_acentos <- function(x) iconv(x, to = "ASCII//TRANSLIT")

names(piesp) <- remove_acentos(names(piesp))

piesp <- piesp %>% 
  mutate_all(remove_acentos) %>% 
  mutate(
    `Dolar (em milhoes)` = replace(`Dolar (em milhoes)`, `Dolar (em milhoes)` == '...', NA),
    `Dolar (em milhoes)` = str_replace(`Dolar (em milhoes)`, '\\.', ''),
    `Dolar (em milhoes)` = str_replace(`Dolar (em milhoes)`, ',', '.'),
    `Dolar (em milhoes)` = as.numeric(`Dolar (em milhoes)`),
    `Real (em milhoes)` = replace(`Real (em milhoes)`, `Real (em milhoes)` == '...', NA),
    `Real (em milhoes)` = str_replace(`Real (em milhoes)`, '\\.', ''),
    `Real (em milhoes)` = str_replace(`Real (em milhoes)`, ',', '.'),
    `Real (em milhoes)` = as.numeric(`Real (em milhoes)`)
    )

write_csv2(piesp, 'data/piesp.csv')
write_csv(piesp, 'data/piesp_virgula.csv')
write_delim(piesp, 'data/piesp_tab.txt', delim = '\t')
write_csv2(piesp, 'data/piesp_sem_cabecalho.csv', col_names = F)
write.csv2(piesp, 'data/piesp_latin1.csv', row.names = F, fileEncoding = 'Latin1')

