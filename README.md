Functional Data Analysis in Sports Biomechanics
================

<img src="logo/isbs-logo.png" width="150" />
<img src="logo/fda-logo.png" width="150" />

------------------------------------------------------------------------

# Welcome

This is the web page for the [ISBS 2024](https://www.isbs2024.com)
pre-conference workshop [***“Functional Data Analysis in Sports
Biomechanics”***](https://www.isbs2024.com/wp-content/uploads/2024/03/Pre-workshop_FDA.pdf),
delivered by [Prof. Drew Harrison (University of
Limerick)](https://www.ul.ie/shprc/professor-drew-harrison) and
[Dr. Edward Gunning (University of
Pennsylvania)](https://edwardgunning.github.io/).

------------------------------------------------------------------------

# 🖥 Computing Pre-requisites

## R and RStudio

You should bring your own laptop with the following software installed:

- **The R Language for Statistical Computing**
  - It can be downloaded from <https://cloud.r-project.org>
  - For further assistance see [this video by RStudio
    education](https://vimeo.com/203516510)
- **The RStudio Integrated Development Environment (IDE)**
  - It can be downloaded from <https://posit.co/>
  - For further assistance see [this video by RStudio
    education](https://vimeo.com/203516510) (**Note**: The RStudio
    company has changed to Posit PBC, so there may be some minor
    differences)

**Note**: If you are unable to install R and RStudio, you can work with
a free, lite web version of RStudio called [*posit
cloud*](https://posit.cloud/). Watch [this video from Posit
PBC](https://www.youtube.com/watch?v=-fzwm4ZhVQQ) to set up an account
and get started.

## R Packages

For this workshop, we will primarily use the `fda` (Ramsay, Graves and
Hooker, 2021) and `refund` (Goldsmith et al., 2022) packages.

To install these, you should run the following commands:

``` r
install.packages("fda") # install the fda package
install.packages("refund") # install the refund package
```

------------------------------------------------------------------------

# 📒 Material

- [**Lecture slides**](slides/template-slides.pptx)

- **Practical Material**:

  - [Part 1 – Data representation and
    smoothing](practicals/01-smoothing.md)
  - [Part 2 – Registration](practicals/02-registration.md)
  - [Part 3 – Functional Principal Components Analysis
    (FPCA)](practicals/03-fpca.md)
  - [Part 4 – Functional
    regression](practicals/04-functional-regression.md)

------------------------------------------------------------------------

# 📧 Contact

- Queries about registration for the course should be sent to the ISBS
  2024 organisers.

- Queries about the course material should be sent to
  <edward.gunning@pennmedicine.upenn.edu> with the subject line *“ISBS
  pre-conference workshop material”*.

------------------------------------------------------------------------

# 📚 References

- J. O. Ramsay, Spencer Graves and Giles Hooker (2021). fda: Functional
  Data Analysis. R package version 5.5.1.
  <https://CRAN.R-project.org/package=fda>

- Jeff Goldsmith, Fabian Scheipl, Lei Huang, Julia Wrobel, Chongzhi Di,
  Jonathan Gellar, Jaroslaw Harezlak, Mathew W. McLean, Bruce Swihart,
  Luo Xiao, Ciprian Crainiceanu and Philip T. Reiss (2022). refund:
  Regression with Functional Data. R package version 0.1-26.
  <https://CRAN.R-project.org/package=refund>

------------------------------------------------------------------------

# 📖 Further Reading

- Crainiceanu, C. M., Goldsmith, J., Leroux, A., & Cui, E. (2024).
  Functional Data Analysis with R (1st edition). Chapman and Hall/CRC
  (book website: <https://functionaldataanalysis.org>)

- Ramsay, J. O., & Silverman, B. W. (2005). Functional Data Analysis
  (2nd ed.). Springer-Verlag. <https://doi.org/10.1007/b98888>

- Ramsay, J. O., Hooker, G., & Graves, S. (2009). Functional Data
  Analysis with R and MATLAB. Springer-Verlag.
  <https://doi.org/10.1007/978-0-387-98185-7>
