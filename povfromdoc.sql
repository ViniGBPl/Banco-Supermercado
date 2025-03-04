DELIMITER //

CREATE FUNCTION load_csv(nome_tabela VARCHAR(24), caminho_arquivo VARCHAR(255))
RETURNS TEXT
NOT DETERMINISTIC
BEGIN
  DECLARE query_loader TEXT;

  SET query_loader = CONCAT(
    "LOAD DATA INFILE '", caminho_arquivo, "' ",
        "INTO TABLE ", nome_tabela,
        "FIELDS TERMINATED BY ',' ",
        "ENCLOSED BY '\' ",
        "LINES TERMINATED BY '\n' ",
        "IGNORE 1 ROWS;"
  );


  PREPARE data FROM query_loader;
  EXECUTE data;
  DEALLOCATE PREPARE data;
  RETURN CONCAT("Dados carregados na tabela ", nome_tabela, " com sucesso!!");

END //

DELIMITER ;

-- Carregar dados na tabela MATRIZ
SELECT load_csv('MATRIZ', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/matriz.csv');

-- Carregar dados na tabela FILIAL
SELECT load_csv('FILIAL', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/filial.csv');

-- Carregar dados na tabela FUNCIONARIO
SELECT load_csv('FUNCIONARIO', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/funcionario.csv');

-- Carregar dados na tabela FORNECEDOR
SELECT load_csv('FORNECEDOR', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/fornecedor.csv');

-- Carregar dados na tabela CLIENTE
SELECT load_csv('CLIENTE', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/cliente.csv');

-- Carregar dados na tabela PRODUTO_REF
SELECT load_csv('PRODUTO_REF', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/produto_ref.csv');

-- Carregar dados na tabela ESTOQUE
SELECT load_csv('ESTOQUE', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/estoque.csv');

-- Carregar dados na tabela ITEM_ESTOQUE
SELECT load_csv('ITEM_ESTOQUE', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/item_estoque.csv');

-- Carregar dados na tabela COMPRA
SELECT load_csv('COMPRA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/compra.csv');

-- Carregar dados na tabela ITEMCOMPRA
SELECT load_csv('ITEMCOMPRA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/item_compra.csv');

-- Carregar dados na tabela ENTREGA
SELECT load_csv('ENTREGA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/entrega.csv');

-- Carregar dados na tabela PEDIDO_FORNECEDOR
SELECT load_csv('PEDIDO_FORNECEDOR', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/pedido_fornecedor');

-- Carregar dados na tabela FATURA
SELECT load_csv('FATURA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/fatura.csv');

-- Carregar dados na tabela PAGAMENTO
SELECT load_csv('PAGAMENTO', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/pagamento.csv');

-- Carregar dados na tabela NOTA_FISCAL
SELECT load_csv('NOTA_FISCAL', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/nota_fiscal.csv');

-- Carregar dados na tabela NOTA_FISCAL_FORNECEDOR
SELECT load_csv('NOTA_FISCAL_FORNECEDOR', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/nota_fiscal_fornecedor.csv');

-- Carregar dados na tabela NOTA_FISCAL_COMPRA
SELECT load_csv('NOTA_FISCAL_COMPRA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/nota_fical_compra.csv');

-- Carregar dados na tabela ITEM_PEDIDO
SELECT load_csv('ITEM_PEDIDO', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/item_pedido.csv');

-- Carregar dados na tabela UNIDADE_PROD
SELECT load_csv('UNIDADE_PROD', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/unidade_prod.csv');

-- Carregar dados na tabela MARCA_PROD
SELECT load_csv('MARCA_PROD', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/marca_prod.csv');

-- Carregar dados na tabela CATEGORIA
SELECT load_csv('CATEGORIA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/categoria.csv');

-- Carregar dados na tabela SUBCATEGORIA
SELECT load_csv('SUBCATEGORIA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/subcategoria.csv');

-- Carregar dados na tabela GERENTE
SELECT load_csv('GERENTE', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/gerente.csv');

-- Carregar dados na tabela ENTREGADOR
SELECT load_csv('ENTREGADOR', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/entregador.csv');

-- Carregar dados na tabela TIPO_PAGAMENTO
SELECT load_csv('TIPO_PAGAMENTO', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/tipo_pagamento.csv');

-- Carregar dados na tabela PERDA
SELECT load_csv('PERDA', '/home/seabroso/Documents/projetos/Banco-Supermercado/csvdata/perda.csv');

