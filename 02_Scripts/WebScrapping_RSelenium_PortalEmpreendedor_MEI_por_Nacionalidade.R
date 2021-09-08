##########################################
#Objetivo: Programa para coleta do informacoes no Portal do Empreendedor
#          dos totais de MEI por nacionalidade,
#          por unidade da federacao e por municipio              
#Autor: Eduardo Santiago Rosseti
#Data: 01/09/2021
#Atualizacao: 01/09/2021
##########################################
library(RSelenium)
library(tidyverse)
library(rvest)
library(httr)
library(rJava)

#Setar caminho para o JAVA
Sys.setenv(JAVA_HOME="C:/Arquivos de Programas/Java/jre1.8.0_291/")

#chamada do firefox
rD <<- rsDriver(port = 4565L, browser = "chrome")

#remDr <- rD[["client"]]
#remDr$open() #abrindo o navegador

#abre o site
remDr$navigate("http://www22.receita.fazenda.gov.br/inscricaomei/private/pages/default.jsf")

#clica em Relatorios Estatisticos
webElems <- remDr$findElements(using = "css selector", "a")
resHeaders <- unlist(lapply(webElems, function(x) {x$getElementText()}))
resHeaders

webElem <- webElems[[3]]
webElem$clickElement()

#clica em Nacionalidade Brasil UF Municipio
webElems <- remDr$findElements(using = "css selector", "a")
resHeaders <- unlist(lapply(webElems, function(x) {x$getElementText()}))
resHeaders

webElem <- webElems[[13]]
webElem$clickElement()

#coleta as opcoes de uf do formulario
webElem <- remDr$findElement(using = 'xpath', "//select[@name='form:uf']")
uf <- webElem$selectTag()

#cria um banco de saida
#vamos coletar as informacoes dos municipios do Acre
saida <- NULL

for (u in c(2)){ #u recebe a uf ou lista de ufs desejadas
  
  #seleciona a uf desejada no formulario
  webElem <- remDr$findElement(using = 'xpath', "//select[@name='form:uf']")
  script <- paste0("arguments[0].value = '", uf$value[u], "'; arguments[0].onchange();") # set to February
  zz <- try(remDr$executeScript(script, list(webElem)),silent = T)
  Sys.sleep(10)
  
  #pega os municipios no formulario
  webElem <- remDr$findElement(using = 'xpath', "//select[@name='form:municipioUF']")
  mun = NULL #lista de muncicipio
  try(mun <- webElem$selectTag(), silent = T)
  mun.total = length(mun$value)
  
  #faz a acoleta
  for(m in 2:mun.total){ #m percorre os municipios
    print(mun$text[m])
    
    
    script <- paste0("arguments[0].value = '", mun$value[m], "'; arguments[0].onchange();") # set to February
    webElem <- remDr$findElement(using = 'xpath', "//select[@name='form:municipioUF']")
    zz <- try(remDr$executeScript(script, list(webElem)), silent = T)
    Sys.sleep(.5)
    
    webElem <- remDr$findElement(using = 'xpath', "//input[@name='form:botaoConsultar']")
    zz <- try(webElem$clickElement(), silent = T)
    Sys.sleep(4)
    
    #traduz a tabela
    tabela <- remDr$findElements(using = "css selector", "table")
    tabela <- unlist(lapply(tabela, function(x) {x$getElementText()}))
    tabela <- str_split(tabela, "\n")[[1]]
    tabela <- tabela[2:length(tabela)]
    
    n = length(tabela)
    #gera dataframe
    aux <- data.frame(nacionalidade = tabela[2*(1:(n/2)) - 1],
                      MEI = tabela[2*(1:(n/2))],
                      UF = uf$text[u],
                      MUN = mun$text[m],
                      MUN.cod = mun$value[m]
    ) %>% filter(nacionalidade!="Total")
    
    #une banco geral
    saida <- saida %>% bind_rows(aux)
  }
}

#tabela - nacionalidades presentes na UF
saida %>%
  mutate(MEI = as.numeric(gsub("\\.","",MEI))) %>% 
  group_by(nacionalidade) %>% 
  summarise(MEI = sum(MEI)) %>% 
  ungroup() %>% 
  arrange(desc(MEI)) %>% 
  View()
  
