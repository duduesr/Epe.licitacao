leitura.despesa.detalhada <- function(municipio, ano){
  #municipio: municipio escolhido
  #ano: ano da despesa

  #url de download
  url = paste0("https://transparencia.tce.sp.gov.br/sites/default/files/csv/despesas-",municipio,"-",ano,".zip")


  if (!RCurl::url.exists(url)){
    print("Ocorreu algum erro!URL nao existe")
    return(db = NULL)
  }else{

    #destino do arquivo
    destino = tempfile(fileext = ".zip")
    #fazendo o download
    teste.download <- utils::download.file(url, destfile = destino)
    class(teste.download)
    #testando se deu certo
    destino.csv = "auxiliar"
    utils::unzip(zipfile = destino,  exdir = destino.csv)
    #leitura do banco
    arq.csv = paste0(destino.csv,"//",list.files(destino.csv))
    db <-  utils::read.csv2(arq.csv)
    unlink("auxiliar", recursive = TRUE)
    return(db)
  }
}

lista.municipios <- function(){
  return(jsonlite::fromJSON("https://transparencia.tce.sp.gov.br/api/json/municipios"))
}
