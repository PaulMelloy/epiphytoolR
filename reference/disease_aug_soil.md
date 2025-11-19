# DiseaseAUGSoil - number of girdled internodes

Estimates the number of girdled field pea internodes at the end of
winter from the sum quantitative PCR blackspot pathogens, *Didymella
pinodes*, *Phoma medicaginis* var. *pinodella* and P. *koolunga*.
Formula described in paper linked in the DOI below

## Usage

``` r
disease_aug_soil(DNA_pg)
```

## Source

<https://doi.org/10.1094/PDIS-01-11-0077>

## Arguments

- DNA_pg:

  Quantity of DNA in picograms per gram of soil of *D. pinodes*, *P.
  medicaginis* var *pinodella* and *P. koolunga*.

## Value

estimated number of girdled field pea internodes at the end of winter.

## See also

formula one <https://doi.org/10.1111/ppa.12044>

## Examples

``` r
disease_aug_soil(50)
#> Warning: This formula is directly transcribed from literature however not reproduceable
#> [1] 0.5119353
```
