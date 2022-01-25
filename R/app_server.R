#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import rlang
#' @noRd
app_server <- function( input, output, session ) {

  # on initialisation:
  # load excel file
  data <- reactive({
    load_data()
  })

  # update inputs
  # populate evidence

  observe({
    d <- data()

    methods_used <- sort(unique(d[["methods_used"]]))
    updateSelectizeInput(session, "methods_used", choices = methods_used)

    dates <- levels(d$date)
    updateSelectizeInput(session, "dates", choices = dates)

    tags <- sort(unique(purrr::flatten_chr(d[["tags"]])))
    updateSelectizeInput(session, "tags", choices = tags)
  })

  # outputs
  filtered_data <- reactive({
    d <- data()

    if (isTruthy(input$search)) {
      # TODO: replace regex with levenshtein?
      d <- d |>
        dplyr::filter(dplyr::if_any(where(is.character), stringr::str_detect, stringr::fixed(input$search)))
    }

    if (isTruthy(input$dates)) {
      d <- d |>
        dplyr::filter(.data[["date"]] %in% input$dates)
    }

    if (isTruthy(input$level_evidence)) {
      d <- d |>
        dplyr::filter(.data[["level_evidence"]] %in% input$level_evidence)
    }

    if (isTruthy(input$methods_used)) {
      d <- d |>
        dplyr::filter(.data[["methods_used"]] %in% input$methods_used)
    }

    if (isTruthy(input$jcvi_cohort)) {
      d <- d |>
        dplyr::filter(purrr::map_lgl(.data[["jcvi_cohort"]], ~any(.x %in% input$jcvi_cohort)))
    }

    d
  })

  mod_knowledge_items_server("evidence", filtered_data)
}
