dirs = list.dirs(r"(F:\USERS\GERAT\COOCA\ADMINISTRATIVO\ATIVIDADE DE ROTINA\ASSESSORIAS)")

dirs_estoque = dirs[grepl("Estoque", dirs)]

lista_estoque = lapply(dirs_estoque, list.files)

caminhos_estoque = vector(mode="list", length(dirs_estoque))


for (i in seq_along(dirs_estoque)) {

  for (j in seq_along(lista_estoque[[i]])) {

    caminhos_estoque[[i]][j] = paste0(dirs_estoque[i], "/", lista_estoque[[i]][j])

  }
}

lista_estoque_curta = lista_estoque[1:7]


lapply(lista_estoque, cat)
