#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  header <- bs4Dash::bs4DashNavbar(
    title = bs4Dash::dashboardBrand(
      "Vaccine Knowledge",
      image = "https://www.strategyunitwm.nhs.uk/themes/custom/ie_bootstrap/logo.svg"
    )
  )

  sidebar <- bs4Dash::bs4DashSidebar(
    skin = "light",
    textInput("search", "Search"),
    selectizeInput(
      "dates",
      "Date of Publication",
      choices = NULL,
      multiple = TRUE
    ),
    selectizeInput(
      "jcvi_cohort",
      "JCVI Cohort",
      choices = c(
        "residents in a care home for older adults and their carers" = "1",
        "all those 80 years of age and over and frontline health and social care workers" = "2",
        "all those 75 years of age and over" = "3",
        "all those 70 years of age and over and clinically extremely vulnerable individuals" = "4",
        "all those 65 years of age and over" = "5",
        paste("all individuals aged 16 years to 64 years with underlying health conditions which put them at higher",
              "risk of serious disease and mortality") = "6",
        "all those 60 years of age and over" = "7",
        "all those 55 years of age and over" = "8",
        "all those 50 years of age and over" = "9",
        "all those aged 40 to 49 years" = "10",
        "all those aged 30 to 39 years" = "11",
        "all those aged 18 to 29 years" = "12"
      ),
      multiple = TRUE
    ),
    selectizeInput(
      "methods_used",
      "Evidence Type",
      choices = NULL,
      multiple = TRUE
    ),
    selectizeInput(
      "level_evidence",
      "Level of Evidence",
      choices = 1:3,
      multiple = TRUE
    )
  )

  body <- bs4Dash::bs4DashBody(
    mod_knowledge_items_ui("evidence")
  )

  tagList(
    golem_add_external_resources(),
    #tags$link(rel = "stylesheet", type = "text/css", href = "www/skin-su.css"),
    bs4Dash::bs4DashPage(
      header,
      sidebar,
      body,
      freshTheme = su_fresh_theme
    )
  )
}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'CovidVaccineKnowledgeHub'
    )
  )
}
