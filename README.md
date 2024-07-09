Functional Data Analysis in Sports Biomechanics
================

<center>

![](logo/ISBS-Logo-2024.png) ![](logo/whitespace.png)
![](logo/fda-logo.png)

</center>

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

We also recommend setting up an RStudio project to work and store your
files for this workshop in – see [this helpful guide on setting up
projects by Posit
PBC](https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects).

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

- **Lecture Slides:**
  - [Welcome and introduction](slides/01-welcome.pptx)
  - [Part 1 – Data representation and
    smoothing](slides/02-smoothing.pptx)
  - [Part 2 – Registration](slides/03-registration.pptx)
  - [Part 3 – Functional Principal Components Analysis
    (FPCA)](slides/04-fpca.pptx)
  - [Part 4 – Functional regression](slides/05-fregression.pptx)
- **Practical Material**:
  - [Part 1 – Data representation and
    smoothing](practicals/01-smoothing.md)
  - [Part 2 – Registration](practicals/02-registration.md)
  - [Part 3 – Functional Principal Components Analysis
    (FPCA)](practicals/03-fpca.md)
  - [Part 4 – Functional
    regression](practicals/04-functional-regression.md)

------------------------------------------------------------------------

# ⏱️ Schedule

|              Time | Topic                    | Format                |  Lead   | Material |
|------------------:|:-------------------------|-----------------------|:-------:|:---------|
| $09.00$ - $09.30$ | Welcome and Introduction | Lecture               |   DH    | [](link) |
| $09.30$ - $09.50$ | Coffee Break             |                       |         |          |
| $09.50$ - $12.00$ | Foundations of FDA       | Lecture               | DH & EG | [](link) |
| $12.00$ - $13.00$ | Lunch                    |                       |         |          |
| $13.00$ - $15.00$ | Hands-on FDA with **R**  | Practical (groups)    |   EG    | [](link) |
| $15.15$ - $16.00$ | Q&A with Coffee          | Group Discussion/ Q&A | DH & EG |          |

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

- [CRAN Task View: Functional Data
  Analysis](https://cran.r-project.org/web/views/FunctionalData.html)

------------------------------------------------------------------------

# 💾 Software Information (Reproducibility)

``` r
R.version # version of R
```

    ##                _                           
    ## platform       aarch64-apple-darwin20      
    ## arch           aarch64                     
    ## os             darwin20                    
    ## system         aarch64, darwin20           
    ## status                                     
    ## major          4                           
    ## minor          4.1                         
    ## year           2024                        
    ## month          06                          
    ## day            14                          
    ## svn rev        86737                       
    ## language       R                           
    ## version.string R version 4.4.1 (2024-06-14)
    ## nickname       Race for Your Life

``` r
# package versions:
packageVersion("fda") 
```

    ## [1] '6.1.8'

``` r
packageVersion("refund")
```

    ## [1] '0.1.35'

``` r
sessionInfo() # R session info.
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
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.4.1    fastmap_1.2.0     cli_3.6.3         tools_4.4.1      
    ##  [5] htmltools_0.5.8.1 rstudioapi_0.16.0 yaml_2.3.8        rmarkdown_2.27   
    ##  [9] knitr_1.47        xfun_0.45         digest_0.6.36     mime_0.12        
    ## [13] rlang_1.1.4       evaluate_0.24.0
