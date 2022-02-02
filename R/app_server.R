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

  observeEvent(input$sidebarmenu, {
    if (input$sidebarmenu == "content") {
      shinyjs::showElement("content-filters")
    } else {
      shinyjs::hideElement("content-filters")
    }
  })

  observeEvent(input$back_content, {
    bs4Dash::updateTabItems(session, "sidebarmenu", "content")
  })

  # update inputs
  # populate evidence
  observe({
    d <- data()

    knowledge_format <- sort(unique(d[["knowledge_format"]]))
    updateSelectizeInput(session, "knowledge_format", choices = knowledge_format)

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

    if (isTruthy(input$knowledge_format)) {
      d <- d |>
        dplyr::filter(.data[["knowledge_format"]] %in% input$knowledge_format)
    }

    if (isTruthy(input$jcvi_cohort)) {
      d <- d |>
        dplyr::filter(purrr::map_lgl(.data[["jcvi_cohort"]], ~any(.x %in% input$jcvi_cohort)))
    }

    d
  })

  mod_knowledge_items_server("evidence", filtered_data)

  # heading details
  output$hd_jcvi_cohorts <- renderTable({
    dplyr::tribble(~Cohort, ~Description,
      "1", "Residents in a care home for older adults and their carers.",
      "2", "All those 80 years of age and over and frontline health and social care workers.",
      "3", "All those 75 years of age and over.",
      "4", "All those 70 years of age and over and clinically extremely vulnerable individuals.",
      "5", "All those 65 years of age and over.",
      "6", "All individuals aged 16 years to 64 years with underlying health conditions which put them at higher risk of serious disease and mortality.",
      "7", "All those 60 years of age and over.",
      "8", "All those 55 years of age and over.",
      "9", "All those 50 years of age and over.",
      "10", "All those aged 40 to 49 years.",
      "11", "All those aged 30 to 39 years.",
      "12", "All those aged 18 to 29 years."
    )
  })

  output$hd_evidence_types <- renderTable({
    data() |>
      dplyr::distinct(`Evidence Type` = stringr::str_to_title(evidence_type)) |>
      dplyr::mutate(dplyr::across(`Evidence Type`, ~ifelse(.x == "Faq", "FAQ", .x))) |>
      dplyr::arrange(`Evidence Type`) |>
      tidyr::drop_na()
  })

  output$hd_level_of_evidence <- renderTable({
    dplyr::tribble(~Level, ~Description,
      "1", "The resource gives an account of impact, providing a logical reason, or set of reasons, for why the intervention could have an impact and why that would be an improvement on the current situation.",
      "2", "The resource provides evidence of gathering data that shows some change amongst those receiving or using your intervention. At this stage, data can begin to show effect but it will not evidence direct causality.",
      "3", "The resource demonstrates that the intervention is causing the impact, by showing less impact amongst those who don’t receive the product/service. Methods might include a control group (or another well justified method) that begin to isolate  the impact of the product/service. Random selection  of participants strengthens evidence at this Level.",
      "4", "The resource explains why and how the intervention is having the impact observed. In addition, the intervention can deliver impact at a reasonable cost, suggesting that it could be replicated/commissioned in multiple locations. At this stage, we are looking for a robust independent  evaluation that investigates and validates the nature of the impact, that shows standardisation of delivery  and processes and data on costs.",
      "5", "The resource shows that the intervention could be replicated elsewhere and scaled up, whilst continuing to have positive and direct impact on the outcome, and whilst remaining a financially viable proposition. We expect to see use of methods like multiple replication evaluations; future scenario analysis; and scaled up, fidelity evaluation."
    )
  })

  output$hd_clinic_models <- renderTable({
    dplyr::tribble(~`Clinic Model`, ~Description,
    "Local primary care/GP service led sites", "Sites led by primary care services - includes many pop-up clinics or roving models.",
    "Pharmacy led sites", "Vaccine sites located in or organised by community pharmacies.",
    "Hospital hubs", "Vaccine sites located within hospitals, largely used to vaccinate health cand care workers.",
    "Mass vaccination sites", "Large central sites used to vaccinate many people at once."
    )
  })

  output$hd_intervention_type <- renderTable({
    dplyr::tribble(~`Intervention type`, ~Description,
      "Clinical improvement and governance", "Interventions focused on sustaining and improving high standards of patient care.",
      "Communication Strategy to promote vaccine programme and to overcome vaccine hesitancy", "Interventions focused on promoting the vaccine programme to the public and overcoming vaccine hesitancy.",
      "Community engagement and partnerships", "Interventions where partnerships between different organisations is a primary feature.",
      "Equity - vaccine equity for diverse populations and inclusion health groups", "Interventions focused on increasing equitable access to the COVID-19 vaccine.",
      "Leadership and governance", "Interventions where leadership has resulted in improved service.", "Strategy and policy", "Interventions describing a plan or set of objectives related to managing the vaccine programme.",
      "Vaccine logistics, administration, and operation at the various clinic settings", "Interventions focused on improving the storage, transport and stock management of the COVID-19 vaccines.",
      "Workforce and training", "Interventions describing ways in which to train or upskill the vaccine delivery programme workforce."
    )
  })

  output$hd_target_group <- renderTable({
    dplyr::tribble(~`PROGRESS-PLUS`, ~Description,
      "1. Place of residence", "Refers to interventions aimed at dwelling type, location, or lack of (e.g. people experiencing homelessness).",
      "2. Race, ethnicity, culture, language", "Refers to interventions targeted by ethnicity, culture, and language.",
      "3. Occupation", "Refers to the occupational group targeted.",
      "4. Gender/Sex", "Refers to targeted gender-based interventions.",
      "5. Religion", "Refers to the religious affiliation targeted for increasing vaccine equity.",
      "6. Education", "Refers to interventions in educational settings or specific groups of students.",
      "7. Socioeconomic status", "Refers to interventions delivered specifically to target socio-economic groups.",
      "8. Social capital", "Refers to interventions where community and social capital has been used.",
      "9. Age", "Refers to targeted age-based interventions.",
      "10. Disability", "Refers to interventions targeting people with specific physical or mental health impairment.",
      "General population", "Refers to interventions targeting the general population to increase vaccine uptake."
    )
  })

  output$hd_behavioural_change <- renderTable({
    dplyr::tribble(~Mechanisms, ~Description,
      "Capability", "Physical and psychological capability to engage with the steps required to give or receive a vaccine.",
      "Opportunity", "The physical opportunity to receive a COVID-19 vaccine.",
      "Motivation", "Includes reflective and automatic processes that contribute towards deciding to get a COVID-19 vaccine."
    )
  })
}
