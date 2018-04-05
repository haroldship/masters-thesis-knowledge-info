library(ggplot2)
library(Hmisc)

setwd("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/by_pop_size")

Pops <- c(5000, 10000, 20000, 50000, 100000)
PopStrs <- c("5k_50", "10k_100", "20k_200", "50k_500", "100k_1000")
Dirs <- sapply(PopStrs, function(pop) paste('../unif', pop, '_1.0_1h/output/', sep=''))
Files <- sapply(Dirs, function(dir) paste(dir, 'mean_table.tex', sep=''))

N <- length(Pops)
Errs <- character()

matO <- NULL
matS <- NULL
matC <- NULL


for (i in 1:N) {
  Pop <- Pops[i]
  File <- Files[i]
  lines <- readLines(File)
  lines <- lines[7:19]
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
dfO$Pop <- Pops
dfO$Bandwidth <- "Oracle"

dfS <- as.data.frame(matS)
dfS$Pop <- Pops
dfS$Bandwidth <- "Silverman"

dfC <- as.data.frame(matC)
dfC$Pop <- Pops
dfC$Bandwidth <- "CV"

df <- rbind(dfO, dfS, dfC)
df$Bandwidth <- as.factor(df$Bandwidth)

coefO <- coef(lm(log(dfO$`Relative MISE`) ~ log(dfO$Pop)))
coefS <- coef(lm(log(dfS$`Relative MISE`) ~ log(dfS$Pop)))
coefC <- coef(lm(log(dfC$`Relative MISE`) ~ log(dfC$Pop)))


pdf(file="MISE-vs-population.pdf")
ggplot(df) +
  xlab(expression(N[p])) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Pop, y=MISE, colour=Bandwidth, shape=Bandwidth))
dev.off()
pdf(file="RMISE-vs-population.pdf")
ggplot(df) +
  xlab(expression(N[p])) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Pop, y=`Relative MISE`, colour=Bandwidth, shape=Bandwidth))
dev.off()
pdf(file="RMISE-vs-population-log-log.pdf")
ggplot(df) +
  xlab(expression(N[p])) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Pop, y=`Relative MISE`, colour=Bandwidth, shape=Bandwidth)) +
  coord_trans(x='log10', y='log10') +
  annotation_logticks(scaled=FALSE)
dev.off()

coefO <- coef(lm(log(dfO$`Normalized MISE`) ~ log(dfO$Pop)))
coefS <- coef(lm(log(dfS$`Normalized MISE`) ~ log(dfS$Pop)))
coefC <- coef(lm(log(dfC$`Normalized MISE`) ~ log(dfC$Pop)))

pdf(file="NMISE-vs-population.pdf")
ggplot(df) +
  xlab(expression(N[p])) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  stat_function(fun=function(x) {exp(coefO[1])*x**(coefO[2])}, aes(colour="Oracle"), xlim=c(4000,110000)) +
  stat_function(fun=function(x) {exp(coefS[1])*x**(coefS[2])}, aes(colour="Silverman"), xlim=c(4000,110000)) +
  stat_function(fun=function(x) {exp(coefC[1])*x**(coefC[2])}, aes(colour="CV"), xlim=c(4000,110000)) +
  geom_point(aes(x=Pop, y=`Normalized MISE`, colour=Bandwidth, shape=Bandwidth))
dev.off()
pdf(file="NMISE-vs-population-log-log.pdf")
ggplot(df) +
  xlab(expression(N[p])) +
  theme(axis.title=element_text(size=20)) +
  theme(legend.text=element_text(size=16, family='NewCenturySchoolbook'),
        legend.title=element_text(size=16, family='NewCenturySchoolbook'),
        legend.key.size=unit(1.5, 'cm')) +
  geom_point(aes(x=Pop, y=`Normalized MISE`, colour=Bandwidth, shape=Bandwidth)) +
  stat_function(fun=function(x) {exp(coefO[1])*x**(coefO[2])}, aes(colour="Oracle"), xlim=c(4000,110000)) +
  stat_function(fun=function(x) {exp(coefS[1])*x**(coefS[2])}, aes(colour="Silverman"), xlim=c(4000,110000)) +
  stat_function(fun=function(x) {exp(coefC[1])*x**(coefC[2])}, aes(colour="CV"), xlim=c(4000,110000)) +
  coord_trans(x='log10', y='log10') +
  annotation_logticks(scaled=FALSE)
dev.off()

