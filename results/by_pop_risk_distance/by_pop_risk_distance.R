library(ggplot2)
library(Hmisc)

setwd("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/by_pop_risk_distance")

Gaps <- c(0, 1, 2, 3, 4)
GapStrs <- c("_1.0_1h", "_1_1h_1s", "_1_1h_2s", "_1_1h_3s", "_1_1h_4s")
Dirs <- sapply(GapStrs, function(gap) paste('../p1.4_100', gap, '/output/', sep=''))
Files <- sapply(Dirs, function(dir) paste(dir, 'mean_table.tex', sep=''))

N <- length(Gaps)
Errs <- character()

matO <- NULL
matS <- NULL
matC <- NULL


for (i in 1:N) {
  Gap <- Gaps[i]
  File <- Files[i]
  lines <- readLines(File)
  lines <- lines[7:22]
  Os <- numeric()
  Ss <- numeric()
  Cs <- numeric()
  for (line in lines) {
    fline <- gsub("\\", "", line, fixed=TRUE)
    partsl <- strsplit(fline, "&", fixed=TRUE)
    parts <- partsl[[1]]
    key <- trimws(parts[1], which="both")
    O <- as.numeric(parts[2])
    S <- as.numeric(parts[3])
    C <- as.numeric(parts[4])
    if (! key %in% Errs) {
      Errs <- c(Errs, key)
    }
    Os <- c(Os, O)
    Ss <- c(Ss, S)
    Cs <- c(Cs, C)
  }
  M <- length(Os)
  if (is.null(matO)) matO <- matrix(0, nrow=N, ncol=M, dimnames=list(NULL, Errs))
  if (is.null(matS)) matS <- matrix(0, nrow=N, ncol=M, dimnames=list(NULL, Errs))
  if (is.null(matC)) matC <- matrix(0, nrow=N, ncol=M, dimnames=list(NULL, Errs))
  matO[i,] <- Os
  matS[i,] <- Ss
  matC[i,] <- Cs
}

dfO <- as.data.frame(matO)
dfO$Gap <- Gaps
dfO$Bandwidth <- "Oracle"

dfS <- as.data.frame(matS)
dfS$Gap <- Gaps
dfS$Bandwidth <- "Silverman"

dfC <- as.data.frame(matC)
dfC$Gap <- Gaps
dfC$Bandwidth <- "CV"

df <- rbind(dfO, dfS, dfC)
df$Bandwidth <- as.factor(df$Bandwidth)

coefO <- coef(lm(log(dfO$`Relative MISE`) ~ dfO$Gap))
coefS <- coef(lm(log(dfS$`Relative MISE`) ~ dfS$Gap))
coefC <- coef(lm(log(dfC$`Relative MISE`) ~ dfC$Gap))


pdf(file="MISE-vs-population-risk-gap.pdf")
ggplot(df) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Gap, y=MISE, colour=Bandwidth, shape=Bandwidth), size=3)
dev.off()
pdf(file="RMISE-vs-population-risk-gap.pdf")
ggplot(df) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Gap, y=`Relative MISE`, colour=Bandwidth, shape=Bandwidth), size=3) +
  stat_function(fun=function(x) {exp(coefO[2] * x + coefO[1])}, aes(colour="Oracle"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefS[2] * x + coefS[1])}, aes(colour="Silverman"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefC[2] * x + coefC[1])}, aes(colour="CV"), xlim=c(0, 4))
dev.off()
pdf(file="RMISE-vs-population-risk-gap-log-log.pdf")
ggplot(df) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Gap, y=`Relative MISE`, colour=Bandwidth, shape=Bandwidth), size=3) +
  stat_function(fun=function(x) {exp(coefO[2] * x + coefO[1])}, aes(colour="Oracle"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefS[2] * x + coefS[1])}, aes(colour="Silverman"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefC[2] * x + coefC[1])}, aes(colour="CV"), xlim=c(0, 4)) +
  coord_trans(y='log10') +
  annotation_logticks(sides="l", scaled=FALSE)
dev.off()

Selector <- c("Oracle", "Silverman", "CV")
Gap <- c(coefO[2], coefS[2], coefC[2])

df.alpha <- data.frame(Selector, Gap)
df.alpha.latex <- latex(df.alpha,
                        title="rmise_convergence_table",
                        where="htbp",
                        label="tab:results:rmise_convergence_by_pop_incident_gap",
                        rowname=NULL,
                        booktabs=TRUE,
                        cdec=c(0,3),
                        caption.loc="bottom",
                        caption="RMISE convergence rate by incident-population peak distance for different bandwidth selectors for a single-peak risk function with spread of 1.0 on a single-peak population of 10,000.",
                        caption.lot="RMISE Convergence rate by incident-population peak distance")

coefO <- coef(lm(log(dfO$`Normalized MISE`) ~ dfO$Gap))
coefS <- coef(lm(log(dfS$`Normalized MISE`) ~ dfS$Gap))
coefC <- coef(lm(log(dfC$`Normalized MISE`) ~ dfC$Gap))

pdf(file="NMISE-vs-population-risk-gap.pdf")
ggplot(df) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Gap, y=`Normalized MISE`, colour=Bandwidth, shape=Bandwidth), size=3) +
  stat_function(fun=function(x) {exp(coefO[2] * x + coefO[1])}, aes(colour="Oracle"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefS[2] * x + coefS[1])}, aes(colour="Silverman"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefC[2] * x + coefC[1])}, aes(colour="CV"), xlim=c(0, 4))
dev.off()
pdf(file="NMISE-vs-population-risk-gap-log-log.pdf")
ggplot(df) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Gap, y=`Normalized MISE`, colour=Bandwidth, shape=Bandwidth), size=3) +
  stat_function(fun=function(x) {exp(coefO[2] * x + coefO[1])}, aes(colour="Oracle"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefS[2] * x + coefS[1])}, aes(colour="Silverman"), xlim=c(0, 4)) +
  stat_function(fun=function(x) {exp(coefC[2] * x + coefC[1])}, aes(colour="CV"), xlim=c(0, 4)) +
  coord_trans(y='log10') +
  annotation_logticks(sides="l", scaled=FALSE)
dev.off()

Selector <- c("Oracle", "Silverman", "CV")
Gap <- c(coefO[2], coefS[2], coefC[2])

df.alpha <- data.frame(Selector, Gap)
df.alpha.latex <- latex(df.alpha,
                        title="nmise_convergence_table",
                        where="htbp",
                        label="tab:results:nmise_convergence_by_pop_incident_gap",
                        rowname=NULL,
                        booktabs=TRUE,
                        cdec=c(0,3),
                        caption.loc="bottom",
                        caption="NMISE convergence rate by incident-population peak distance for different bandwidth selectors for a single-peak risk function with spread of 1.0 on a single-peak population of 10,000.",
                        caption.lot="NMISE Convergence rate by incident-population peak distance")

