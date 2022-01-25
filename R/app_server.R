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
      dplyr::distinct(`Evidence Type` = evidence_type) |>
      dplyr::arrange(`Evidence Type`) |>
      tidyr::drop_na()
  })

  output$hd_level_of_evidence <- renderTable({
    dplyr::tribble(~Level, ~Description,
      "1", "The resource gives an account of impact, providing a logical reason, or set of reasons, for why the intervention could have an impact and why that would be an improvement on the current situation.",
      "2", "The resource provides evidence of gathering data that shows some change amongst those receiving or using your intervention. At this stage, data can begin to show effect but it will not evidence direct causality.",
      "3", "The resource demonstrates that the intervention is causing the impact, by showing less impact amongst those who don’t receive the product/service. Methods might include a control group (or another well justified method) that begin to isolate  the impact of the product/service. Random selection  of participants strengthens evidence at this Level."
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
      "1. Place of residence", "Place of residence can refer to the type of dwelling, location of dwelling, specilist dwelling or lack of dwelling (e.g. people experiencing homelessness).",
      "2. Race, ethnicity, culture, language", "There are many health outcomes that accrue inequitably due to race, ethnicity, culture, and language. Health risks and outcomes are often stratified between ethnic groups, with worse health outcomes often observed in Black, Asian, and Minority Ethnic populations.",
      "3. Occupation", "May refer to the status of employment or type of employment.",
      "4. Gender/Sex", "Gender-based and biological differences can lead to unequal distribution of disease risks, incidence and outcomes, as well as healthcare service needs. Other differences can be due to inequitable exposure to risk or protections based on sex or gender.",
      "5. Religion", "Religious affiliation or a lack thereof can lead to inequitable exposure to harms or opportunities.",
      "6. Education", "Education is known to impact on health status due to its relationship with employment, and consequently, income, but also due to the co-location and embedding of other health interventions into educational settings.",
      "7. Socioeconomic status (SES)", "Higher SES is associated with longer life expectancy and fewer years of poor health due.",
      "8. Social Capital", "Defined as social relationships and networks; this includes interpersonal trust between members of a community, civic participation, and the willingness of community members to assist eachother.",
      "9. Age", "Age is an unavoidable risk factor for many diseases, however certain age groups can be inequitably impacted by avoidable differences in access to services and technology. This category encompasses any intervention targeted at a particular age group.",
      "10. Disability", "Refers to any physical or mental impairment that can result in reduced access to healthcare."
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
