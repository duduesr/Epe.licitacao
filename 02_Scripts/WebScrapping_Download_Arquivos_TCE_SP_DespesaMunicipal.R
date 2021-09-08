##########################################
#Objetivo: Programa para download de arquivos 
#          de despesa detalhada dos municípios do TCE de São Paulo                 
#Autor: Eduardo Santiago Rosseti
#Data: 01/09/2021
#Atualizacao: 01/09/2021
##########################################

# 0 - Bibliotecas ----
library(tidyverse)
library(jsonlite)
library(RCurl)
# 1 - Cria Funcao de Leitura e Download ----
leitura.despesa.detalhada <- function(m, a){
  #m: municipio
  #a: ano da despesa
  
  #url de download
  url = paste0("https://transparencia.tce.sp.gov.br/sites/default/files/csv/despesas-",m,"-",a,".zip")
  
  
  if (!url.exists(url)){
    print("Ocorreu algum erro!URL não existe")
    return(db = NULL)
  }else{
    
    #destino do arquivo
    destino = tempfile(fileext = ".zip")
    #fazendo o download
    teste.download <- download.file(url, destfile = destino)
    class(teste.download)
    #testando se deu certo    
    destino.csv = "auxiliar"
    unzip(zipfile = destino,  exdir = destino.csv)
    #leitura do banco
    arq.csv = paste0(destino.csv,"//",list.files(destino.csv))
    db <-  read.csv2(arq.csv)
    unlink("auxiliar", recursive = TRUE)
    return(db)
  }
}

# 2 - Listagem de municipios ----
lista.mun = fromJSON("https://transparencia.tce.sp.gov.br/api/json/municipios")

# 3 - Testando a funcao
#download do arquivo de Araraquara em 2019
#necessario verificar o arquivo lista.mun
araraquara.2019 = leitura.despesa.detalhada("araraquara", 2019)  

# 3.1 - Qual o orgao com maior despesa empenhada
araraquara.2019 %>% 
  filter(tp_despesa == "Empenhado") %>% 
  group_by(ds_orgao) %>% 
  summarise(Absoluto = sum(vl_despesa, na.rm = T)) %>% 
  ungroup() %>% 
  mutate(Relativo = 100*Absoluto/sum(Absoluto)) %>% 
  arrange(desc(Absoluto)) %>% 
  View

# 3.2 - Qual a subfuncao de governo com maior despesa empenhada
araraquara.2019 %>% 
  filter(tp_despesa == "Empenhado") %>% 
  group_by(ds_funcao_governo, ds_subfuncao_governo) %>% 
  summarise(Absoluto = sum(vl_despesa, na.rm = T)) %>% 
  ungroup() %>% 
  mutate(Relativo = 100*Absoluto/sum(Absoluto)) %>% 
  arrange(desc(Absoluto)) %>% 
  View

# 3.3 - Fornecedor com maior valor pago
araraquara.2019 %>% 
  filter(tp_despesa == "Valor Pago") %>% 
  group_by(ds_despesa) %>% 
  summarise(Absoluto = sum(vl_despesa, na.rm = T)) %>% 
  ungroup() %>% 
  mutate(Relativo = 100*Absoluto/sum(Absoluto)) %>% 
  arrange(desc(Absoluto)) %>% 
  View