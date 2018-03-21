library(Hmisc)
#library(xtable)
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

df <- data.frame(mu, oracle.best_h1, oracle.best_h2, silverman.mean_h, cv.mean_h1, cv.mean_h2,
                 oracle.nmise, silverman.nmise, cv.nmise)

# tb <- xtable(df,
#              digits=c(0, 0, rep(1, 5), rep(6, 3)),
#              caption=c("Bandwidth and accuracy by number of incidents for uniform population of 10,000 with single-peak risk function, spread of 1.0. The NMISE values are scaled by $10^9$.",
#                        "Bandwidth and accuracy by number of incidents"),
#              label="tab:results:bandwidth_vs_mu")
# colnames(tb) <- c("$\\mu$", 'Mean $h_{o1}$', 'Mean $h_{o2}$', 'Mean $h_{s}$', 'Mean $h_{cv1}$', 'Mean $h_{cv2}$', 'Oracle NMISE', 'Silverman NMISE', 'CV NMISE')
#
# print(tb, include.rownames=FALSE, sanitize.colnames.function=identity)
# print(tb, include.rownames=FALSE, sanitize.colnames.function=identity, file="h_per_mu.tex")

df.latex <- latex(df, file="h_per_mu.tex", title="h_per_mu", where="htbp",
                  label="tab:results:bandwidth_vs_mu",
                  rowname=NULL,
                  cgroup=c("", "Mean Bandwidths", "NMISE"),
                  n.cgroup=c(1, 5, 3),
                  colheads=c("$\\mu$", '$h_{o1}$', '$h_{o2}$', '$h_{s}$', '$h_{cv1}$', '$h_{cv2}$', 'Oracle', 'Silverman', 'CV'),
                  cdec=c(0, rep(1, 5), rep(3, 3)),
                  caption.loc="bottom",
                  caption="Bandwidth and accuracy by number of incidents for uniform population of 10,000 with single-peak risk function, spread of 1.0. The NMISE values are scaled by $10^9$.",
                  caption.lot="Bandwidth and accuracy by number of incidents")
