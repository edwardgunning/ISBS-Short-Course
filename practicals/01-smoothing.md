Part 1: Data Representation and Smoothing
================

- [1 Load Packages](#1-load-packages)
- [2 The `fd` Class](#2-the-fd-class)
- [3 Producing Smooth Functions from Noisy
  Observations](#3-producing-smooth-functions-from-noisy-observations)
- [4 **Extra**: Working with `fd`
  Objects](#4-extra-working-with-fd-objects)
- [5 References](#5-references)

<center>

![](../logo/ISBS-Logo-2024.png) ![](../logo/whitespace.png)
![](../logo/fda-logo.png)

</center>

# 1 Load Packages

``` r
library(fda) # load the fda package
```

------------------------------------------------------------------------

------------------------------------------------------------------------

# 2 The `fd` Class

The `fda` package represents functional observations (i.e., *curves*)
using a **basis function expansion**. That is, each functional
observation $x_i(t), \ i = 1, \dots, N$ is represented as a linear
combination (or weighted sum) of known basis functions
$\\{\phi_k(t)\\}_{k=1}^K$ as:

$$x_i (t)=\sum_{k=1}^{K} c_{ik} \phi_k(t).$$

This means that our representation of a functional dataset
$x_1(t), \dots, x_N(t)$ should comprise two component parts:

1.  The set of known **basis functions** $\\{ \phi_k(t) \\}_{k=1}^K$.
    These are *common to all curves*. They are defined in the `fda`
    package as a `basisfd` class.

2.  The **basis coefficients** $c_{ik}$. We need $K$ basis coefficients
    (i.e., 1 coefficient per basis function) to define each individual
    functional observation. Therefore, for the full dataset of $N$
    observations we have an $K \times N$ matrix of basis coefficients.

**Examples:**

<details>
<summary>

<b>Construct a cubic B-spline basis with 20 basis functions</b>

</summary>

``` r
bspl_20 <- create.bspline.basis(rangeval = c(0, 100), # range of t values
                                nbasis = 20, # number of basis functions
                                norder = 4) # order of the piecewise polynomial (4 = cubic)

# show it is a `basisfd` object
class(bspl_20)
```

    ## [1] "basisfd"

``` r
# or 
is.basis(bspl_20)
```

    ## [1] TRUE

``` r
# plot our basis
plot(bspl_20)
```

<img src="01-smoothing_files/figure-gfm/create-bspline-1.png" style="display: block; margin: auto;" />

</details>
<details>
<summary>

<b>Construct a Fourier basis with 15 basis functions</b>

</summary>

``` r
fourier_15 <- create.fourier.basis(rangeval = c(0, 100), # range of t values
                                nbasis = 15) # number of basis functions

# plot our basis
plot(fourier_15)
```

<img src="01-smoothing_files/figure-gfm/create-fourier-1.png" style="display: block; margin: auto;" />

</details>

------------------------------------------------------------------------

In the `fda` package, we combine these two component parts to produce a
`fd` (“functional data”) object. If we know the basis function system
and the matrix of basis coefficients, the code to set up the `fd` object
is very simple. We will walk through a short example.

Let’s first set up a basis of $20$ cubic B-spline basis functions on
$[0,100]$.

``` r
bspl_20 <- create.bspline.basis(rangeval = c(0, 100), nbasis = 20, norder = 4)
plot(bspl_20)
title("Our B-spline basis")
```

<img src="01-smoothing_files/figure-gfm/unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

Now, let’s imagine we have $N=10$ functional observations. We require a
$20\times10$ matrix of basis coefficients. In practice we would
calculate or know these. However, for the purposes of this demonstration
we will just simulate them randomly on our computer.

``` r
set.seed(1996) # so random draws are the same
C <- matrix(rnorm(20*10), nrow = 20, ncol = 10) # 20x10 matrix of random values
```

Now that we have our basis object and our matrix of basis coefficients,
we can set up our `fd` object using the `fd()` function.

``` r
toy_fd <- fd(coef = C, basisobj = bspl_20)
```

Let’s inspect our first `fd` object.

``` r
class(toy_fd) # (or can do is.fd(toy_fd))
```

    ## [1] "fd"

``` r
plot(toy_fd, xlab = "t", ylab = "x(t)")
```

    ## [1] "done"

``` r
title("Our first fd object")
```

<img src="01-smoothing_files/figure-gfm/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

**Note**: For more information on building `fd` objects, see Ramsay,
Hooker and Graves (2009, pp. 29-31).

------------------------------------------------------------------------

------------------------------------------------------------------------

# 3 Producing Smooth Functions from Noisy Observations

In most cases we don’t know the basis coefficients. Instead, we have to
estimate them from noisy sampled measurements of each curve.

For this practical, we’ll assume that we measure each functional
observation on a common grid $T$ points $t_1, \dots, t_T$, and these
measurements are contaminated with some measurement error (or “noise”):
$$y_{ij} = x(t_j) + \epsilon_{ij}.$$

------------------------------------------------------------------------

When creating our `fd` object, we want to recover the underlying
functions $x_1(t), \dots, x_N (t)$ as accurately as possible without
capturing the noise.

We can do this using a basis expansion, choosing a system of basis
functions $\{\phi_k(t)\}$, and then estimating the basis coefficients
according to some criteria.

The most straightforward way to do this is by **Ordinary Least Squares
(OLS)**, where for each curve we choose $c_{i1}, \dots, c_{iK}$ to
minimise the sum of squared errors (SSE):
$$SSE = \sum_{j=1}^T \left(y_{ij} - \sum_{k=1}^K c_{ik} \phi_k(t_j)\right)^2.$$

To compute the basis coefficients by OLS we can use the `smooth.basis()`
function, which takes the following three arguments:

- `argvals`: This is our grid of points $t_1, \dots, t_T$.

- `Y`: This is our $T \times N$ matrix containing the discrete noisy
  measurements of the $N$ curves at the $T$ sampling points.

- `fdParobj`: For OLS, we just supply the `basisobj` we are using to
  represent the curves.

``` r
ols_fdSmooth <- smooth.basis(argvals = t_grid, y = Y_mat, fdParobj = bspl_35)
```

The `smooth.basis()` function returns an `fdSmooth` object. The most
important part of this object is the `fd` element – this is an `fd`
object comprising the basis we have supplied and the coefficients we
have estimated, so it represents our dataset of smoothed curves.

``` r
ols_fd <- ols_fdSmooth$fd # or ols_fdSmooth[["fd]]
plot(ols_fd[1:3,], xlab = "t", ylab = "x(t)")
matpoints(x = t_grid, y = Y_mat[, 1:3], pch = 20) # overl
```

With the OLS, the smoothness of the fitted curve is controlled by the
number of basis functions $K$.

``` r
# add loop with K
```

A more flexible approach is to choose a risch basis (i.e., a large value
of $K$) and add a penalty to the SSE criterion that penalises the
roughness of the fitted function
$$PENSSE =  \underbrace{\sum_{j=1}^T \left(y_{ij} - \sum_{k=1}^K c_{ik} \phi_k(t_j)\right)^2}_{SSE} + \lambda \text{PEN}(x(t)).$$
This approach is called **Penalised Ordinary Least Squares (P-OLS)**.
The roughness penalty we will use is on the integrated squared second
derivative of $x(t)$:
$$PEN(x(t)) = \int \left( \frac{\mathrm{d}^2 x(t)}{\mathrm{d}t^2} \right)^2 \mathrm{d}t$$
Applying P-OLS with `smooth.basis()` is very similar to OLS, but we pass
a general `fdPar` object (rather than just our `basisfd` object) to
`fdParobj` argument, to encode information about the basis, the penalty
and the smoothing parameter $\lambda$. We create this object using the
`fdPar()` function, passing the following arguments:

- `fdobj`: here we just supply our basis.

- `Lfdobj`: Here we specify the penalty – `int2Lfd(m = m)` specifies a
  penalty on the integrated squared $m$th derivative of our fitted
  curve, so we set $m=2$ for the second derivative penalty.

- `lambda` specifies the value of the smoothing parameter $\lambda$.

``` r
fdParobj_pols <-fdPar(fdobj = bspl_20, Lfdobj = int2Lfd(m = 2), lambda = 1)
```

We then pass the `fdPar` object that we have created to the `fdParobj`
argument in `smooth.basis()` to perform P-OLS smoothing.

``` r
pls_fdSmooth <- smooth.basis(argvals = t_grid, y = Y_mat, fdParobj = fdParobj_pols)
```

Let’s view the effect on the fit of a single curve when we vary
$\lambda$:

``` r
# create grid of values for lambda varying on a log10 scale
log10_lambda_range <- seq(-10, 10, by = 1)
lambda_range <- 10^log10_lambda_range
n_lambda <- length(lambda_range) # how many values we're trialling

plot(x = t_grid, y = Y[, 1], pch = 20) # plot underlying data (first curve)
for(lam in seq_len(n_lambda)) {
  # loop through different lambdas
  fdParobj_lam <- fdPar(fdobj = bspl_20, 
                        Lfdobj = int2Lfd(m = 2),
                        lambda = lambda_range[lam]) # create fdPar with chosen lambda
  # do p-ols with chosen lambda:
  pls_fdSmooth_lam <- smooth.basis(argvals = t_grid, y = Y_mat, fdParobj = fdParobj_lam)
  # extract fd object:
  pls_fd_lam <- pls_fdSmooth_lam$fd
  # overlay line of current fit
  lines.fd(pls_fd_lam[1, ], col = lam)
}
```

For choosing an optimal value of $\lambda$, we typically minimise some
measure of fit to the data that is discounted for the complexity of the
model. A common measure is the Generalised Cross Validation (GCV)
criterion (Craven and Wahba, 1979). It is returned automatically as part
of the `fdSmooth` object returned by `smooth.basis()`. In the following,
we loop through a range of values for $\lambda$ to find the one that
provides the minimum GCV value:

``` r
# create vcector to store the GCV values:
gcv_vec <- vector(mode = "numeric", length = n_lambda)

for(lam in seq_len(n_lambda)) {
  # loop through different lambdas
  fdParobj_lam <- fdPar(fdobj = bspl_20, 
                        Lfdobj = int2Lfd(m = 2),
                        lambda = lambda_range[lam]) # create fdPar with chosen lambda
  # do p-ols with chosen lambda:
  pls_fdSmooth_lam <- smooth.basis(argvals = t_grid, y = Y_mat, fdParobj = fdParobj_lam)
  # store resulting GCV:
  gcv_vec[lam] <- pls_fdSmooth_lam$gcv
}

plot(log10_lambda_range, 
     y = gcv_vec, 
     type = "b", 
     xlab = expression(log[10](lambda)), 
     ylab = "GCV")
best_lambda_index <- which.min(gcv_vec)
abline(v = log10_lambda_range[best_lambda_index])
```

**Some points to try or discuss in the Q&A:**

- How you would code ordinary cross-validation (leave-one-out and
  $k$-fold)?

- How would you examine regression assumptions using what is returned by
  `smooth.basis()`?

- How would you deal with curves measured at different time points?

# 4 **Extra**: Working with `fd` Objects

Given the `fd()` object, the following are among the many operations we
can use to summarise and explore the functional dataset.

## 4.1 Evaluation

To evaluate the functions on a grid of points we use the `eval.fd()`
function. This returns a $T^* \times N$ matrix, where $T^*$ is the
number of grid points.

``` r
# define coarse grid
t_grid_coarse <- seq(0, 100, lentgth.out = 10)
# evaluate on that grid
eval.fd(evalarg = t_grid_coarse, fdobj = final_fd)
```

## 4.2 Mean Function

The sample mean function
$$\bar{x}(t) = \frac{1}{N}\sum_{i=1}^N x_i(t),$$ can be calculated using
the `mean.fd()` function.

``` r
mean_fd <- mean.fd(x = final_fd)
```

However, as the mean functional object is just given by the mean of the
coefficients combined with the same basis, we can do this manually as
follows.

``` r
final_coef <- final_fd$coef # extract coefficients
mean_coef <- apply(final_coef, 1, mean, simplify = FALSE) # average them
mean_fd_02 <- fd(coef = mean_coef, basisobj = final_fd$basis) # create mean fd object manually
```

## 4.3 Covariance

The sample covariance function
$$\text{Cov}(x(s), x(t)) = \frac{1}{N-1}\sum_{i=1}^N (x_i(s)-\bar{x}(s))(x_i(t)-\bar{x}(t)),$$
summarises the dependence among the function values at time $s$ and time
$t$. It is a bivariate function on a two-dimensional (i.e., rectangular)
domain. We can compute it for our sample of functional data using the
`var.fd()` function as follows.

``` r
cov_fd <- var.fd(fdobj1 = final_fd)
```

The result is a `bifd` (“bivariate functional data”) object. We can
evaluate it on a two-dimensional grid as follows.

``` r
cov_eval <- eval.bifd(sevalarg = t_grid, tevalarg =  t_grid, bifd = cov_fd)
```

It can then be visualised using a surface plot, a contour plot or a
filled contour plot. Here, we will create a filled contour plot using
`filled.contour()`.

``` r
filled.contour(x = t_grid, y = t_grid, z = cov_eval)
```

## 4.4 Boxplots

Just as the scalar boxplot provides a simple and intepretable
five-number summary for scalar data, the *functional boxplot* (Sun and
Genton, 2009) is a summary graphic for functional data. We produce it
using the `boxplot.fd()` function as follows.

``` r
boxplot.fd(x = final_fd)
```

## 4.5 Derivatives

------------------------------------------------------------------------

------------------------------------------------------------------------

# 5 References

- Ramsay, J. O., Hooker, G., & Graves, S. (2009). Functional Data
  Analysis with R and MATLAB. Springer-Verlag.
  <https://doi.org/10.1007/978-0-387-98185-7>

- Craven, P., & Wahba, G. (1978). Smoothing noisy data with spline
  functions. Numerische Mathematik, 31(4), 377–403.
  <https://doi.org/10.1007/BF01404567>

- Sun, Y., & Genton, M. G. (2011). Functional Boxplots. Journal of
  Computational and Graphical Statistics, 20(2), 316–334.
  <https://doi.org/10.1198/jcgs.2011.09224>
