Part 2: Registration
================

- [1 Load Packages](#1-load-packages)
- [2 Data](#2-data)
- [3 Landmark Registration](#3-landmark-registration)
- [4 References](#4-references)
- [5 Session Information
  (Reproducibility)](#5-session-information-reproducibility)

<center>

![](../logo/ISBS-Logo-2024.png) ![](../logo/whitespace.png)
![](../logo/fda-logo.png)

</center>

# 1 Load Packages

For this section, we just need the `fda` package.

``` r
library(fda) # load the fda package
```

# 2 Data

## 2.1 Short Data Description

We have taken a sample of $30$ functional observations from the GaitRec
dataset (Horsak et al., 2020). These functional data represent the
anterior-posterior ground reaction force measured during walking using
force plates. They are defined on the normalised time domain $[0. 100]$
where $0$ represents the start of the stance phase when the foot touches
the force plate and $100$ represents the end. The force is normalised to
body weight.

## 2.2 Load Data

You should download for this practical the dataset from [this
link](https://github.com/edwardgunning/ISBS-Short-Course/blob/main/practicals/reg-data.rds)
and place it in your working directory. Then we load it and unpack the
objects as follows.

``` r
reg_data <- readRDS(file = "reg-data.rds")
y_fd <- reg_data$y_fd
info_df <- reg_data$info_df
```

The functional data have already been converted to an `fd` object
(`y_fd`), so no need to worry about smoothing or data representation.
The `info_df` data.frame contains some additional information about the
observations (e.g., sex of participant, whether they are impaired or a
healthy control).

## 2.3 Data Exploration

First we will simply plot the functions using the `plot.fd()` function.

``` r
plot.fd(x = y_fd, xlab = "t", ylab = "force (bw)")
```

    ## [1] "done"

``` r
title(main = "Anterior-Posterior GRF")
points(x = c(20, 85), y = c(-0.2, 0.2), cex = 15, col = "red") # add circles to highlight
```

<img src="02-registration_files/figure-gfm/explor-plot-1.png" style="display: block; margin: auto;" />

We see some misalignement of the first and second peaks (circled in
red); these correspond to the maximal propulsive and braking forces in
the movement. In other words, we can say that each individual’s maximal
propulsive and braking force occurs at a slightly different time point.

# 3 Landmark Registration

In this practical, we will use **landmark registration** to align the
curves at the following two points in the movement:

1.  The maximal propulsive force (i.e., the negative peak).

2.  The maxmimal braking force (i.e., the positive peak).

## 3.1 Picking out the landmarks

Because our landmarks are simply the overall maximum and minimum of each
curve, we can pick them out using a simple grid search.

First, we evaluate each curve on a grid of $101$ time points:
$t = 0, 1, \dots, 100$. This results in a $101 \times 30$ matrix with
evaluations of the curves in its columns.

``` r
t_grid <- 0:100
Y_eval <- eval.fd(evalarg = t_grid, fdobj = y_fd)
dim(Y_eval)
```

    ## [1] 101  30

Next, we use the `apply` function to loop through each column of
`Y_eval` and find the the maximum and minimum of each column, as well as
the index of the minimum and maximum (this will tell us *when* the
maximum occurs).

**Note**: `margin = 2` indicates that we are looping over columns.

``` r
y_min_value <- apply(X = Y_eval, MARGIN = 2, FUN = min)
y_min_index <- apply(X = Y_eval, MARGIN = 2, FUN = which.min)

y_max_value <- apply(X = Y_eval, MARGIN = 2, FUN = max)
y_max_index <- apply(X = Y_eval, MARGIN = 2, FUN = which.max)
```

From the indices, we can directly get the landmark timings (i.e., which
times the minimum and maximum occur).

``` r
t_min <- t_grid[y_min_index]
t_max <- t_grid[y_max_index]
```

Let’s plot out a sample of curves and their landmark timings to verify
that we’ve done this correctly.

``` r
inds_obs_plot <- c(1, 11, 21) # indices of three observations to plot
plot(y_fd[inds_obs_plot], xlab = "t", ylab = "force (bw)")
```

    ## [1] "done"

``` r
points(t_min[inds_obs_plot], y_min_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
points(t_max[inds_obs_plot], y_max_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
```

<img src="02-registration_files/figure-gfm/plot-landmarks-1.png" style="display: block; margin: auto;" />

## 3.2 Using the `landmarkreg()` function

The `landmarkreg()` function takes the following main arguments (see
`?landmarkreg` for full detials):

- `fdobj`: This functional data object contains the curves to be
  registered. In our case this will be the object `y_fd`.

- `ximarks`: This matrix contains the landmark timings for each curve.
  It is in the form of an $N \times NL$ matrix where $NL$ represents the
  number of landmarks. In our case we have $N=30$ curves and $NL=2$
  landmarks (the minimum and maximum), so we set up a $30 \times 2$
  matrix and put the vectors of landmark timings `t_min` and `t_max` in
  its columns.

``` r
ximarks_mat <- matrix(data = NA, nrow = 30, ncol = 2) # set up empty matrix
ximarks_mat[, 1] <- t_min
ximarks_mat[, 2] <- t_max
```

- `x0marks`: A vector of length NL of times of landmarks for target
  curve – here as targets we’ll just use the mean average of each
  landmark timing.

``` r
x0marks_vec <- c(mean(t_min), mean(t_max))
```

- `Wfdpar` (and
  `Wfd0par): a functional parameter object defining the (inverse) warping functions. For this we first set up a B-spline basis with interior knots at the mean values of the two landmarks using the`breaks\`
  argument.

``` r
bspline_basis_wfd <- create.bspline.basis(rangeval = c(0, 100),
                                          breaks = c(0, mean(t_min), mean(t_max), 100),
                                          norder = 4)
```

Then, because we use a special representation to ensure that the warping
functions are non-negative, which relies on an iterative approach to
estimate the basis coefficients, we also set up a `fd` (rather than
`basisfd`) object. We’ll choose all $0$’s as our starting values for the
coefficients.

``` r
WfdLM <- fd(coef = matrix(0, bspline_basis_wfd$nbasis, 1), 
            basisobj =  bspline_basis_wfd) # are these initial guesses
```

Finally, we will pass this `fd` object to the `fdPar()` function to
create a functional parameter object to represent the warping functions,
with a second derivative roughness penalty and a (arbitraily chosen)
smoothing parameter of $\lambda = 10^{-8}$.

``` r
WfdParLM <- fdPar(fdobj = WfdLM, Lfdobj = int2Lfd(2), lambda = 1e-6)
```

- `x0lim`: A vector of length 2 containing the lower and upper boundary
  of the interval containing x0marks. Since we are constrng warping
  functions that map functions to the same domain ($[0, 100]$ to
  $[0, 100]$) this is just the range of our domain `c(0, 100)`.

- `ylambda`: Because the landmark registration involves a re-smoothing/
  interpolation of the curves, we specify a small smoothing penalty
  (`1e-8`) in this step to avoid artificial bumps or wiggles that
  sometimes occur.

We then go ahead and perform the landmark registration. We can see that
it is applied sequentially for each curve.

``` r
landmark_reg_obj <- landmarkreg(
  unregfd = y_fd, 
  ximarks = ximarks_mat,
  x0marks = x0marks_vec,
  WfdPar = WfdParLM,
  WfdPar0 = WfdParLM,
  x0lim = c(0, 100),
  ylambda = 1e-8)
```

    ## Progress:  Each dot is a curve
    ## ..............................

## 3.3 Examining the registered curves

`landmarkreg()` returns a named list of length 4 with components:

- `fdreg`: a functional data object for the registered curves.

- `warpfd`: a functional data object for the warping functions.

- `warpinvfd`: a functional data object for the inverse warping
  functions.

- `Wfd`: a functional data object for the core function defining the
  strictly monotone warping function.

For this practical, we’ll focus on the first two.

``` r
# extract
reg_fd <- landmark_reg_obj$regfd
warp_fd <- landmark_reg_obj$warpfd
```

Let’s look at the registered curves next to their unregistered
counterparts. First we’ll do so for the full dataset.

``` r
par(mfrow = c(1, 2))
plot(y_fd)
```

    ## [1] "done"

``` r
title("Unregistered curves")

plot(reg_fd)
```

    ## [1] "done"

``` r
abline(v = x0marks_vec, col = "grey")
title("Registered curves")
```

<img src="02-registration_files/figure-gfm/unnamed-chunk-8-1.png" style="display: block; margin: auto;" />

And now for the three observations we examined in detail earlier.

``` r
par(mfrow = c(1, 2))
plot(y_fd[inds_obs_plot, ])
```

    ## [1] "done"

``` r
points(t_min[inds_obs_plot], y_min_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
points(t_max[inds_obs_plot], y_max_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
title("Unregistered curves")

plot(reg_fd[inds_obs_plot,])
```

    ## [1] "done"

``` r
abline(v = x0marks_vec, col = "grey")
points(rep(mean(t_min), 3), y_min_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
points(rep(mean(t_max), 3), y_max_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
title("Registered curves")
```

<img src="02-registration_files/figure-gfm/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />

Next, we’ll look at the warping functions for the entire sample.

``` r
plot(warp_fd)
```

<img src="02-registration_files/figure-gfm/unnamed-chunk-10-1.png" style="display: block; margin: auto;" />

    ## [1] "done"

And then for the selected observations.

``` r
plot(warp_fd[inds_obs_plot,])
```

<img src="02-registration_files/figure-gfm/unnamed-chunk-11-1.png" style="display: block; margin: auto;" />

    ## [1] "done"

We see that the warping functions encode the order of landmark timings
that we saw in the plot of the unregistered functions.

## 3.4 Analysis of phase variation

All of the information in the warping functions is encoded in our two
landmarks, so we can examine their relationship between them and other
variables in our data (e.g., sex). Though the sample size of $N=30$
makes it difficult to decipher any clear relationships.

``` r
par(mfrow = c(1, 2))
boxplot(t_min ~ info_df$SEX,
        col = c("red4", "cornflowerblue"),
        xlab = "sex", 
        ylab = "landmark time: min. force")
boxplot(t_max ~ info_df$SEX,
        col = c("red4", "cornflowerblue"),
        xlab = "sex", 
        ylab = "landmark time: max. force")
```

<img src="02-registration_files/figure-gfm/boxplot-sex-1.png" style="display: block; margin: auto;" />

**Note:** When we use more sophisticated continuous registration
techniques, we will need to examine the warping functions directly to
visualise phase variation as we do here (note that we have to use
`lines.fd()` rather than `plot.fd()` as it seems to allow us to specify
colours).

``` r
plot(warp_fd[1,])
```

    ## [1] "done"

``` r
lines(warp_fd, col = ifelse(info_df$SEX == 0, "red4", "cornflowerblue"), lty = 1)
```

<img src="02-registration_files/figure-gfm/unnamed-chunk-12-1.png" style="display: block; margin: auto;" />

## 3.5 A Word of Caution

When using registered functions and warping functions in subsequent
analysis it is important to remember that results will be dependent on
the registration. That is, subjective choices have been made regarding
the type of registration applied (e.g., landmark vs. continuous) and its
implementation (e.g., the basis used to represent that warping
functions). Ideally, this subjectivity could be acknowledged and checked
through a sensitivity analysis.

# 4 References

- Horsak, B., Slijepcevic, D., Raberger, A.-M., Schwab, C., Worisch, M.,
  & Zeppelzauer, M. (2020). GaitRec, a large-scale ground reaction force
  dataset of healthy and impaired gait. Scientific Data, 7(1),
  Article 1. <https://doi.org/10.1038/s41597-020-0481-z>

- Publicly Available Data-Sharing Repository for Full GaitRec Dataset:
  <a href="https://doi.org:10.6084/m9.figshare.c.4788012.v1"
  class="uri">https://doi.org:10.6084/m9.figshare.c.4788012.v1</a>

- **Chapter 8 of** Ramsay, J. O., Hooker, G., & Graves, S. (2009).
  Functional Data Analysis with R and MATLAB. Springer-Verlag.
  <https://doi.org/10.1007/978-0-387-98185-7>

# 5 Session Information (Reproducibility)

``` r
sessionInfo()
```

    ## R version 4.4.1 (2024-06-14)
    ## Platform: aarch64-apple-darwin20
    ## Running under: macOS Sonoma 14.4
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## time zone: America/New_York
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] splines   stats     graphics  grDevices utils     datasets  methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ## [1] fda_6.1.8       deSolve_1.40    fds_1.8         RCurl_1.98-1.14
    ## [5] rainbow_3.8     pcaPP_2.0-4     MASS_7.3-60.2  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] cli_3.6.3          knitr_1.47         rlang_1.1.4        xfun_0.45         
    ##  [5] highr_0.11         KernSmooth_2.23-24 mclust_6.1.1       hdrcde_3.4        
    ##  [9] colorspace_2.1-0   htmltools_0.5.8.1  pracma_2.4.4       rmarkdown_2.27    
    ## [13] grid_4.4.1         evaluate_0.24.0    bitops_1.0-7       ks_1.14.2         
    ## [17] fastmap_1.2.0      yaml_2.3.8         mvtnorm_1.2-5      cluster_2.1.6     
    ## [21] compiler_4.4.1     rstudioapi_0.16.0  lattice_0.22-6     digest_0.6.36     
    ## [25] Matrix_1.7-0       tools_4.4.1
