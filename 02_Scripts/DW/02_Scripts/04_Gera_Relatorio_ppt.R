#bibliotecas e funcoes adicionais----
library(tidyverse)
library(officer)
library(magrittr)
library(ggplot2)
library(tidyverse)
library(ggthemes)
library(imager)
library(flextable)

#leitura dados gerais -----
#ver script Ficha Indicadores.r
db  <- read.csv2("01_Dados/Tabelas/TAB04_Relacao_TaxaDesocupacao_VA.csv",
                 stringsAsFactors = F)

#definicao de cores ----
azul = rgb(41/255,47/255,97/255)
verde = rgb(55/255,168/255,174/255)
amarelo = rgb(255/255,193/255,34/255)

#leitura do ppt padrao ----
pptx <- read_pptx("01_Dados/auxilares_relatorio/modelo.pptx")

slide = 0

#1 - cria o primeiro slide ----
pptx <- pptx %>%
  add_slide(master = "Tema do Office",
            layout = "rel")

gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Nível e Valor Observado")+
  geom_line(aes(x = X,
                y = va.Lt.covid),
            color = verde, size = 1.3

            ) +
  geom_line(aes(x = X,
                y = va),
            color = amarelo, size = 1

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text=element_text(size=4),
    axis.title = element_text(size=5)
    )


ppts <- pptx %>% ph_with(gg,
                         ph_location(.1/2.54, 6.93/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")

gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Tendência e Efeito Covid")+
  geom_line(aes(x = X,
                y = va.Rt),
            color = verde, size = 1.3

  ) +
  geom_line(aes(x = X,
                y = va.efeito.covid),
            color = amarelo, size = 1

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text=element_text(size=4),
    axis.title = element_text(size=5)
  )


ppts <- pptx %>% ph_with(gg,
                         ph_location(6.92/2.54, 6.93/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")

gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Sazonalidade")+
  geom_line(aes(x = X,
                y = va.St),
            color = verde, size = 1.3

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text = element_text(size=4),
    axis.title = element_text(size=5)
  )


ppts <- pptx %>% ph_with(gg,
                         ph_location(4.1/2.54, 10.5/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")

gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Nível, Nível sem efeito covid e Valor Observado")+
  geom_line(aes(x = X,
                y = taxa.desocupacao.Lt.efeito.va),
            color = verde, size = 1.3

  ) +
  geom_line(aes(x = X,
                y = taxa.desocupacao),
            color = amarelo, size = 1

  ) +
  geom_line(aes(x = X,
                y = taxa.desocupacao.Lt.efeito.va.covid),
            color = "red", size = .5

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text=element_text(size=4),
    axis.title = element_text(size=5)
  )

ppts <- pptx %>% ph_with(gg,
                         ph_location(.1/2.54, 15.8/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")


gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Tendência e Tendência com Efeito Covid")+
  geom_line(aes(x = X,
                y = taxa.desocupacao.Rt.va),
            color = verde, size = 1.3

  ) +
  geom_line(aes(x = X,
                y = taxa.desocupacao.Rt.va.covid),
            color = "red", size = .5

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text=element_text(size=4),
    axis.title = element_text(size=5)
  )


ppts <- pptx %>% ph_with(gg,
                         ph_location(6.92/2.54, 15.8/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")

gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Sazonalidade")+
  geom_line(aes(x = X,
                y = taxa.desocupacao.St),
            color = verde, size = 1.3

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text=element_text(size=4),
    axis.title = element_text(size=5)
  )

ppts <- pptx %>% ph_with(gg,
                         ph_location(.1/2.54, 19.3/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")


gg <- ggplot(db) +
  xlab("Tempo")+
  ylab("")+
  ggtitle("Relaçaõ Desocupação com Variação do VA")+
  geom_line(aes(x = X,
                y = taxa.desocupacao.efeito.va),
            color = verde, size = 1.3

  ) +
  geom_line(aes(x = X,
                y = taxa.desocupacao.efeito.va.covid),
            color = "red", size = .5

  ) +
  theme_clean()+
  theme(#panel.grid = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=6, colour = azul),
    axis.text=element_text(size=4),
    axis.title = element_text(size=5)
  )


ppts <- pptx %>% ph_with(gg,
                         ph_location(6.92/2.54, 19.3/2.54, 6.66/2.54, 3.55/2.54),
                         bg = "transparent")
#salva slide ----
print(pptx, "03_Resultados/Relatorio.pptx")
