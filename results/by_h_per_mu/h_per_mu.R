library(xtable)
library(doublekernel)

ENs <- c(50, 100, 200, 500, 1000)

mu <- numeric()

oracle.nmise <- numeric()
silverman.nmise <- numeric()
cv.nmise <- numeric()

oracle.best_h1 <- numeric()
oracle.best_h2 <- numeric()
silverman.mean_h <- numeric()
cv.mean_h1 <- numeric()
cv.mean_h2 <- numeric()


for (EN.i in ENs) {
  DIR <- paste("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/unif_", EN.i, "_1.0_1h", sep="")
  setwd(DIR)
  source("experiment_setup.R")
  load("output/experiment.RData")

  factor <- experiment$EN.i
  mu <- c(mu, factor)

  oracle.nise <- 10**9 * compare_peaks.result$oracle.ise / factor**2
  silverman.nise <- 10**9 * compare_peaks.result$silverman.ise / factor**2
  cv.nise <- 10**9 * compare_peaks.result$cv.ise / factor**2

  oracle.nmise <- c(oracle.nmise, mean(oracle.nise))
  silverman.nmise <- c(silverman.nmise, mean(silverman.nise))
  cv.nmise <- c(cv.nmise, mean(cv.nise))

  oracle.best_h1 <- c(oracle.best_h1, oracle.result$best.bandwidth[1])
  oracle.best_h2 <- c(oracle.best_h2, oracle.result$best.bandwidth[2])
  silverman.mean_h <- c(silverman.mean_h, mean(compare_peaks.result$silverman.bandwidth))
  cv.mean_h1 <- c(cv.mean_h1, mean(compare_peaks.result$cv.bandwidth.x1))
  cv.mean_h2 <- c(cv.mean_h2, mean(compare_peaks.result$cv.bandwidth.x2))

}

setwd("/Users/harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/results/by_h_per_mu/")

df <- data.frame(mu, oracle.best_h1, oracle.best_h2, silverman.mean_h,
                 oracle.nmise, silverman.nmise, cv.nmise)

tb <- xtable(df,
             caption=c("Bandwidth and accuracy by number of incidents for uniform population of 10,000 with single-peak risk function, spread of 1.0. The NMISE values are scaled by $10^9$.",
                       "Bandwidth and accuracy by number of incidents"),
             label="tab:results:bandwidth_vs_mu")
colnames(tb) <- c("$\\mu$", '$h_{o}(x_1)$', '$h_{o}(x_2)$', '$h_{s}$', 'Oracle NMISE', 'Silverman NMISE', 'CV NMISE')

print(tb, include.rownames=FALSE, sanitize.colnames.function=identity)
print(tb, include.rownames=FALSE, sanitize.colnames.function=identity, file="h_per_mu.tex")
