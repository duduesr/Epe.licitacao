####################################################################################
#Objetivo: Leitura e organização das bases de dados da
#          PNAD Conínua Trimestral e Sistema de Contas Trimestrais do IBGE
#Autor: Eduardo Santiago Rosseti
####################################################################################

# 1 - Leitura de Bibliotecas ----
library(tidyverse)
library(rjson)

# 2 - Funcao de tratamento de JSON ----
trata.json = function(result){
  aux = NULL
  for (i in 2:length(result)) aux <- aux %>% bind_rows(result[[i]])
  return(aux)
}

# 3 - Coleta via API Sidra da Taxa de Desocupacao do Brasil ----
# Fonte: PNADC Continua Trimetral, IBGE
url.pnadc = "https://apisidra.ibge.gov.br/values/t/4099/n1/all/v/4099/p/all"
db.pnadc <- trata.json(fromJSON(file = url.pnadc))
tab.pnadc <- db.pnadc %>%
  mutate(taxa.desocupacao = as.numeric(V)) %>%
  select(D3C, taxa.desocupacao) %>%
  rename(tempo = D3C)
#salva tabela
tab.pnadc %>% write.csv2("01_Dados/Tabelas/TAB01_PNADC.csv", row.names = F)

# 3 - Coleta via API Sidra a 	Série encadeada do índice de volume trimestral
# Valor Adiconado do Brasil ----
# Fonte: Sistema de Contas Trimestrais, IBGE
#url.pib = "https://apisidra.ibge.gov.br/values/t/5932/n1/all/v/6564/p/all/c11255/90687,90691,90696,90705/d/v6564%201"
url.pib = "https://apisidra.ibge.gov.br/values/t/1620/n1/all/v/all/p/all/c11255/90705/d/v583%202"

db.pib <- trata.json(fromJSON(file = url.pib))
tab.pib <- db.pib %>%
  filter(D4C == 90705) %>% #seleciona apenas o VA a precos basicos
  mutate(va = as.numeric(V)) %>%
  select(D3C, va) %>%
  filter(!is.na(va)) %>%
  rename(tempo = D3C)
#salva tabela
tab.pib %>% write.csv2("01_Dados/Tabelas/TAB02_PIB.csv", row.names = F)
