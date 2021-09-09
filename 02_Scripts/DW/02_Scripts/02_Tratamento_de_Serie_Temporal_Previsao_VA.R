####################################################################################
#Objetivo: Estima um modelo estrutural para serie temporal da variacao
#          do valor adicionado
#Autor: Eduardo Santiago Rosseti
####################################################################################

# 1 - Leitura de Bibliotecas ----
library(tidyverse)
library(lubridate)
library(dlm)

# 2 - Leitura do banco de dados do Valor Adicionado ----
db <- read.csv2("01_Dados/Tabelas/TAB02_PIB.csv",
                stringsAsFactors = T)


# 3 - Estima modelo Estutural Basico ----

yt <- c(db$va)
yt = ts(yt)
plot(yt)

#criando o efeito da pandemia na serie
db <- db  %>%
  mutate(efeito = ifelse(tempo > "201904", T, F))
reg <- as.matrix(as.numeric(db[,"efeito"]))

#Estimacao BSM via DLM
myFun <- function(xx) {
  modelo = dlmModPoly(order = 2,
                      dV = xx[1]^2,
                      dW = xx[2:3]^2,
                      m0 = c(10^5,0)) +
    dlmModSeas(4, dV=0,
               dW = xx[4:6]^2) +
    dlmModReg(reg, addInt = F, dV = 0, dW = c(xx[7]^2),
              m0 = 10^5)
  return(modelo)
}

fitTemp <- dlmMLE(yt,
                  parm = rep(1,7),
                  build = myFun,
                  #hessian = TRUE,
                  control = list(maxit = 50000))

model = myFun(fitTemp$par)
ff <- dlmFilter(yt, model)
ss <- dlmSmooth(ff) #modelo suavizado

#gera serie com ajuste sazonal com e sem efeito da pandemia

db <- db %>%
  select(-efeito) %>%
  mutate(va.Lt = ss$s[-1,1],
         va.Rt = ss$s[-1,2],
         va.St = ss$s[-1,3],
         va.efeito.covid = ss$s[-1,6]*reg,
         va.Lt.covid = ss$s[-1,1] + ss$s[-1,6]*reg
  )

# 4 - Salva tabela
db %>% write.csv2("01_Dados/Tabelas/TAB03_PIB_Decomposto.csv", row.names = F)


