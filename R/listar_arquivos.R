dirs = list.dirs(r"(F:\USERS\GERAT\COOCA\ADMINISTRATIVO\ATIVIDADE DE ROTINA\ASSESSORIAS)")

dirs_estoque = dirs[grepl("Estoque", dirs)]

lista_estoque = lapply(dirs_estoque, list.files)

caminhos_estoque = vector(mode="list", length(dirs_estoque))


for (i in seq_along(dirs_estoque)) {

  for (j in seq_along(lista_estoque[[i]])) {

    caminhos_estoque[[i]][j] = paste0(dirs_estoque[i], "/", lista_estoque[[i]][j])

  }
}

lista_estoque_excel = caminhos_estoque[1:7]
lista_estoque_txt = caminhos_estoque[8:12]

data_excel = lapply(unlist(lista_estoque_excel), function(x) {

  readxl::read_excel(x)
})

data_txt = lapply(unlist(lista_estoque_txt), function(x) {

  gc()
  readr::read_delim(x, "\t", locale = locale(encoding = "LATIN1")) %>%
    filter(`Status com Assessoria` == "Encaminhado") %>%
    mutate(`Mínimo p/ Recebimento GERAL` = as.numeric(gsub(",", ".", gsub("\\.", "", `Mínimo p/ Recebimento GERAL`)))) %>%
    group_by(Assessoria) %>%
    summarise(qtd_contratos = n(),
              media_saldo = mean(`Mínimo p/ Recebimento GERAL`))

})

data = append(data_excel, data_txt)

# 12/2015 tem um Excel com os dados da extração completa e deve ser tratado como um .txt
# Descobrir qual índice e executar o código abaixo (antes ficava no 86, mas tabelas serão deletadas)

data[[86]] = data[[86]] %>%
  filter(`Status com Assessoria` == "Encaminhado") %>%
  mutate(`Mínimo p/ Recebimento GERAL` = as.numeric(gsub(",", ".", gsub("\\.", "", `Mínimo p/ Recebimento GERAL`)))) %>%
  group_by(Assessoria) %>%
  summarise(qtd_contratos = n(),
            media_saldo = mean(`Mínimo p/ Recebimento GERAL`))


teste = lapply(data[10:11], function(x) {

  x %>%
    filter(`Situação` == "Ativa") %>%
    mutate(media_saldo = `Valor Total` / `Qtd. Total de Dívidas`) %>%
    select(Assessoria, "qtd_contratos" = `Qtd. Total de Dívidas`, media_saldo)

})
