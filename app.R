# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

options("golem.app.prod" = TRUE, shiny.autoreload = FALSE)
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
CovidVaccineKnowledgeHub::run_app() # add parameters here (if any)
