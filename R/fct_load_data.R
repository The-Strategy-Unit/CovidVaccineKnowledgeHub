#' Load Data
#'
#' @description Import data from the excel file. This function loads and transforms the data ready for use in the app.
#'
#' @return A tibble containing the data from the excel file.
#'
#' @noRd
load_data <- function() {
  d <- readxl::read_excel(app_sys("data.xlsx"), sheet = "Datasheet", skip = 1) |>
    dplyr::mutate(id = dplyr::row_number(), .before = dplyr::everything())

  progress_plus <- d |>
    dplyr::select(
      .data[["id"]],
      .data[["1. Place of residence"]],
      .data[["2. Race, ethnicity, culture, language"]],
      .data[["3. Occupation"]],
      .data[["4. Gender/Sex"]],
      .data[["5. Religion"]],
      .data[["6. Education"]],
      .data[["7. Socioeconomic status (SES)"]],
      .data[["8. Social Capital"]],
      .data[["9. Age"]],
      .data[["10. Disability"]]
    ) |>
    tidyr::pivot_longer(-.data[["id"]]) |>
    tidyr::drop_na(.data[["value"]]) |>
    dplyr::group_by(.data[["id"]]) |>
    dplyr::summarise(progress_plus = list(.data[["name"]]))

  jcvi_report <- d |>
    dplyr::select(
      .data[["id"]],
      .data[["1"]],
      .data[["2"]],
      .data[["3"]],
      .data[["4"]],
      .data[["5"]],
      .data[["6"]],
      .data[["7"]],
      .data[["8"]],
      .data[["9"]],
      .data[["10"]],
      .data[["11"]],
      .data[["12"]]
    ) |>
    tidyr::pivot_longer(-.data[["id"]]) |>
    tidyr::drop_na(.data[["value"]]) |>
    dplyr::group_by(.data[["id"]]) |>
    dplyr::summarise(jcvi_report = list(.data[["name"]]))

  tags <- d |>
    dplyr::select(
      .data[["id"]],
      .data[["Capability"]],
      .data[["Opportunity"]],
      .data[["Motivation"]]
    ) |>
    tidyr::pivot_longer(-.data[["id"]]) |>
    tidyr::drop_na(.data[["value"]]) |>
    dplyr::group_by(.data[["id"]]) |>
    dplyr::summarise(tags = list(.data[["name"]]))

  d |>
    dplyr::select(
      .data[["id"]],
      location = .data[["Location"]],
      title = .data[["Resource title"]],
      publisher = .data[["Publisher"]],
      date = .data[["Date"]],
      evidence_type = .data[["Evidence type (e.g. qualitative analysis, quantitative analysis, mixed methods, lessons learned, desk research)"]], # Exclude Linting
      level_evidence = .data[["Level of evidence"]],
      main_theme = .data[["Main Theme"]],
      methods_used = .data[["Methods used"]],
      brief_description = .data[["Brief description of the intervention/model"]],
      rationale = .data[["Rationale for the intervention/ model"]],
      clinic_model = .data[["Clinic model"]],
      source = .data[["Link to original source"]]
    ) |>
    dplyr::left_join(progress_plus, by = "id") |>
    dplyr::left_join(jcvi_report, by = "id") |>
    dplyr::left_join(tags, by = "id")
}