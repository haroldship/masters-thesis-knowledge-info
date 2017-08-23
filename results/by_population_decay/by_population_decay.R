library(ggplot2)

setwd("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/by_population_decay")

DecayRates <- c(0.7, 1.0, 1.4, 2.0)
Dirs <- sapply(DecayRates, function(rate) paste('../p', format(rate, nsmall=1), '_100_1_1h/output/', sep=''))
Files <- sapply(Dirs, function(dir) paste(dir, 'mean_table.tex', sep=''))

N <- length(DecayRates)
Errs <- character()

matO <- NULL
matS <- NULL
matC <- NULL


for (i in 1:N) {
  DecayRate <- DecayRates[i]
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
dfO$DecayRate <- DecayRates
dfO$Bandwidth <- "Oracle"
dfO <- dfO[dfO$DecayRate!=0.7,]

dfS <- as.data.frame(matS)
dfS$DecayRate <- DecayRates
dfS$Bandwidth <- "Silverman"
dfS <- dfS[dfS$DecayRate!=0.7,]

dfC <- as.data.frame(matC)
dfC$DecayRate <- DecayRates
dfC$Bandwidth <- "CV"
dfC <- dfC[dfC$DecayRate!=0.7,]

df <- rbind(dfO, dfS, dfC)
df$Bandwidth <- as.factor(df$Bandwidth)

coefO <- coef(lm(log(dfO$`Relative MISE`) ~ log(dfO$DecayRate)))
coefS <- coef(lm(log(dfS$`Relative MISE`) ~ log(dfS$DecayRate)))
coefC <- coef(lm(log(dfC$`Relative MISE`) ~ log(dfC$DecayRate)))


pdf(file="MISE-vs-population-decay.pdf")
ggplot(df) +
  geom_point(aes(x=DecayRate, y=MISE, colour=Bandwidth, shape=Bandwidth))
dev.off()
pdf(file="RMISE-vs-population-decay.pdf")
ggplot(df) +
#  stat_function(fun=function(x) {exp(coefO[1])*x**(coefO[2])}, aes(colour="Oracle"), xlim=c(0.4, 2.2)) +
#  stat_function(fun=function(x) {exp(coefS[1])*x**(coefS[2])}, aes(colour="Silverman"), xlim=c(0.4, 2.2)) +
#  stat_function(fun=function(x) {exp(coefC[1])*x**(coefC[2])}, aes(colour="CV"), xlim=c(0.4, 2.2)) +
  geom_point(aes(x=DecayRate, y=`Relative MISE`, colour=Bandwidth, shape=Bandwidth))
dev.off()
pdf(file="RMISE-vs-population-decay-log-log.pdf")
ggplot(df) +
  geom_point(aes(x=DecayRate, y=`Relative MISE`, colour=Bandwidth, shape=Bandwidth)) +
#  stat_function(fun=function(x) {exp(coefO[1])*x**(coefO[2])}, aes(colour="Oracle"), xlim=c(0.4, 2.2)) +
#  stat_function(fun=function(x) {exp(coefS[1])*x**(coefS[2])}, aes(colour="Silverman"), xlim=c(0.4, 2.2)) +
#  stat_function(fun=function(x) {exp(coefC[1])*x**(coefC[2])}, aes(colour="CV"), xlim=c(0.4, 2.2)) +
  coord_trans(x='log10', y='log10') +
  annotation_logticks(scaled=FALSE)
dev.off()
