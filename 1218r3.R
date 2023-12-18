library(data.table)
library(curl)
url <- "https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv"
dt <- fread(url,header=T)
fwrite(dt, "aa.csv")
#dt
#dt[c(2,4,5,6)]
dt[BMI>=30 & HGHT<150]
dt[, c(13, 14)]
dt[, .(HGHT, WGHT)]
dt[, .(Height = HGHT, Weight = WGHT)]
icols = c(1:31)
dt[, !..icols]
dt[, .(m_chol = mean(TOT_CHOL), m_TG = mean(TG))]
dt[HGHT >= 180 & WGHT <= 80, .(m_chol = mean(TOT_CHOL), m_TG = mean(TG))]
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY]
dt[HGHT >= 175, .N, by=.(EXMD_BZ_YYYY, Q_SMK_YN)]
dt[HGHT >= 175, .N, by=EXMD_BZ_YYYY]
dt[HGHT >= 175, .N, by=.(EXMD_BZ_YYYY, Q_SMK_YN)]
dt[HGHT >= 175, .N, by=.(EXMD_BZ_YYYY, Q_SMK_YN)]
dt[HGHT >= 175, .N, keyby=.(EXMD_BZ_YYYY, Q_SMK_YN)]
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(BMI)] #내림림
dt[, .(HGHT=mean(HGHT), WGHT=mean(WGHT), BMI=mean(BMI)), by=EXMD_BZ_YYYY] [order(-BMI)] #오름
dt[, .N, by=.(Q_PHX_DX_STK > 0, Q_PHX_DX_HTDZ > 0)]
setkey(dt, EXMD_BZ_YYYY, Q_HBV_AG)
dt[J(2011, 2)]
# dt[.(2011, 2)]
# dt[list(2011, 2)]
# dt[EXMD_BZ_YYYY==2011 & Q_HBV_AG==2]

#inner join
(dt1 <- dt[c(1, 300, 500, 700, 1000)])
setkey(dt1, EXMD_BZ_YYYY)
(dt2 <- dt[c(400, 600, 800 ,1200, 1500)])
dt1
dt2

setkey(dt2, EXMD_BZ_YYYY)
merge(dt1, dt2, by='EXMD_BZ_YYYY', all = F)
merge(dt2, dt1, by='EXMD_BZ_YYYY', all = F)

dt[, diff := HDL-LDL][]
dt[, ':=' (HGHT = HGHT*0.9, WGHT = WGHT+5)][]

dt[, BMI := NULL]
dt[, lapply(.SD, mean), by=EXMD_BZ_YYYY]
# .SD 는 ’Subset of Data’의 약자로, 
#by로 지정한 그룹 칼럼을 제외한 모든 칼럼을 대상으로 연산을 수행할 때

dt[, head(.SD, 2), by=EXMD_BZ_YYYY]
# .SD 기호를 사용하여 연도별로 처음 두 개의 행을 추출할 수 있다.

dt[, lapply(.SD, mean), by=EXMD_BZ_YYYY, .SDcols=c("HGHT", "WGHT")]
dt[, c(.N, lapply(.SD, mean)), by=EXMD_BZ_YYYY, .SDcols=c("HGHT", "WGHT")]


dt.long1 <- melt(dt,
                 id.vars = c("EXMD_BZ_YYYY", "RN_INDI", "HGHT", "WGHT"),
                 measure.vars = c("TOT_CHOL", "HDL", "LDL"),
                 variable.name = "measure",
                 value.name = "val")
dt.long1


col1 <- c("BP_SYS", "BP_DIA")
col2 <- c("HDL", "LDL")
dt.long2 <- melt(dt, 
                 measure = list(col1, col2),
                 value.name = c("BP", "Chol"))
dt.long2
