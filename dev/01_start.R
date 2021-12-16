golem::fill_desc(
  pkg_name = "CovidVaccineKnowledgeHub",
  pkg_title = "Covid Vaccine Knowledge Hub",
  pkg_description = "A dashboard allowing users to search for Covid Vaccine evidence stored on NHS Futures.",
  author_first_name = "The Strategy Unit",
  author_last_name = "",
  author_email = "strategy.unit@nhs.net",
  repo_url = NULL
)
golem::set_golem_options()
usethis::use_mit_license( "The Strategy Unit" )
usethis::use_readme_rmd( open = FALSE )
usethis::use_lifecycle_badge( "Experimental" )
usethis::use_git()
golem::use_recommended_tests()
golem::use_recommended_deps()
golem::remove_favicon()
golem::use_utils_ui()
golem::use_utils_server()
rstudioapi::navigateToFile( "dev/02_dev.R" )
