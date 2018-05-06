setwd("C:/Users/Harold/Dropbox/MA_Knowledge_and_Info/Thesis/thesis/img")

pts <- c(0.8, 1, 1.2, 1.6, 1.7, 1.8, 1.9, 2.0)
N <- length(pts)

evals <- seq(0.3, 2.3, 0.02)

h <- 0.3

K <- function(x, x0, h=1) {
  d2 <- (x-x0)^2/h^2
  R <- 1/(h*N)*(1 - d2)^2
  R[d2>1] <- 0
  R
}

pdf(file="kernel1d.pdf")
plot(pts, rep(0, N), ylim=c(0,1.5), xlim=c(0.3,2.3), pch=20, xlab=NA, ylab=NA)

F <- rep(0, length(evals))
for (pt in pts) {
  Y <- K(evals, pt, h)
  F <- F + Y
  lines(evals, Y, lty="longdash", lwd=1.5)
}

lines(evals, F, lwd=1.5)
dev.off()
