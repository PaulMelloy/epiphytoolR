# Calculate Saturated Vapour-Pressure (SVP)

Calculates saturated vapour pressure from air temperature. By default
the equation described by the Bureau of Meteorology (BOM) and the
American Meteorological Society is used. The equations described by
Murray (1967) or Tetens (1930) can also be selected via the `eq`
argument.

## Usage

``` r
calc_svp(Tm, eq = "BOM")
```

## Arguments

- Tm:

  numeric, Temperature in degrees Celsius

- eq:

  character, type of equation to use. Defaults to `"BOM"` (Bureau of
  Meteorology equation, Australia). Other options are `"Murray"`
  (Murray 1967) and `"Tetens"` (Tetens 1930). `"Sapak"` is accepted as a
  deprecated alias of `"Tetens"`.

## Value

Saturated vapour-pressure in kPa, class
[units](https://CRAN.R-project.org/package=units)

## References

Murray, F. W., 1967: On the Computation of Saturation Vapor Pressure.
*J. Appl. Meteor. Climatol.*, *6*, 203–204,
[doi:10.1175/1520-0450(1967)006\<0203:OTCOSV\>2.0.CO;2](https://doi.org/10.1175/1520-0450%281967%29006%3C0203%3AOTCOSV%3E2.0.CO%3B2)

Tetens, O., 1930: Uber einige meteorologische Begriffe. *Zeitschrift fur
Geophysik*, *6*, 297–309.

## Examples

``` r
calc_svp(Tm = 30)
#> 4.242794 [kPa]
calc_svp(Tm = 30, eq = "Murray")
#> 4.241806 [kPa]
calc_svp(Tm = 30, eq = "Tetens")
#> 4.242926 [kPa]
```
