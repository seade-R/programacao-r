library(tidyverse)

piesp <- read_delim("data/piesp_20200803.csv", ";",
                    escape_double = FALSE, locale = locale(encoding = "ISO-8859-1"),
                    trim_ws = TRUE)

remove_acentos <- function(x) iconv(x, to = "ASCII//TRANSLIT")

piesp <- piesp %>% 
  mutate_all(remove_acentos) 

names(piesp) <- remove_acentos(names(piesp))

write_csv2(piesp, 'data/piesp.csv')