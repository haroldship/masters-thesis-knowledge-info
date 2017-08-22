library(ggplot2)

setwd("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/by_num_cases")

Cases <- c(50, 100, 200, 500, 1000)
Dirs <- sapply(Cases, function(case) paste('../unif_', case, '_1_1h/output/', sep=''))
Files <- sapply(Dirs, function(dir) paste(dir, 'mean_table.tex', sep=''))

dfO <- data.frame(Case=Cases,
                  Bandwidth="Oracle",
                  MISE=c(0.000008, 0.000022, 0.000053, 0.000070, 0.000379),
                  RMISE=c(0.005208, 0.003358, 0.002029, 0.001041, 0.000581)
                  )
dfS <- data.frame(Case=Cases,
                  Bandwidth="Silverman",
                  MISE=c(0.000014, 0.000035, 0.000083, 0.000265, 0.000619),
                  RMISE=c(0.008600, 0.005293, 0.003184, 0.001626, 0.000948)
                  )
dfC <- data.frame(Case=Cases,
                  Bandwidth="CV",
                  MISE=c(0.000014, 0.000034, 0.000082, 0.000244, 0.000484),
                  RMISE=c(0.008580, 0.005266, 0.003129, 0.001496, 0.000742)
                  )
df <- rbind(dfO, dfS, dfC)
df$Bandwidth <- as.factor(df$Bandwidth)

pdf(file="MISE-vs-cases.pdf")
ggplot(df) +
  geom_line(aes(x=Case, y=MISE, colour=Bandwidth))
dev.off()
pdf(file="RMISE-vs-cases.pdf")
ggplot(df) +
  geom_line(aes(x=Case, y=RMISE, colour=Bandwidth))
dev.off()

