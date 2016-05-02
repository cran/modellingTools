---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



## modellingTools: Common Tools for Data Preparation and Modelling

Programming in `R` is delightful. Data analysis in `R` can be a bit challenging
at times. `modellingTools` was created to provide a formal outlet for useful
personal tools I have developed in order to make data preparation and analysis
simpler using `R`. I found that too often, when attempting to get to know my
dataset using `R`, I fell in to the following pattern:

- Try to use the basic functions available, like `table` for frequency
  distributions
- Be unsatisfied with the usage/output, and spend 10 minutes attempting to
  modify it
- Give up and lose interest

After a year or so of this, I started getting smart about it: every time I
modified a base function in some useful way, I would save it in a function. But
soon, I found myself following a new pattern:

- Create a useful new function, e.g. for getting a list of input variables and
  their correlations with a response
- Create a file called "great_new_functions.R" or "useful_helpers.R" or
  something
- Come back in a week to similar problem, not remember where I saved the file,
  and start over, wasting time and recreating the function, usually with
  slightly different features
- Come back in *another* week, and forget which version had which features,
  so I would create a third...
  
Finally I bought Hadley Wickham's
[book](http://r-pkgs.had.co.nz/), and figured now's as good as ever to
learn how to build a package. This solves my above problems because:

- **Unit Tests**! My favourite thing. This package is tested extensively, so I am
  confident the code will work- and if not, please let me know and I will create
  more tests
- **Documentation**: now I have written down exactly what every function does and
  what parameters they take
- **Version Control**: I now only have one version of everything

A fourth benefit is: you get to use the package too! Thank you for doing so, and
please let me know via email
([alex@alexstringer.ca](mailto:alex@alexstringer.ca)) if you have any bugs for
me to fix, or suggestions for new features.

## Example: Frequency distribution of a variable
Getting the frequency distribution of a variable in base `R` is actually
surprisingly unpleasant. The `table` function requires vectors as input:

```r
data(CO2)
table(CO2$conc)
#> 
#>   95  175  250  350  500  675 1000 
#>   12   12   12   12   12   12   12
```
As you can see, the output also isn't that pretty. You can clean up the code
using `with`,

```r
with(CO2,table(conc))
#> conc
#>   95  175  250  350  500  675 1000 
#>   12   12   12   12   12   12   12
```
or if you're really cutting-edge, with the `%$%` operator from the `magrittr`
package:

```r
# install.packages("magrittr")
library(magrittr)
CO2 %$% table(conc)
#> conc
#>   95  175  250  350  500  675 1000 
#>   12   12   12   12   12   12   12
```
**All this for a basic frequency distribution**. And don't even think about
doing it for a continuous variable:

```r
CO2 %$% table(uptake)
#> uptake
#>  7.7  9.3 10.5 10.6 11.3 11.4   12 12.3 12.5   13 13.6 13.7 14.2 14.4 14.9 
#>    1    1    1    2    1    1    1    1    1    1    1    1    1    1    1 
#> 15.1   16 16.2 17.9   18 18.1 18.9 19.2 19.4 19.5 19.9   21 21.9   22 22.2 
#>    1    1    1    3    1    1    2    1    1    1    1    1    1    1    1 
#> 24.1 25.8 26.2 27.3 27.8 27.9 28.1 28.5   30 30.3 30.4 30.6 30.9 31.1 31.5 
#>    1    1    1    2    1    1    1    1    1    1    1    1    1    1    1 
#> 31.8 32.4 32.5   34 34.6 34.8   35 35.3 35.4 35.5 37.1 37.2 37.5 38.1 38.6 
#>    1    3    1    1    1    1    1    1    1    1    1    1    1    1    1 
#> 38.7 38.8 38.9 39.2 39.6 39.7 40.3 40.6 41.4 41.8 42.1 42.4 42.9 43.9 44.3 
#>    1    1    1    1    1    1    1    1    2    1    1    1    1    1    1 
#> 45.5 
#>    1
```
Talk about hard to read, and that's only 84 observations!

Try `proc_freq`, from the `modellingTools` package. Advantages:

- Simple to use; 3 arguments
- Data all comes from the same dataframe
- Output is a `tbl_df`, which is great for viewing- and can be used with the
  `View()` function to view in a neat spreadsheet right in `RStudio`
- **Automatic Discretization of Continuous Variables**: this is *amazing* for
  dealing with datasets with a large number of observations
- Missing values are always included in the output, because it is *always*
  important to know about missing values
  
We can do

```r
proc_freq(CO2,"conc")
#> Source: local data frame [7 x 3]
#> 
#>   level count percent
#>   (dbl) (int)   (chr)
#> 1    95    12   14.3%
#> 2   175    12   14.3%
#> 3   250    12   14.3%
#> 4   350    12   14.3%
#> 5   500    12   14.3%
#> 6   675    12   14.3%
#> 7  1000    12   14.3%
```
as well as

```r
proc_freq(CO2,"uptake")
#> Source: local data frame [76 x 3]
#> 
#>    level count percent
#>    (dbl) (int)   (chr)
#> 1    7.7     1   1.19%
#> 2    9.3     1   1.19%
#> 3   10.5     1   1.19%
#> 4   10.6     2   2.38%
#> 5   11.3     1   1.19%
#> 6   11.4     1   1.19%
#> 7   12.0     1   1.19%
#> 8   12.3     1   1.19%
#> 9   12.5     1   1.19%
#> 10  13.0     1   1.19%
#> ..   ...   ...     ...
```
The real value comes from

```r
proc_freq(CO2,"uptake",bins = 4)
#> Source: local data frame [4 x 3]
#> 
#>         level count percent
#>        (fctr) (int)   (chr)
#> 1  [7.7,17.1]    19  22.62%
#> 2 (17.1,26.6]    18  21.43%
#> 3   (26.6,36]    25  29.76%
#> 4   (36,45.5]    22  26.19%
```

## Installation Instructions

You can get the package, once it is on `CRAN`, by typing
```r
install.packages("modellingTools")
```
Since I'm actively developing the package, it may just be better to use the
development version:
```r
install.packages("devtools")
devtools::install_github("awstringer/modellingTools")
```
After that, attach the package
```r
library(modellingTools)
```
and you're good to go!

## Overview
For a detailed overview and introduction to using the package and what it does,
see the [vignette](https://github.com/awstringer/modellingTools/tree/master/vignettes/modellingTools.Rmd).
Check out the [github page](https://github.com/awstringer/modellingTools) for
all the code as well.

