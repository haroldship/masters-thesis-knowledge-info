# 0: setup the physical environment

deps <- c("ggplot2", "lattice", "latticeExtra", "parallel", "xtable")
installed <- installed.packages()

for (lib in deps) {
  if (! lib %in% installed) {
    install.packages(lib, quiet=TRUE, repos="http://cran.rstudio.com")
  }
  library(lib, character.only=TRUE)
}

install.packages("../doublekernel_0.0.0.9000.tar.gz", repos=NULL, type="source")
library(doublekernel)

outdir <- "output"
if (! dir.exists(outdir)) {
  dir.create(outdir)
  Sys.chmod(outdir, mode="0777", use_umask=FALSE)
}

# 1: create the experimental setup
set.seed(12)
experiment <- Experiment(
  x1.min=-4,
  x1.max=4,
  x2.min=-4,
  x2.max=4,
  grid.by=0.1,
  buffer=0.5,
  N.p=10000,
  EN.i=100,
  bandwidths=seq(0.3, 2.8, 0.1),
    c1=0.0,
    c2=0.0,
  sigma1=0.7,
  sigma2=0.7,
  rho=0,
  incident_rate=genhill()
  #incident_rate=gentwohills(center1=c(1.5,0), factor1=0.4, center2=c(-1.5,0), factor2=0.6)
)

MC.oracle <- 49
MC <- 1000

# 2. Compute the Oracle bandwidth
oracle.result <- oracle(experiment, MC=MC.oracle, nCores=1)

# 3. Run the simulations
compare_peaks.result <- compare_peaks(experiment, oracle.result, MC=MC, nCores=1)

# 4. Compute the mean and standard deviation of the measures from the simulation output
mean_values <- data.frame(
  silverman.rmise=mean(compare_peaks.result$silverman.rise),
  silverman.rmiae=mean(compare_peaks.result$silverman.riae),
  silverman.mise=mean(compare_peaks.result$silverman.ise),
  silverman.miae=mean(compare_peaks.result$silverman.iae),
  silverman.msup=mean(compare_peaks.result$silverman.sup),
  silverman.merr=mean(compare_peaks.result$silverman.peak_err),
  silverman.mdist=mean(compare_peaks.result$silverman.peak_dist),
  silverman.mcerr=mean(compare_peaks.result$silverman.cent_err),
  silverman.mcdist=mean(compare_peaks.result$silverman.cent_dist),
  oracle.rmise=mean(compare_peaks.result$oracle.rise),
  oracle.rmiae=mean(compare_peaks.result$oracle.riae),
  oracle.mise=mean(compare_peaks.result$oracle.ise),
  oracle.miae=mean(compare_peaks.result$oracle.iae),
  oracle.msup=mean(compare_peaks.result$oracle.sup),
  oracle.merr=mean(compare_peaks.result$oracle.peak_err),
  oracle.mdist=mean(compare_peaks.result$oracle.peak_dist),
  oracle.mcerr=mean(compare_peaks.result$oracle.cent_err),
  oracle.mcdist=mean(compare_peaks.result$oracle.cent_dist),
  cv.rmise=mean(compare_peaks.result$cv.rise),
  cv.rmiae=mean(compare_peaks.result$cv.riae),
  cv.mise=mean(compare_peaks.result$cv.ise),
  cv.miae=mean(compare_peaks.result$cv.iae),
  cv.msup=mean(compare_peaks.result$cv.sup),
  cv.merr=mean(compare_peaks.result$cv.peak_err),
  cv.mdist=mean(compare_peaks.result$cv.peak_dist),
  cv.mcerr=mean(compare_peaks.result$cv.cent_err),
  cv.mcdist=mean(compare_peaks.result$cv.cent_dist)
)

sd_values <- data.frame(
  silverman.rmise=sd(compare_peaks.result$silverman.rise),
  silverman.rmiae=sd(compare_peaks.result$silverman.riae),
  silverman.mise=sd(compare_peaks.result$silverman.ise),
  silverman.miae=sd(compare_peaks.result$silverman.iae),
  silverman.msup=sd(compare_peaks.result$silverman.sup),
  silverman.merr=sd(compare_peaks.result$silverman.peak_err),
  silverman.mdist=sd(compare_peaks.result$silverman.peak_dist),
  silverman.mcerr=sd(compare_peaks.result$silverman.cent_err),
  silverman.mcdist=sd(compare_peaks.result$silverman.cent_dist),
  oracle.rmise=sd(compare_peaks.result$oracle.rise),
  oracle.rmiae=sd(compare_peaks.result$oracle.riae),
  oracle.mise=sd(compare_peaks.result$oracle.ise),
  oracle.miae=sd(compare_peaks.result$oracle.iae),
  oracle.msup=sd(compare_peaks.result$oracle.sup),
  oracle.merr=sd(compare_peaks.result$oracle.peak_err),
  oracle.mdist=sd(compare_peaks.result$oracle.peak_dist),
  oracle.mcerr=sd(compare_peaks.result$oracle.cent_err),
  oracle.mcdist=sd(compare_peaks.result$oracle.cent_dist),
  cv.rmise=sd(compare_peaks.result$cv.rise),
  cv.rmiae=sd(compare_peaks.result$cv.riae),
  cv.mise=sd(compare_peaks.result$cv.ise),
  cv.miae=sd(compare_peaks.result$cv.iae),
  cv.msup=sd(compare_peaks.result$cv.sup),
  cv.merr=sd(compare_peaks.result$cv.peak_err),
  cv.mdist=sd(compare_peaks.result$cv.peak_dist),
  cv.mcerr=sd(compare_peaks.result$cv.cent_err),
  cv.mcdist=sd(compare_peaks.result$cv.cent_dist)
)


# 5. Output the results

# a) population
pdf(file=paste(outdir, "population-heatmap.pdf", sep="/"))
p <- levelplot(experiment$pop.true,
               row.values=experiment$region$x1,
               column.values=experiment$region$x2,
               xlab=expression(X[1]),
               ylab=expression(X[2]),
               main="True population distribution")
print(p)
dev.off()

pop <- as.data.frame(experiment$population)
names(pop) <- c('X1', 'X2')

pdf(file=paste(outdir, "population-points.pdf", sep="/"))
p <- xyplot(X2 ~ X1, data=pop,
            cex=0.2,
            aspect=1,
            xlim=c(experiment$region$x1.min, experiment$region$x1.max),
            ylim=c(experiment$region$x2.min, experiment$region$x2.max),
            xlab=expression(X[1]),
            ylab=expression(X[2]),
            main="Population locations")
print(p)
dev.off()

# b) error histograms

pdf(file=paste(outdir, "ise-relative-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Relative ISE") +
  geom_histogram(aes(x=cv.rise, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.rise, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.rise, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.rmise, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.rmise, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.rmise, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "ise-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("ISE") +
  geom_histogram(aes(x=cv.ise, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.ise, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.ise, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.mise, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.mise, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.mise, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "iae-relative-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Relative IAE") +
  geom_histogram(aes(x=cv.riae, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.riae, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.riae, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.rmiae, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.rmiae, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.rmiae, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "iae-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("IAE") +
  geom_histogram(aes(x=cv.iae, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.iae, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.iae, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.miae, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.miae, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.miae, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "maxerr-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Sup (Maximum)") +
  geom_histogram(aes(x=cv.sup, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.sup, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.sup, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.msup, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.msup, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.msup, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "centroid-dist-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Relative Peak distances - centroid") +
  geom_histogram(aes(x=cv.cent_dist, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.cent_dist, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.cent_dist, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.mcdist, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.mcdist, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.mcdist, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "peak-dist-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Peak distances") +
  geom_histogram(aes(x=cv.peak_dist, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.peak_dist, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.peak_dist, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.mdist, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.mdist, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.mdist, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "centroid-height-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Peak height error - centroid") +
  geom_histogram(aes(x=cv.cent_err, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.cent_err, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.cent_err, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.mcerr, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.mcerr, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.mcerr, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

pdf(file=paste(outdir, "peak-height-histogram.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Peak height error") +
  geom_histogram(aes(x=cv.peak_err, fill="CV"), alpha=.5) +
  geom_histogram(aes(x=oracle.peak_err, fill="Oracle"), alpha=.5) +
  geom_histogram(aes(x=silverman.peak_err, fill="Silverman"), alpha=.5) +
  geom_vline(data=mean_values, aes(xintercept=oracle.merr, colour="Oracle"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=cv.merr, colour="CV"),
             linetype="dashed", size=1, show.legend=FALSE) +
  geom_vline(data=mean_values, aes(xintercept=silverman.merr, colour="Silverman"),
             linetype="dashed", size=1, show.legend=FALSE)
dev.off()

# c) bandwidth plots
pdf(file=paste(outdir, "bandwidths-x1.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("CV Bandwidths X1") +
  geom_histogram(aes(x=cv.bandwidth.x1, fill="X1"), alpha=.5)
dev.off()

pdf(file=paste(outdir, "bandwidths-x2.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("CV Bandwidths X2") +
  geom_histogram(aes(x=cv.bandwidth.x2, fill="X2"), alpha=.5)
dev.off()

pdf(file=paste(outdir, "bandwidths-silverman.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle("Silverman Bandwidths") +
  geom_histogram(aes(x=silverman.bandwidth, fill="Silverman"), alpha=.5)
dev.off()

pdf(file=paste(outdir, "bandwidths-difference.pdf", sep="/"))
ggplot(compare_peaks.result) +
  ggtitle(expression(X[1] - X[2])) +
  geom_histogram(aes(x=cv.bandwidth.x1 - cv.bandwidth.x2), fill="blue", alpha=0.5)
dev.off()

# 5 output results table
#options(digits=4)
max.val <- max(experiment$Rtrue)
base <- experiment$region$x1.max - experiment$region$x1.min - 2*experiment$region$buffer

measures <- c("MISE", "Relative MISE",
              "MIAE", "Relative MIAE",
              "Max Error",
              "Peak bias", "Relative Peak bias",
              "Peak drift", "Relative Peak drift",
              "Centroid bias", "Relative Centroid bias",
              "Centroid drift", "Relative Centroid drift")

meansdf <- data.frame(
  Oracle=c(mean_values$oracle.mise[1], mean_values$oracle.rmise[1],
           mean_values$oracle.miae[1], mean_values$oracle.rmiae[1],
           mean_values$oracle.msup[1],
           mean_values$oracle.merr[1], mean_values$oracle.merr[1]/max.val,
           mean_values$oracle.mdist[1], mean_values$oracle.mdist[1]/base,
           mean_values$oracle.mcerr[1], mean_values$oracle.mcerr[1]/max.val,
           mean_values$oracle.mcdist[1], mean_values$oracle.mcdist[1]/base),
  Silverman=c(mean_values$silverman.mise[1], mean_values$silverman.rmise[1],
           mean_values$silverman.miae[1], mean_values$silverman.rmiae[1],
           mean_values$silverman.msup[1],
           mean_values$silverman.merr[1], mean_values$silverman.merr[1]/max.val,
           mean_values$silverman.mdist[1], mean_values$silverman.mdist[1]/base,
           mean_values$silverman.mcerr[1], mean_values$silverman.mcerr[1]/max.val,
           mean_values$silverman.mcdist[1], mean_values$silverman.mcdist[1]/base),
  CV=c(mean_values$cv.mise[1], mean_values$cv.rmise[1],
           mean_values$cv.miae[1], mean_values$cv.rmiae[1],
           mean_values$cv.msup[1],
           mean_values$cv.merr[1], mean_values$cv.merr[1]/max.val,
           mean_values$cv.mdist[1], mean_values$cv.mdist[1]/base,
           mean_values$cv.mcerr[1], mean_values$cv.mcerr[1]/max.val,
           mean_values$cv.mcdist[1], mean_values$cv.mcdist[1]/base)#,
)
rownames(meansdf) <- measures

mean_table <- xtable(meansdf, digits=6, caption="Mean error rates", label="tbl:mean_error_rates")
sink(paste(outdir, "mean_table.tex", sep="/"))
print(mean_table, include.rownames=TRUE)
sink()

stddevdf <- data.frame(
  Oracle=c(sd_values$oracle.mise[1], sd_values$oracle.rmise[1],
           sd_values$oracle.miae[1], sd_values$oracle.rmiae[1],
           sd_values$oracle.msup[1],
           sd_values$oracle.merr[1], sd_values$oracle.merr[1]/max.val,
           sd_values$oracle.mdist[1], sd_values$oracle.mdist[1]/base,
           sd_values$oracle.mcerr[1], sd_values$oracle.mcerr[1]/max.val,
           sd_values$oracle.mcdist[1], sd_values$oracle.mcdist[1]/base),
  Silverman=c(sd_values$silverman.mise[1], sd_values$silverman.rmise[1],
              sd_values$silverman.miae[1], sd_values$silverman.rmiae[1],
              sd_values$silverman.msup[1],
              sd_values$silverman.merr[1], sd_values$silverman.merr[1]/max.val,
              sd_values$silverman.mdist[1], sd_values$silverman.mdist[1]/base,
              sd_values$silverman.mcerr[1], sd_values$silverman.mcerr[1]/max.val,
              sd_values$silverman.mcdist[1], sd_values$silverman.mcdist[1]/base),
  CV=c(sd_values$cv.mise[1], sd_values$cv.rmise[1],
       sd_values$cv.miae[1], sd_values$cv.rmiae[1],
       sd_values$cv.msup[1],
       sd_values$cv.merr[1], sd_values$cv.merr[1]/max.val,
       sd_values$cv.mdist[1], sd_values$cv.mdist[1]/base,
       sd_values$cv.mcerr[1], sd_values$cv.mcerr[1]/max.val,
       sd_values$cv.mcdist[1], sd_values$cv.mcdist[1]/base)#,
)
rownames(stddevdf) <- measures

std_table <- xtable(stddevdf, digits=6, caption="Standard deviation of error rates", label="tbl:stddev_error_rates")
sink(paste(outdir, "mean_table.tex", sep="/"))
print(std_table, include.rownames=TRUE)
sink()

# print/plot one simulation
x <- one_sim(experiment, oracle.result, plot=TRUE, outputdir=outdir)

