#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    dashboardPage(
      dashboardHeader(title = "Covid Evidence Knowledge Hub"),
      dashboardSidebar(
        selectizeInput(
          "tags",
          "Tags",
          choices = c("Capability", "Opportunity", "Motivation"),
          multiple = TRUE
        ),
        textInput("search", "Search"),
        sliderInput(
          "dates",
          "Dates",
          as.Date("2020-01-01"),
          as.Date("2021-12-01"),
          c(as.Date("2020-01-01"), as.Date("2021-12-01"))
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
          choices = NULL,
          multiple = TRUE
        ),
        selectizeInput(
          "jcvi_report",
          "JCVI Report",
          choices = NULL,
          multiple = TRUE
        )
      ),
      dashboardBody(
        tableOutput("evidence")
      )
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
