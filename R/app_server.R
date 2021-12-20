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
  output$evidence <- renderTable({
    data <- d

    if (isTruthy(input$tags)) {
      data <- data |>
        dplyr::filter(purrr::map_lgl(.data[["tags"]], ~any(.x %in% input$tags)))
    }

    if (isTruthy(input$search)) {
      # TODO: replace regex with levenshtein?
      data <- data |>
        dplyr::rowwise() |>
        dplyr::filter(purrr::some(dplyr::c_across(where(is.character)), stringr::str_detect, input$search)) |>
        dplyr::ungroup()
      golem::cat_dev("ran search\n")
    }

    if (isTruthy(input$dates)) {
      data <- data |>
        dplyr::filter(.data[["date"]] %in% input$dates)
    }

    if (isTruthy(input$level_evidence)) {
      data <- data |>
        dplyr::filter(.data[["level_evidence"]] %in% input$level_evidence)
    }

    if (isTruthy(input$main_theme)) {
      data <- data |>
        dplyr::filter(.data[["main_theme"]] %in% input$main_theme)
    }

    if (isTruthy(input$clinic_model)) {
      data <- data |>
        dplyr::filter(.data[["clinic_model"]] %in% input$clinic_model)
    }

    if (isTruthy(input$methods_used)) {
      data <- data |>
        dplyr::filter(.data[["methods_used"]] %in% input$methods_used)

    }

    if (isTruthy(input$progress_plus)) {
      data <- data |>
        dplyr::filter(purrr::map_lgl(.data[["progress_plus"]], ~any(.x %in% input$progress_plus)))
    }

    if (isTruthy(input$jcvi_report)) {
      data <- data |>
        dplyr::filter(purrr::map_lgl(.data[["jcvi_report"]], ~any(.x %in% input$jcvi_report)))

    }

    dplyr::select(data, .data[["title"]])
  })
}
