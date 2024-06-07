Part 1: Data Representation and Smoothing
================

<center>

![](../logo/isbs-logo.png) ![](../logo/whitespace.png)
![](../logo/fda-logo.png)

</center>

# Load Packages

``` r
library(fda) # load the fda package
```

# Structure of the `fda` package

The `fda` package represents functional observations (i.e., *curves*)
using a *basis function expansion*. That is, each functional observation
$x_i(t), \ i = 1, \dots, N$ is represented as a linear combination (or
weighted sum) of known basis functions $\{\phi_k(t)\}_{k=1}^k$ as:

$$x_i (t)=\sum_{k=1}^{K} c_{ik} \phi_k(t).$$

This means that our representation of a functional dataset
$x_1(t), \dots, x_N(t)$ should comprise two component parts:

1.  The set of known **basis functions** $\{ \phi_K(t) \}_{k=1}^K$.
    These are *common to all curves*. They are defined in the `fda`
    package as a `basis.fd()` objects.

2.  The basis coefficients $c_{ik}$.

# Producing smooth functions from noisy observations

# Constructing a `fd` object manually

# Summarising `fd` objects

# References

- Ramsay, J. O., Hooker, G., & Graves, S. (2009). Functional Data
  Analysis with R and MATLAB. Springer-Verlag.
  <https://doi.org/10.1007/978-0-387-98185-7>