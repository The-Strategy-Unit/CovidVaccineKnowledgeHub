#' theme
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
su_fresh_theme <- fresh::create_theme(
  fresh::bs4dash_status(
    light = "#f9bf07",
    dark  = "#2c2825"
  ),
  fresh::bs4dash_vars(
    navbar_light_color = "#f9bf07",
    navbar_light_active_color = "#2c2825",
    navbar_light_hover_color = "#2c2825"
  )
)
