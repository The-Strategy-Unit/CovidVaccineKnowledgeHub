#' Load Data
#'
#' @description Import data from the excel file. This function loads and transforms the data ready for use in the app.
#'
#' @return A tibble containing the data from the excel file.
#'
#' @noRd
load_data <- function() {
  filename <- withr::local_file("data.xlsx")
  url <- "https://strategyunit.blob.core.windows.net/927covidvaccineknowledge/data.xlsx"

  download.file(url, filename, mode = "wb")

  d <- readxl::read_excel(filename, sheet = "Datasheet", skip = 1) |>
    dplyr::mutate(id = dplyr::row_number(), .before = dplyr::everything())

  progress_plus <- d |>
    dplyr::select(
      .data[["id"]],
      .data[["General population"]],
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

  jcvi_cohort <- d |>
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
    dplyr::summarise(jcvi_cohort = list(.data[["name"]]))

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
      date = .data[["Date of publication: organised into four month periods, beginning January 2020."]], # Exclude Linting
      evidence_type = .data[["Evidence type: the format of the resource."]], # Exclude Linting
      level_evidence = .data[["Level of evidence: organised according to Nesta's Standards of Evidence. Level 1 is the weakest evidence type, usually consisting of an account of the impact. The strongest evidence is level 5, with the resource showing that the intervention could be scal"]],
      main_theme = .data[["Main Theme"]],
      methods_used = .data[["Methods used: the process used which lead to the outcome described."]],
      brief_description = .data[["Brief description of the intervention/model"]],
      rationale = .data[["Rationale for the intervention/ model"]],
      clinic_model = .data[["Clinic model"]],
      source = .data[["Link to original source"]]
    ) |>
    dplyr::left_join(progress_plus, by = "id") |>
    dplyr::left_join(jcvi_cohort, by = "id") |>
    dplyr::left_join(tags, by = "id") |>
    dplyr::mutate(
      dplyr::across(
        .data[["date"]],
        ~dplyr::case_when(
          .x < as.POSIXct("2021-04-01") ~ "Jan to Mar 21",
          .x < as.POSIXct("2021-07-01") ~ "Apr to Jun 21",
          .x < as.POSIXct("2021-10-01") ~ "Jul to Sep 21",
          # .x < as.POSIXct("2022-01-01") ~ "Oct to Dec 21",
          TRUE ~ as.character(NA)
        ) |>
          factor(levels = c(
            "Jan to Mar 21",
            "Apr to Jun 21",
            "Jul to Sep 21"
            # "Oct to Dec 21"
          ))
      )
    )
}
