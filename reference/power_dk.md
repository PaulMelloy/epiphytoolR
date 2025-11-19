# Power law dispersal kernal

Dispersal kernal using the power law, as described by Sackett and Mundt
(2005)

## Usage

``` r
power_dk(x, a = 184.9, b = 2.07)
```

## Arguments

- x:

  numeric, Distance in meters.

- a:

  numeric, scale parameter which is proportional to the strength of the
  source inoculum. Defaults to parameter used for stripe rust (*Pucinnia
  striiformis*) dispersal by Sackett and Mundt (2005).

- b:

  numeric, dimensionless parameter controlling the steepness of the
  gradient. Defaults to parameter used for stripe rust (*Pucinnia
  striiformis*) dispersal by Sackett and Mundt (2005).

## Value

estimated lesions per leaf

## References

https://apsjournals.apsnet.org/doi/pdf/10.1094/PHYTO-95-0983

## Examples

``` r
power_dk(5)
#> [1] 6.607984
power_dk(1:20)
#>  [1] 184.9000000  44.0356915  19.0237405  10.4875182   6.6079843   4.5306845
#>  [7]   3.2929411   2.4977021   1.9572888   1.5737542   1.2919748   1.0790256
#> [13]   0.9142694   0.7842452   0.6798733   0.5948515   0.5246959   0.4661469
#> [19]   0.4167897   0.3748045
```
