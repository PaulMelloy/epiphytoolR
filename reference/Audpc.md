# Calculate area under the disease progress curve (AUPDC)

Calculate area under the disease progress curve (AUPDC)

## Usage

``` r
Audpc(evaluation, dates, type = "absolute", na.rm = FALSE)
```

## Arguments

- evaluation:

  Table of data of the evaluations: Data frame with evaluations as
  columns; or a vector of evaluations

- dates:

  Vector of dates corresponding to each evaluation

- type:

  "relative" or "absolute", relative returns a proportion, whereas
  absolute returns the area.

- na.rm:

  logical, remove observations with either an `NA` in the evaluation or
  the date. Does not allow `NA` values at the start or end observations.

## Value

Vector with relative or absolute area under the disease progress curve

## Details

This is a wrapper for
[agricolae](https://CRAN.R-project.org/package=agricolae) which checks
for NA values and will return omit NA values if specified. However it
will still return NA if the first or last values contain `NA` This is
intentional as audpc values are completely not comparable when these
values are missing. See help
[`audpc`](https://rdrr.io/pkg/agricolae/man/audpc.html) for more
details.

## Examples

``` r
# see examples in help(agricolae::audpc)
dates <- c(14,21,28,32,39,41,50) # days
# example 1: evaluation - vector
evaluation <- c(1,2,4,15,40,80,90)
Audpc(evaluation,dates)
#> evaluation 
#>       1147 

# add NA values
evaluation<-c(1,2,4,NA,40,80,90)
Audpc(evaluation,dates, na.rm = TRUE)
#> [1] 1158.5
if (FALSE) agricolae::audpc(evaluation,dates) # \dontrun{}
# if NA is at the start or end of vector it will return NA
dates<-c(14,21,28,32,39,41,NA) # days
Audpc(evaluation,dates)
#> [1] NA
```
