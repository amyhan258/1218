# tibble
# dataframe 변형해서 위에것들이 변수인표

# tidy:tibble 중 일부부
# Each variable must have its own column.
# Each observation must have its own row.
# Each value must have its own cell
# =
# Put each dataset in a tibble.
# Put each variable in a column.

#table1
#table2
#only table1 is tidy

library(tidyverse)

# 1. create
as_tibble(iris)
tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)
tribble( #transposed tibble
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)

# 이제 tidy
#table1 %>% 
# mutate(rate = cases / population * 10000)

table1 %>% 
  count(year, cases)
table1 %>% 
  count(year, wt=cases)

library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

#Pivoting: 방향전환->tidy로 바꾸는 법
