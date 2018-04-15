library(ggplot2)

setwd("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/by_overall")

Dirs <- list.files("..", pattern="^[u].*", full.names=TRUE)
Files <- sapply(Dirs, function(dir) paste(dir, '/output/mean_table.tex', sep=''))

N <- length(Files)

Errs <- character()

matO <- NULL
matS <- NULL
matC <- NULL


for (i in 1:N) {
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
dfO$Bandwidth <- "Oracle"

dfS <- as.data.frame(matS)
dfS$Bandwidth <- "Silverman"

dfC <- as.data.frame(matC)
dfC$Bandwidth <- "CV"

df <- rbind(dfO, dfS, dfC)
df$Bandwidth <- factor(df$Bandwidth, levels=c("Oracle", "CV", "Silverman"))

dfS.diff <- dfS[,1:3] - dfO[,1:3]
dfS.diff$Bandwidth <- "Silverman"

dfC.diff <- dfC[,1:3] - dfO[,1:3]
dfC.diff$Bandwidth <- "CV"

df.diff <- rbind(dfC.diff, dfS.diff)
df.diff$Bandwidth <- as.factor(df.diff$Bandwidth)

pdf("normalized-mise-boxplot.pdf")
boxplot(df$`Normalized MISE` ~ df$Bandwidth)
dev.off()

pdf("normalized-miae-boxplot.pdf")
boxplot(df$`Normalized MIAE` ~ df$Bandwidth)
dev.off()

pdf("normalized-sup-error-boxplot.pdf")
boxplot(df$`Normalized Sup error` ~ df$Bandwidth)
dev.off()

pdf("relative-peak-bias-boxplot.pdf")
boxplot(df$`Relative Peak bias` ~ df$Bandwidth)
dev.off()

pdf("relative-centroid-bias-boxplot.pdf")
boxplot(df$`Relative Centroid bias` ~ df$Bandwidth)
dev.off()

pdf("relative-peak-drift-boxplot.pdf")
boxplot(df$`Relative Peak drift` ~ df$Bandwidth)
dev.off()

pdf("relative-centroid-drift-boxplot.pdf")
boxplot(df$`Relative Centroid drift` ~ df$Bandwidth)
dev.off()

pdf("normalized-mise-diff-boxplot.pdf")
boxplot(df.diff$`Normalized MISE` ~ df.diff$Bandwidth)
dev.off()
