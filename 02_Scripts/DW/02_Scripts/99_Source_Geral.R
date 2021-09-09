####################################################################################
#Objetivo: Rotina de execucao geral
#Autor: Eduardo Santiago Rosseti
####################################################################################

# 1 - Coleta e Download de informacao via API SIBRE
source("02_Scripts/01_Leitura_coleta_dados_APISIDRA_IBGE.R",
       encoding = "UTF-8")
# 2 - Estimacao de componentes da serie do indice de volume do valor agrregado
#Nivel
#Tendencia
#Sazonalidade
#Efeito da COVID-19 na tendencia
source("02_Scripts/02_Tratamento_de_Serie_Temporal_Previsao_VA.R",
       encoding = "UTF-8")
# 3 - Estimacao da taxa de desocupacao relacionada a tendencia do VA
#Nivel
#Tendencia dependente das tendencias do VA
#Sazonalidade
source("02_Scripts/03_Estima_relacao_temporal_entre_taxa_desocupacao_e_va.R",
       encoding = "UTF-8")
# 4 - Gera relatorio em PPT
source("02_Scripts/04_Gera_Relatorio_ppt.R",
       encoding = "UTF-8")
