#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  header <- bs4Dash::dashboardHeader(
    title = "Covid Evidence Knowledge Hub"
  )

  header$children[[3]]$children[[3]]$children[[1]] <- tags$img(
    src = "https://www.strategyunitwm.nhs.uk/themes/custom/ie_bootstrap/logo.svg",
    title = "The Strategy Unit",
    alt = "The Strategy Unit Logo",
    align = "right",
    height = "40"
  )

  sidebar <- bs4Dash::dashboardSidebar(
    selectizeInput(
      "tags",
      "Tags",
      choices = c("Capability", "Opportunity", "Motivation"),
      multiple = TRUE
    ),
    textInput("search", "Search"),
    selectizeInput(
      "dates",
      "Dates",
      choices = NULL,
      multiple = TRUE
    ),
    checkboxGroupInput(
      "level_evidence",
      "Level of Evidence",
      1:3
    ),
    selectizeInput(
      "main_theme",
      "Main Theme",
      choices = NULL,
      multiple = TRUE
    ),
    selectizeInput(
      "clinic_model",
      "Clinic Model",
      choices = NULL,
      multiple = TRUE
    ),
    selectizeInput(
      "methods_used",
      "Methods Used",
      choices = NULL,
      multiple = TRUE
    ),
    selectizeInput(
      "progress_plus",
      "PROGRESS-Plus",
      choices = c(
        "1. Place of residence",
        "2. Race, ethnicity, culture, language",
        "3. Occupation",
        "4. Gender/Sex",
        "5. Religion",
        "6. Education",
        "7. Socioeconomic status (SES)",
        "8. Social Capital",
        "9. Age",
        "10. Disability"
      ),
      multiple = TRUE
    ),
    selectizeInput(
      "jcvi_report",
      "JCVI Report",
      choices = as.character(1:12),
      multiple = TRUE
    )
  )

  body <- bs4Dash::dashboardBody(
    mod_knowledge_items_ui("evidence")
  )

  tagList(
    golem_add_external_resources(),
    #tags$link(rel = "stylesheet", type = "text/css", href = "www/skin-su.css"),
    bs4Dash::dashboardPage(
      header,
      sidebar,
      body
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
