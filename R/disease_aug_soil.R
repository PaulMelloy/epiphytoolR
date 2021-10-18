#' DiseaseAUGSoil - number of girdled internodes
#'
#' Estimates the number of girdleed field pea internodes at the end of winter from
#'  the sum quantitative PCR blackspot pathogens, Didymella pinodes, Phoma medicaginis
#'  var pinodella and P. koolunga. Formula described in paper linked in the DOI
#'  below
#'
#' @param DNA_pg Quantity of DNA in picograms per gram of soil of
#'  D. pinodes, P. medicaginis var pinodella and P. koolunga.
#'
#' @return estimated number of girdled field pea internodes at the end of winter.
#' @source <https://doi.org/10.1094/PDIS-01-11-0077>
#' @seealso formula one <https://doi.org/10.1111/ppa.12044>
#' @export
#'
#' @examples
#' disease_aug_soil(50)
disease_aug_soil <- function(DNA_pg){
   warning("This formula is directly transcribed from literature however not reproduceable")
   (5.0584 * log(DNA_pg + 1) - 6.0153)/
      27.1
}
