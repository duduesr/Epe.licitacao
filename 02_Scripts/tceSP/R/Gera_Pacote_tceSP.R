# Criar pacote de funções em R

## Pacotes necessários
library(devtools)
library(roxygen2)
library(testthat)
library(knitr)
library(usethis)
library(covr)
library(testthat)

# Configurações startup ------------------------------------------------------------------

## Criar pacote:
usethis::create_package("tceSP")

## Use GITHUB
usethis::use_git(message = "Download de Despesas Municipais - TCE-SP")
#usethis::create_github_token()
usethis::edit_r_environ()
# Deixar o Renviron com uma linha em branca no fim

usethis::use_github(protocol = "https")
usethis::use_github_links()

## Definir Licença do pacote
usethis::use_mit_license("Eduardo Rosseti")

## Criar readme.md
usethis::use_readme_md()

## Definir as badges do pacote
usethis::use_cran_badge()
usethis::use_lifecycle_badge("stable")

## Criar o testthat para o pacote
usethis::use_testthat()

# Configurações contínuas ----------------------------------------------------------------

## Criar funções em scripts .R na pasta R
usethis::use_r("leitura")
usethis::use_r("lista")

## Selecionar os pacotes que serão instalados em paralelo
usethis::use_package("testthat", type = "Suggests")
#usethis::use_package("dplyr", type = "Imports")
usethis::use_package("jsonlite", type = "Imports")
usethis::use_package("RCurl", type = "Imports")
usethis::use_package("utils", type = "Imports")


## Criar os arquivos para testthat
usethis::use_test("listing")

## Rodar a cada release

# Restart R Session (Ctrl+Shift+F10)
# Document Package (Ctrl+Shift+D)
# Check Package (Ctrl+Shift+E)

usethis::use_version()

## Construir pacote
devtools::build()

## Criar site
#pkgdown::build_site()
