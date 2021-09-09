####################################################################################
#Objetivo: Estima um modelo estrutural para serie temporal da taxa de desocupacao
#          explicada pelo nivel do valor adicionado
#Autor: Eduardo Santiago Rosseti
####################################################################################

# 1 - Leitura de Bibliotecas ----
library(tidyverse)
library(lubridate)
library(dlm)

# 2 - Leitura do banco de dados do Valor Adicionado ----
db.pnadc <- read.csv2("01_Dados/Tabelas/TAB01_PNADC.csv",
                      stringsAsFactors = T)

db.pib <- read.csv2("01_Dados/Tabelas/TAB03_PIB_Decomposto.csv",
                    stringsAsFactors = T)

db <- db.pnadc %>%
  left_join(db.pib) #merge pelo tempo

# 3 - Estima modelo Estutural Basico ----

yt <- c(db$taxa.desocupacao)
yt = ts(yt)
plot(yt)

#criando o efeito da pandemia na serie
reg <- matrix(c(db$va.Rt, db$va.efeito.covid), nrow(db),2)

#Estimacao BSM via DLM
myFun <- function(xx) {
  modelo =
        dlmModPoly(order = 1,
                        dV = xx[1]^2,
                        dW = xx[2]^2,
                        m0 = c(10^5)) +
    dlmModSeas(4,
               dW = xx[3:5]^2) +
    dlmModReg(reg, addInt = F, dV = 0, dW = c(xx[6:7]^2),
              m0 = rep(10^5,2))
  return(modelo)
}

fitTemp <- dlmMLE(yt,
                  parm = rep(.1,7),
                  build = myFun,
                  #hessian = TRUE,
                  control = list(maxit = 50000))


model = myFun(fitTemp$par)

ff <- dlmFilter(yt, model)
ss <- dlmSmooth(ff) #modelo suavizado

#gera serie com ajuste sazonal com e sem efeito da pandemia
db <- db %>%
  mutate(taxa.desocupacao.Lt = ss$s[-1,1],
         taxa.desocupacao.St = ss$s[-1,2],
         taxa.desocupacao.efeito.va = ss$s[-1,5],
         taxa.desocupacao.efeito.va.covid = ss$s[-1,6]*(reg[,2]!=0),
         taxa.desocupacao.Lt.efeito.va = ss$s[-1,5]*reg[,1] +ss$s[-1,1],
         taxa.desocupacao.Lt.efeito.va.covid = ss$s[-1,5]*reg[,1] + ss$s[-1,6]*(reg[,2]) + ss$s[-1,1],
         taxa.desocupacao.Lt.St.efeito.va.covid = ss$s[-1,5]*reg[,1] + ss$s[-1,6]*(reg[,2]) + ss$s[-1,1] + ss$s[-1,2],
         taxa.desocupacao.Rt.va = ss$s[-1,5]*reg[,1],
         taxa.desocupacao.Rt.va.covid = ss$s[-1,5]*reg[,1] + ss$s[-1,6]*(reg[,2])


  )


# 4 - Salva tabela
db %>% write.csv2("01_Dados/Tabelas/TAB04_Relacao_TaxaDesocupacao_VA.csv")

# plot(db$taxa.desocupacao, pch =19, cex = .5, col ="gray44")
# #lines(db$taxa.desocupacao.Lt)
# lines(db$taxa.desocupacao.Lt.efeito.va, col = "blue")
# lines(db$taxa.desocupacao.Lt.efeito.va.covid, col = "red")
# lines(db$taxa.desocupacao.Lt.St.efeito.va.covid, col = "green")
#
# plot(db$taxa.desocupacao.efeito.va, type = "l")
# plot(db$taxa.desocupacao.efeito.va.covid, type = "l")
#
# plot(db$taxa.desocupacao.Rt.va.covid, type = "l", col = "red")
# lines(db$taxa.desocupacao.Rt.va)

