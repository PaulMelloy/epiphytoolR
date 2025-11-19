# Exponential dispersal kernel

Exponential dispersal kernel function as described by Karisto et al.
(2022)

## Usage

``` r
exp_dk(r, a = 1)
```

## Arguments

- r:

  Distance from the source to the destination

- a:

  Scale parameter

## Value

a numeric value indicating the

## References

Petteri Karisto, Frédéric Suffert and Alexey Mikaberidze. (2022).
Measuring Splash Dispersal of a Major Wheat Pathogen in the Field.
*PhytoFrontiers™* **2**, 30-40.

## Examples

``` r
exp_dk(r = 0:10)
#>  [1] 1.591549e-01 5.854983e-02 2.153928e-02 7.923858e-03 2.915024e-03
#>  [6] 1.072378e-03 3.945057e-04 1.451305e-04 5.339054e-05 1.964128e-05
#> [11] 7.225623e-06
exp_dk(r = 0:10, a = 5)
#>  [1] 0.0063661977 0.0052122019 0.0042673900 0.0034938434 0.0028605170
#>  [6] 0.0023419933 0.0019174619 0.0015698850 0.0012853132 0.0010523254
#> [11] 0.0008615712
```
