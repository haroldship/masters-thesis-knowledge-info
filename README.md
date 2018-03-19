# Investigating the Statistical Properties of the Double Kernel Density Estimator
## Harold Ship, University of Haifa

### Fixed in version 0.8
 - [x] Results: 5.1 mentions 5.6-7 but not 5.2-4

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

### To Do 28-2-2018

 - [x] Explain error measures with formulas
 - [x] subcaption titles are too wide
 - [x] appendix: subcaptions on top of tables
 - [x] subcaption: "true risk function <del>distribution</del>"
 - [x] *factor* see if another term is common otherwise use *expected number of incidents*
 - [ ] Conclusion: How good is Silverman?
 - [x] Conclusion: when is Silverman better than CV?
 - [ ] Why is MISE going up?
 - [x] replace "decay rate" with sigma_p, sigma_i, etc and "spread"
 - [ ] Results: convergence rates
 - [x] Method: explain the units of distance
 - [ ] Silverman's peak bias is positive in some cases: explain
 - [ ] Appendix: A.10 table: Silverman is better than CV
 - [ ] Appendix: for each section, plot accuracy measures vs. expected number of incidents
 - [ ] Conclusion: when is centroid better than peak?
 - [x] Results: How does spread affect bandwidth?
 - [ ] Conclusion: Is Silverman bandwidth smaller in cases of positive bias?
 - [ ] Appendix: A.8 mention in subsection title that peaks are in same place
 - [x] Appendix: table 36 oracle is worse than Silverman?
 - [x] No headers on pages
 - [ ] Compare bandwidths for 2 peaks: peak drift vs centroid drift, same for bias
 - [ ] Appendix: A.10 title should say peaks are NOT in same place
 - [x] Method: mention no edge effect compensation
 - [ ] Appendix: A.47 graph is weird
 - [ ] Appendix: A.10 biases are positive even for Oracle
 - [ ] Conclusion: Further work: more study on other distributions

### To Do 7-3-2018
 - [x] Method: add "relative" and "normalized" error measures
 - [x] Method: more rigorous math
 - [x] Method: use "approximate" instead of "estimate" for MISE, MIAE etc.
 - [x] Method: use \widetilde instead of \hat on MISE, MIAE, etc.
 - [x] use (x_1, x_2) instead of vector x
 - [x] Discussion: move 5.8 to 6
 - [x] Method: mention parallelization and randomization algorithms and R packages, and AWS including which instance types and other details of execution
 - [ ] Introduction: define "statistical properties"
 
### To  Do 14-3-2018
 - [ ] Appendix: some tables are squished. Paragraph indentation?
 - [x] Results: 5.1 mention that population and incident bivariate normal is independent with equal variances (and move to Method)
 - [x] Results: 5.1 mention the actual size of the study area (and move to Method)
 - [ ] Results: 5.1 drift needs to be seen in relation to square
 - [x] Results: 5.1 mentions 5.6-7 but not 5.2-4
 - [ ] Results: 5.2 sample size: **n = actual** number of incidents; state that we fix the expected but observe actual
 - [x] Method: describe the data generation process
 - [ ] Theoretical background: describe rejection sampling
 - [ ] Results: Figure 5.10 "empirical distribution of <del>MISE</del> and <del>RMISE</del>"
 - [ ] Define h_opt
 - [ ] For NMIAE and NSUP - use mu not mu^2
 - [ ] 5.2/5.3 describe what's in the tables and make a plot (log-log?)
 - [ ] 5.2/5.3 add CV bandwidths to tables
 - [ ] 5.2/5.3 split titles to 2 rows
 - [ ] 5.2/5.3 add "mean" to h_o, etc.
 - [ ] "error fell with increasing <del>the multiplication expected number of incidents</del>" + "mu"
 - [ ] "negative polynomial order" <-- check
 - [ ] Discussion: overall plot of everything e.g. NMISE of CV, Silv, Oracle vs. experiment number
 - [ ] Discussion: 6.2 needs MORE
 - [ ] Discussion: 6.1 needs plot to illustrate
 - [ ] Conclusion: needs BOTTOM LINE
 - [ ] Conclusion: "performance" - break down to different measures
 - [ ] Conclusion: for MISE, CV ~~ Oracle which is the best we can hope for; MIAE, Sup are similar but peak bias & drift maybe not
 - [ ] Conclusion: peak vs. centroid for drift & bias
 - [ ] Discussion: bias is negative but not always - when? why?
 - [ ] Conclusion: can we look at data and predict which technique would perform better?
 - [ ] Conclusion: Limitation: in real life, distributions can be more complicated
 - [ ] Conclusion: Silverman is nearly as good as CV but **much** easier to compute

