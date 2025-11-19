# Calculate Saturated Vapour-Pressure (SVP)

This formula uses the same formula described by the Bureau of
Meteorology (BOM) and the American Meteorological Society. Other
formulas described by described by Murray (1967) or Tetens (1930) to
calculate saturated vapour pressure from temperature in degrees and
Celsius and relative humidity can also be called.

## Usage

``` r
calc_svp(Tm, eq = "BOM")
```

## Arguments

- Tm:

  numeric, Temperature in degrees Celsius

- eq:

  character, Type of equation to use while calculation VPD. defaults to
  the "BOM" (Bureau of Meteorology equation, Australia). Other options,
  "Murray" and "Sapak".

## Value

Saturated vapour-pressure in kPa, class
[units](https://CRAN.R-project.org/package=units)

## References

Murray, F. W., 1967: On the Computation of Saturation Vapor Pressure.
*J. Appl. Meteor. Climatol.*, *6*, 203–204,
https://doi.org/10.1175/1520-0450(1967)006\<0203:OTCOSV\>2.0.CO;2

## Examples

``` r
calc_svp(Tm = 30)
#> 4.242794 [kPa]
calc_svp(Tm = 30, eq = "Murray")
#> 4.241806 [kPa]
```
