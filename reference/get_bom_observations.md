# Download state weather observations

Function downloads a compressed file to a designated location. The
downloaded file contains three file formats for all automated weather
station, xml, axf, and json. An FTP URL is needed for this function,
find this on the Bureau of Meteorology (BOM) website. Please read the
copyright and disclaimer for use of the data while you are there.

## Usage

``` r
get_bom_observations(
  ftp_url,
  download_location,
  access_warning = TRUE,
  state = "QLD",
  file_prefix = format(Sys.time(), format = "%y%m%d_%H%M")
)
```

## Source

http://reg.bom.gov.au/catalogue/data-feeds.shtml#obs-state ;
http://www.bom.gov.au/other/copyright.shtml;
http://reg.bom.gov.au/other/disclaimer.shtml

## Arguments

- ftp_url:

  character, ftp URL obtained from the BOMs website

- download_location:

  character, Folder location of where to download the compressed data

- access_warning:

  logical, default = `TRUE`. Elects whether to print the warning when
  the function is run

- state:

  character, Australian state for which weather observations files will
  be downloaded. Options include `"QLD"`,`"NSW"`,`"NT"`,`"VIC"`,`"SA"`,
  `"TAS"`,`"WA"`

- file_prefix:

  character, prefix applied to file name. Default is the date and time
  in hours and minutes.

## Value

character string of the download file location of the downloaded
compressed file `.tgz`

## Examples
