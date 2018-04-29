# Investigating the Statistical Properties of the Double Kernel Density Estimator
## Harold Ship, University of Haifa

### Fixed in version 0.10
 - [x] Theory: rewrite
 - [x] Literature search: start
 - [x] Results: text mentions colours

### Fixed in version 0.9
 - [x] Discussion: major rewrite
 - [x] Theory: major rewrite
 - [x] Method: double integral with (x1, x2) in W as limits
 - [x] Method: 4.2.1: "in many cases": when & how?
 - [x] Method: 4.4: "A common method for bandwidth selection..." to start
 - [x] Results: (and everywhere) in population and incidents scatter use a different size/symbol instead of colour
 - [x] Results: make all charts b/w or grayscale (not colour)
 - [x] Results: only 2 charts per row
 - [x] Results: bandwidth histograms: lighten fill; why shadow in printed?
 - [x] Discussion: Create Boxplot of MISE distribution comparing Oracle to Silverman to CV selection, possibly OTHER accuracy measures
 - [x] Discussion: Create Boxplot of MISE difference between S-O and CV-O (MISE only)
 - [x] Discussion: overall plot of everything e.g. NMISE of CV, Silv, Oracle vs. experiment number
 - [x] Appendix: Section A.10 title should say peaks are NOT in same place
 - [x] Appendix: Section A.8 mention in subsection title that peaks are in same place

### Fixed in version 0.8
 - [x] Results: major rewrite
 - [x] Results: 5.1 mentions 5.6-7 but not 5.2-4
 - [x] Appendix: some tables are squished. Paragraph indentation?
 - [x] For NMIAE and NSUP - use mu not mu^2
 - [x] Results: Figure 5.10 "empirical distribution of <del>MISE</del> and <del>RMISE</del>"
 - [x] Define h_opt
 - [x] Results: 5.2 sample size: **n = actual** number of incidents; state that we fix the expected but observe actual
 - [x] "error fell with increasing <del>the multiplication expected number of incidents</del>" + "mu"
 - [x] 5.2/5.3 add CV bandwidths to tables
 - [x] 5.2/5.3 split titles to 2 rows
 - [x] 5.2/5.3 add "mean" to h_o, etc.
 - [x] Method: Describe subsections 4.1-4.4 and 4.6.
 - [x] Results: 5.1 drift needs to be seen in relation to square
 - [x] Results: convergence rates
 - [x] 5.2/5.3 describe what's in the tables and make a plot (log-log?)
 - [x] "negative polynomial order" <-- check
 
### Fixed in version 0.7
 - [x] Method: explain the units of distance
 - [x] Method: mention no edge effect compensation
 - [x] Method: mention parallelization and randomization algorithms and R packages, and AWS including which instance types and other details of execution
 - [x] Method: more rigorous math
 - [x] Method: add "relative" and "normalized" error measures
 - [x] Results: 5.1 mention that population and incident bivariate normal is independent with equal variances (and move to Method)
 - [x] Results: 5.1 mention the actual size of the study area (and move to Method)
 - [x] Method: describe the data generation process

### Fixed in version 0.6
 - [x] replace "decay rate" with sigma_p, sigma_i, etc and "spread"
 - [x] No headers on pages
 - [x] Method: use "approximate" instead of "estimate" for MISE, MIAE etc.
 - [x] Method: use \widetilde instead of \hat on MISE, MIAE, etc.
 - [x] Discussion: move 5.8 to 6
 - [x] Conclusion: when is Silverman better than CV?
 - [x] use (x_1, x_2) instead of vector x
 - [x] Results: How does spread affect bandwidth?
 - [x] Appendix: table 36 oracle is worse than Silverman?
   
### Fixed in version 0.5
 - [x] Explain error measures with formulas
 - [x] subcaption titles are too wide
 - [x] appendix: subcaptions on top of tables
 - [x] subcaption: "true risk function <del>distribution</del>"
 - [x] *factor* see if another term is common otherwise use *expected number of incidents*

### TODO

 - [ ] Results: all subsections: compare peak, centroid, etc in each section briefly
 - [ ] Results: all subsections: compare selectors.
 - [ ] Results: all subsections: make more clear MISE chart discussion is for all selectors, etc
 - [ ] Theory: (and everywhere) lambda_i used for intensity AND for index: change intensity to lambda_I/lambda_P
 - [ ] Introduction: define "statistical properties"
 - [ ] Theoretical background: describe rejection sampling
 - [ ] Method: better describe centroid
 - [ ] Method: 4.1 describe the study area
 - [ ] Method: 4.1 put in a picture of pop and incident points
 - [ ] Method: 4.1 Discuss the real-life underlying story of the data with examples
 - [ ] Method: 4.1 Discuss how the real-life underlying story is modeled with SPP or Poisson
 - [ ] Method: 4.1 Describe the kernel method of intensity estimation, assumes some data, "if someone has incident location data, they can use this method"
 - [ ] Method: 4.1 mention 2 kernel methods, incidents vs population
 - [ ] Method: 4.2 define lambda := lambda(., .) to show lambda is a function
 - [ ] Method: 4.2.5: motivation for centroid
 - [ ] Method: 4.2.5: formulas
 - [ ] Method: 4.3: "and scale it" - example
 - [ ] Method: 4.4: "A common method for bandwidth selection..." to start
 - [ ] Method: 4.4: Add formulas and a reference for CV
 - [ ] Method: 4.5: Explain buffer with respect to edge effects
 - [ ] Method: 4.5: use \texttt for variable names
 - [ ] Method: 4.5: explain that the oracle knows the true lambda and so creates a baseline that approximates mise-optimal b/w
 - [ ] Method: 4.5: add a step to compute lambda_p
 - [ ] Method: 4.6: reword last sentence
 - [ ] Method: Add computing and technical issues and solutions: time, AWS, etc. move from wherever.
 - [ ] Appendix: A.47 graph is weird
 - [ ] Appendix: Section A.10 biases are positive even for Oracle
 - [ ] Appendix: A.10 table: Silverman is better than CV
 - [ ] Discussion: Why is MISE going up?
 - [ ] Discussion: 6.2 needs MORE
 - [ ] Discussion: 6.1 needs plot to illustrate
 - [ ] Discussion: bias is negative but not always - when? why?
 - [ ] Compare bandwidths for 2 peaks: peak drift vs centroid drift, same for bias
 - [ ] Conclusion: needs BOTTOM LINE
 - [ ] Conclusion: How good is Silverman?
 - [ ] Conclusion: "performance" - break down to different measures
 - [ ] Conclusion: for MISE, CV ~~ Oracle which is the best we can hope for; MIAE, Sup are similar but peak bias & drift maybe not
 - [ ] Conclusion: peak vs. centroid for drift & bias
 - [ ] Conclusion: can we look at data and predict which technique would perform better?
 - [ ] Conclusion: Limitation: in real life, distributions can be more complicated
 - [ ] Conclusion: Silverman is nearly as good as CV but **much** easier to compute
 - [ ] Conclusion: when is centroid better than peak?
 - [ ] Conclusion: Is Silverman bandwidth smaller in cases of positive bias?
 - [ ] Conclusion: Further work: more study on other distributions

