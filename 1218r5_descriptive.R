library(data.table)
library(curl)
library(tableone)

ur <- "https://github.com/zarathucorp/R4CR-content/raw/main/example_g1e.csv"
dt <- fread(ur, header=T)
CreateTableOne(data = dt)

myVars <- c("HGHT", "WGHT", "BMI", "HDL", "LDL", "TG", "SGPT", 
            "Q_PHX_DX_STK", "Q_PHX_DX_HTDZ", "Q_HBV_AG", "Q_SMK_YN")
catVars <- c("Q_PHX_DX_STK", "Q_PHX_DX_HTDZ", "Q_HBV_AG", "Q_SMK_YN")
t1 <- CreateTableOne(vars = myVars, factorVars = catVars, data = dt)
t1 #두 개의 범주가 있는 범주형 변수의 경우, 두 번째 범주의 요약값만 출력된다

t2 <- CreateTableOne(data = dt,
                     vars = myVars,
                     factorVars = catVars,
                     strata = "Q_SMK_YN",
                     includeNA = F)
t2

#print 명령어로 세부 옵션을 지정할 수 있다. 
print(t1, showAllLevels = T)
print(t1, cramVars="Q_PHX_DX_STK")
print(t1, nonnormal="LDL")
print(t2, exact=c("Q_PHX_DX_STK", "Q_PHX_DX_HTDZ")) #기본은 카이
print(t2, smd = TRUE)
summary(t1)
t2$ConTable
t2$CatTable

table1 <- print(t2)
write.csv(table1, file = "table1.csv")