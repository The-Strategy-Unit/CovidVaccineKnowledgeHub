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
  d <- load_data()

  # update inputs
  # populate evidence

  observe({
    f <- function(x) {
      v <- sort(unique(d[[x]]))
      updateSelectizeInput(session, x, choices = v)
    }
    f("main_theme")
    f("clinic_model")
    f("methods_used")

    date <- sort(unique(d$date))
    date <- purrr::set_names(date, format(date, "%b-%y"))
    updateSelectizeInput(session, "dates", choices = date)

    tags <- sort(unique(purrr::flatten_chr(d[["tags"]])))
    updateSelectizeInput(session, tags, choices = tags)
  })

  # outputs
  filtered_data <- reactive({
    data <- d

    if (isTruthy(input$search)) {
      # TODO: replace regex with levenshtein?
      data <- data |>
        dplyr::filter(dplyr::if_any(where(is.character), stringr::str_detect, stringr::fixed(input$search)))
    }

    if (isTruthy(input$dates)) {
      data <- data |>
        dplyr::filter(.data[["date"]] %in% as.POSIXct(input$dates, tz = "UTC"))
    }

    if (isTruthy(input$level_evidence)) {
      data <- data |>
        dplyr::filter(.data[["level_evidence"]] %in% input$level_evidence)
    }

    if (isTruthy(input$methods_used)) {
      data <- data |>
        dplyr::filter(.data[["methods_used"]] %in% input$methods_used)

    }

    if (isTruthy(input$jcvi_cohort)) {
      data <- data |>
        dplyr::filter(purrr::map_lgl(.data[["jcvi_cohort"]], ~any(.x %in% input$jcvi_cohort)))
    }

    data
  })

  mod_knowledge_items_server("evidence", filtered_data)
}
