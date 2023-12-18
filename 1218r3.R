library(data.table)
library(curl)
url <- "https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv"
dt <- fread(url,header=T)

#기본문법
dt[, c(13, 14)]
dt[, .(HGHT, WGHT)]
dt[, .(Height = HGHT, Weight = WGHT)]
dt[, .(m_chol = mean(TOT_CHOL), m_TG = mean(TG))]
dt[HGHT >= 180 & WGHT <= 80, .(m_chol = mean(TOT_CHOL), m_TG = mean(TG))]
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(BMI)] #내림
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(-BMI)] #오름
dt[HGHT >= 175, .N, by=.(EXMD_BZ_YYYY, Q_SMK_YN)]
dt[, .N, by=.(Q_PHX_DX_STK > 0, Q_PHX_DX_HTDZ > 0)]
dt[HGHT >= 175, .N, keyby=.(EXMD_BZ_YYYY, Q_SMK_YN)] #2개 다 정렬

setkey(dt, EXMD_BZ_YYYY, Q_HBV_AG)
dt[J(2011, 2)] # dt[.(2011, 2)], dt[list(2011, 2)], dt[EXMD_BZ_YYYY==2011 & Q_HBV_AG==2]

dt1 <- dt[c(1, 300, 500, 700, 1000)]
setkey(dt1, EXMD_BZ_YYYY)
dt2 <- dt[c(400, 600, 800 ,1200, 1500)]
setkey(dt2, EXMD_BZ_YYYY)
merge(dt1, dt2, by='EXMD_BZ_YYYY', all = F)

dt[, diff := HDL-LDL][] #[]는 보고싶으면
dt[, ':=' (HGHT = HGHT*0.9, WGHT = WGHT+5)][]
dt[, BMI := NULL]

dt[, lapply(.SD, mean), by=EXMD_BZ_YYYY] # .SD 는 ’Subset of Data’의 약자로, by로 지정한 그룹 칼럼을 제외한 모든 칼럼을 대상으로 연산을 수행할 때
dt[, head(.SD, 2), by=EXMD_BZ_YYYY] # .SD 기호를 사용하여 연도별로 처음 두 개의 행을 추출할 수 있다.
dt[, c(.N, lapply(.SD, mean)), by=EXMD_BZ_YYYY, .SDcols=c("HGHT", "WGHT")] #.SDcols는 연산 대상이 되는 특정 칼럼을 지정하는 특수 기호

#melt
dt.long1 <- melt(dt,
                 id.vars = c("EXMD_BZ_YYYY", "RN_INDI", "HGHT", "WGHT"),
                 measure.vars = c("TOT_CHOL", "HDL", "LDL"),
                 variable.name = "measure",
                 value.name = "val") #id.vars에는 고정 칼럼을 measure.vars는 stack 처리할 칼럼을 넣는다
dt.long1

col1 <- c("BP_SYS", "BP_DIA")
col2 <- c("HDL", "LDL")
dt.long2 <- melt(dt, 
                 measure = list(col1, col2),
                 value.name = c("BP", "Chol")) # melt 함수에 measure=list(col1, col2, …) 형식으로 여러 개의 칼럼 이름을 list() 형태로 넣는다. 이때 공통의 value.name을 지정할 수 있다.
dt.long2

#dcast
dt.wide1 <- dcast(dt.long1, EXMD_BZ_YYYY + RN_INDI + HGHT + WGHT ~ measure, value.var = "val")
dt.wide1

dt.wide2 <- dcast(dt.long1, EXMD_BZ_YYYY ~ measure, value.var = "val", fun.aggregate = mean, na.rm =T) # 결측치 제외: na.rm = T
dt.wide2

dt.wide3 <- dcast(dt.long2,
                  ... ~ variable,
                  value.var = c("BP", "Chol"))
dt.wide3