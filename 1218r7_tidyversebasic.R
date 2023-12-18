library(tidyverse)
#magrittr는 코드의 가독성을 위한 Pipe operator, %>%를 쓸 수 있게 하는 패키지
ex <- read.csv('https://github.com/zarathucorp/R4CR-content/raw/main/example_g1e.csv')

#head(x = ex, n = 3)
ex %>% # x로 사용
  head(n = 3)

ex %>% 
  subset(EXMD_BZ_YYYY == 2010) %>%
  head(4)

ex %>% 
  subset(
    EXMD_BZ_YYYY == 2010 &
      GGT >= 20
  ) %>%
  head(4)
# SAME
ex %>% 
  subset(EXMD_BZ_YYYY == 2010) %>%
  subset(GGT >= 20) %>%
  head(4)

ex %>% 
  subset(Q_PHX_DX_HTN == 1) %>%  
  lm(TOT_CHOL ~ HGB, data = .) %>%
  .$coefficients %>% 
  print()

ex %>% 
  aggregate( #aggregate(data, by = '기준이 되는 컬럼', FUN)
    data = ., # . = 이전 것 (iris)
    . ~ Q_SMK_YN, # . = 모든 변수
    FUN = function(x){ mean = mean(x) %>% round(1) }
  )

ex1 <- ex
ex1.2012 <- ex1[ex1$EXMD_BZ_YYYY >= 2012, ]
ex1.2012 <- subset(ex1, EXMD_BZ_YYYY >= 2012) 
table(ex1.2012$EXMD_BZ_YYYY)

ex %>%
  subset(EXMD_BZ_YYYY >= 2012) %>%
  subset(select = EXMD_BZ_YYYY) %>%
  table()


library(dplyr)
# 데이터 정리를 위한 것것
# mutate(): 새로운 Column 추가
# 
# select(): 조건에 따라 Column 선택
# 
# filter(): 조건에 따라 Row 선택 (base R의 subset과 비슷)
# 
# group_by() & summarise(): 요약 (통계치) 계산
# 
# arrange(): Row 순서 변경 (정렬)

starwars
starwars %>% 
  filter(species == "Droid") %>%
  mutate(bmi = mass / ((height / 100) ^ 2)) %>%
  select(name:mass, bmi) %>% # name 에서 mass 까지 + bmi 
  arrange(desc(mass)) # Decrease. desc는 %>%로 안쓰는 것이 좋음

starwars %>%
  group_by(species) %>%
  summarise(
    n = n(), # count
    mean_mass = mean(mass, na.rm = TRUE)
  ) %>%
  filter(
    n > 2,
    mean_mass > 50
  )

iris
head(iris) #디폴트가 6개

iris %>%
  filter(Sepal.Width > 3.4) %>%
  filter(Sepal.Length > 5) %>%
  head()

iris %>% 
  arrange(desc(Sepal.Length))
iris %>% 
  select(2, 3, 4) %>%
  head()
iris %>% 
  select(ends_with('Width')) %>%
  head()

iris %>% 
  mutate(
    Species2 = ifelse(
      Species == 'setosa', 'setosa', 'etc'
    ) 
  ) %>% 
  View()

iris %>% 
  group_by(Species) %>%
  summarise(
    mSL = mean(Sepal.Length),
    mSW = mean(Sepal.Width),
    count = n() # 개수
  )

#baseR의 merge와 유사한 목적
band_members %>% 
  inner_join(band_instruments)



