options(golem.app.prod = FALSE, shiny.autoreload = FALSE)
golem::detach_all_attached()
golem::document_and_reload()
shiny::runApp(appDir = here::here())
