#' knowledge_items UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_knowledge_items_ui <- function(id) {
  ns <- NS(id)

  shiny::uiOutput(ns("accordion"))
}

#' knowledge_items Server Functions
#'
#' @noRd
mod_knowledge_items_server <- function(id, data_reactive) {

  knowledge_item_card <- function(x) {
    headerid <- paste0("heading", x$id)
    collapseid <- paste0("collapse", x$id)

    htmltools::div(
      class = "card",
      htmltools::div(
        class = "card-header",
        id = headerid,
        htmltools::h3(
          class = "mb-0",
          htmltools::tags$button(
            class = "btn btn-link",
            "data-toggle" = "collapse",
            "data-target" = paste0("#", collapseid),
            "aria-expanded" = "false",
            "aria-controls" = collapseid,
            x$title
          )
        ),
        tags$div(
          class = "card-tools float-right",
          tags$button(
            class = "btn btn-tool btn-sm",
            type = "button",
            "data-toggle" = "collapse",
            "data-target" = paste0("#", collapseid),
            tags$i(
              class="fa fa-chevron-down",
              role="presentation",
              "aria-label" = "expand icon"
            )
          )
        )
      ),
      htmltools::div(
        id = collapseid,
        class = "collapse",
        "aria-labelledby" = headerid,
        "data-parent" = paste0("#", id, "-accordion"),
        htmltools::div(
          class = "card-body",
          htmltools::p(
            htmltools::strong("Clinic Model: "),
            x$clinic_model
          ),
          htmltools::p(
            htmltools::strong("Intervention Type: "),
            x$intervention_type
          ),
          htmltools::p(
            htmltools::strong("Target Group: "),
            paste(x$progress_plus, collapse = ", ")
          ),
          htmltools::p(
            htmltools::strong("Behavioural Change: "),
            paste(x$tags, collapse = ", ")
          ),
          htmltools::p(
            htmltools::a(href = x$source, "source", target="_blank")
          )
        )
      )
    )
  }

  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$accordion <- renderUI({
      data_reactive() |>
        purrr::array_tree() |>
        purrr::map(knowledge_item_card)
    })
  })
}
