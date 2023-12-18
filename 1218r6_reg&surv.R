library(survival)
data(colon)
colon

cor.test(colon$age, colon$nodes)
summary(lm(nodes ~ age, data = colon))$coefficients
summary(glm(age ~ nodes, data = colon))$coefficients #종속변수가 정규분포가 아닌 경우 glm

t.test(time ~ sex, data = colon, var.equal = T) #여자가 0, 남자가 1
summary(lm(time ~ sex, data = colon))$coefficients

levels(colon$rx) #rx: Treatment - Obs(ervation), Lev(amisole), Lev(amisole)+5-FU

# ... to be continue
