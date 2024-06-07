Part 2: Registration
================

<center>

![](../logo/isbs-logo.png) ![](../logo/whitespace.png)
![](../logo/fda-logo.png)

</center>

# Load Packages

For this section, we just need the `fda` package.

``` r
library(fda) # load the fda package
library(data.table)
```

# Data

## Short Data Description

## Load Data

``` r
data <- readRDS(file = "data/GRF_dataset_PRO_meta.rds")
data <- as.data.table(data)
table(data$TRIAL_ID)
```

    ## 
    ##    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15 
    ## 3120 3528 3648 3852 3732 3798 3756 3732 3624 3372  894  570  174   42    6

``` r
data <- data[CLASS_LABEL == "HC" & side == "left" & TRIAL_ID == 1 & TRAIN_BALANCED ==1 & component == "anterior_posterior"]
Y <- t(as.matrix(data[, `time_0`:`time_100`]))
t <- 0:100
y_fd <- Data2fd(argvals = t, y = Y)
```

# Data Exploration

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

# Landmark Registration

In this practical, we will use **landmark registration** to align the
curves at the following two points in the movement:

1.  The maximal propulsive force (i.e., the negative peak).

2.  The maxmimal braking force (i.e., the positive peak).

## Picking out the landmarks

Because our landmarks are simply the overall maximum and minimum of each
curve, we can pick them out using a simple grid search.

First, we evaluate each curve on a grid of $101$ time points:
$t = 0, 1, \dots, 100$. This results in a $101 \times 109$ matrix with
evaluations of the curves in its columns.

``` r
t_grid <- 0:100
Y_eval <- eval.fd(evalarg = t_grid, fdobj = y_fd)
dim(Y_eval)
```

    ## [1] 101 109

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
inds_obs_plot <- c(1, 10, 100) # indices of three observations to plot
plot(y_fd[inds_obs_plot], xlab = "t", ylab = "force (bw)")
```

    ## [1] "done"

``` r
points(t_min[inds_obs_plot], y_min_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
points(t_max[inds_obs_plot], y_max_value[inds_obs_plot], col = c(1:3), cex = 1.5, pch = 20)
```

<img src="02-registration_files/figure-gfm/plot-landmarks-1.png" style="display: block; margin: auto;" />

## Using the `landmarkreg()` function

The `landmarkreg()` function takes the following main arguments (see
`?landmarkreg` for full detials):

- `fdobj`: This functional data object contains the curves to be
  registered. In our case this will be the object `y_fd`.

- `ximarks`: This matrix contains the landmark timings for each curve.
  It is in the form of an $N \times NL$ matrix where $NL$ represents the
  number of landmarks. In our case we have $N=109$ curves and $NL=2$
  landmarks (the minimum and maximum), so we set up a $109 \times 2$
  matrix and put the vectors of landmark timings `t_min` and `t_max` in
  its columns.

``` r
ximarks_mat <- matrix(data = NA, nrow = 109, ncol = 2) # set up empty matrix
ximarks_mat[, 1] <- t_min
ximarks_mat[, 2] <- t_max
```

- `Wfdpar`: a functional parameter object defining the warping functions

## Examining the registered curves

## Analysis of phase variation

All of the information in the warping functions is encoded in our two
landmarks, so we can examine their relationship between them and other
variables in our data (e.g., sex).

**Note:** When we use more sophisticated continuous registration
techniques, we will need to examine the warping functions directly to
visualise phase variation.

``` r
par(mfrow = c(1, 2))
boxplot(t_min ~ data$SEX,
        col = c("red4", "cornflowerblue"),
        xlab = "sex", 
        ylab = "landmark time: min. force")
boxplot(t_max ~ data$SEX,
        col = c("red4", "cornflowerblue"),
        xlab = "sex", 
        ylab = "landmark time: max. force")
```

<img src="02-registration_files/figure-gfm/boxplot-sex-1.png" style="display: block; margin: auto;" />

## A Word of Caution

When using registered functions and warping functions in subsequent
analysis it is important to remember that results will be dependent on
the registration. That is, subjective choices have been made regarding
the type of registration applied (e.g., landmark vs. continuous) and its
implementation (e.g., the basis used to represent that warping
functions). Ideally, this subjectivity could be acknowledged and checked
through a sensitivity analysis.