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
    bs4Dash::bs4SidebarMenu(
      bs4Dash::bs4SidebarMenuItem(
        "Content",
        startExpanded = TRUE,
        selected = TRUE,
        tabName = "content"
      ),
      bs4Dash::bs4SidebarMenuItem(
        "Heading Details",
        tabName = "heading_details"
      )
    ),
    tags$br(),
    tags$hr(),
    # content filters
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
        "Residents in a care home for older adults and their carers." = "1",
        "All those 80 years of age and over and frontline health and social care workers." = "2",
        "All those 75 years of age and over." = "3",
        "All those 70 years of age and over and clinically extremely vulnerable individuals." = "4",
        "All those 65 years of age and over." = "5",
        "All individuals aged 16 years to 64 years with underlying health conditions which put them at higher risk of serious disease and mortality." = "6",
        "All those 60 years of age and over." = "7",
        "All those 55 years of age and over." = "8",
        "All those 50 years of age and over." = "9",
        "All those aged 40 to 49 years." = "10",
        "All those aged 30 to 39 years." = "11",
        "All those aged 18 to 29 years." = "12"
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

  heading_details <- tagList(
    bs4Dash::bs4Card(
      title = "Date of Publication",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      "Grouped into 3 month periods. Any items published before January 2021 are grouped into Jan to Mar 21."
    ),
    bs4Dash::bs4Card(
      title = "JCVI Cohorts",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "The order in which the population was prioritised to receive a COVID-19 vacicnation, to prevent COVID-19 mortality and protect health and social care staff and systems."
      ),
      tableOutput("hd_jcvi_cohorts")
    ),
    bs4Dash::bs4Card(
      title = "Evidence Type",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "The format of the resource."
      ),
      tableOutput("hd_evidence_types")
    ),
    bs4Dash::bs4Card(
      title = "Level of Evidence",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "Using Nesta's Standards of Evidence (",
        tags$a(
          href = "https://media.nesta.org.uk/documents/standards_of_evidence.pdf",
          "media.nesta.org.uk/documents/standards_of_evidence.pdf"
        ),
        ")"
      ),
      tableOutput("hd_level_of_evidence")
    ),
    # accordion items
    bs4Dash::bs4Card(
      title = "Clinic Model",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "Type of vaccination clinic model described in the resource."
      ),
      tableOutput("hd_clinic_models")
    ),
    bs4Dash::bs4Card(
      title = "Intervention Type",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "Main theme."
      ),
      tableOutput("hd_intervention_type")
    ),
    bs4Dash::bs4Card(
      title = "Target Group",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "Organised according to PROGRESS-Plus, an acronym used to identify characteristics that stratify health opportunities and outcomes. (",
        tags$a(
          href = "https://methods.cochrane.org/equity/projects/evidence-equity/progress-plus",
          "https://methods.cochrane.org/equity/projects/evidence-equity/progress-plus"
        ),
        ")"
      ),
      tableOutput("hd_target_group")
    ),
    bs4Dash::bs4Card(
      title = "Behavioural Change",
      width = 12,
      status = "warning",
      solidHeader = TRUE,
      tags$p(
        "Mechanism of behaviour change: organised according to the COM-B model (Capability, Opportunity, Motivation)."
      ),
      tableOutput("hd_behavioural_change")
    )
  )

  body <- bs4Dash::bs4DashBody(
    bs4Dash::bs4TabItems(
      bs4Dash::bs4TabItem(
        tabName = "content",
        mod_knowledge_items_ui("evidence")
      ),
      bs4Dash::bs4TabItem(
        tabName = "heading_details",
        heading_details
      )
    ),
    shinydisconnect::disconnectMessage(
      text = "Your session has timed out.",
      refresh = "Click here to reload",
      background = "#f9bf07",
      size = 36,
      width = 550,
      top = "center",
      colour = "white",
      overlayColour = "#999",
      refreshColour = "#2c2825",
      overlayOpacity = 0.4
    )
  )

  tagList(
    golem_add_external_resources(),
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
