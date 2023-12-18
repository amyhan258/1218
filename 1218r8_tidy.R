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

#tibble을 tidy로 바꾸는 법
#Pivoting: 방향전환
table4a
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
table2 %>%
  pivot_wider(names_from = type, values_from = count)
#쪼개거나 붙이기
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE) # 걍 디폴트가 문자로 변환이라
table5 %>% 
  unite(new, century, year, sep = "")

#missing values
# Explicitly, i.e. flagged with NA.
# Implicitly, i.e. simply not present in the data.
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks
stocks %>% 
  complete(year, qtr) #1

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4,
)
treatment %>% 
  fill(person)