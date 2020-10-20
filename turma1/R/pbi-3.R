library(tidyverse)

dataset %>% 
  ggplot(aes(x = mortalidade_homens, y = mortalidade_mulheres)) +
  geom_point()
