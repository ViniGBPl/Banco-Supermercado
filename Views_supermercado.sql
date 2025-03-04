DROP VIEW IF EXISTS View_Relatorio_Compra_Produtos;
DROP VIEW IF EXISTS View_Relatorio_Pedido_Fornecedor;

CREATE VIEW View_Relatorio_Compra_Produtos AS
SELECT  
    COMPRA.Cod AS Codigo_Compra,
    COMPRA.Data_Compra,
    ITEMCOMPRA.Cod_Prod AS Codigo_Produto,
    PRODUTO.Nome AS Nome_Produto,
    MARCA.Nome AS Marca,
    CATEGORIA.Nome AS Categoria,
    SUBCATEGORIA.Nome AS Subcategoria,
    ITEMCOMPRA.Quantidade,
    ITEMCOMPRA.Preco_Unitario,
    (ITEMCOMPRA.Quantidade * ITEMCOMPRA.Preco_Unitario) AS Valor_Total
FROM 
    COMPRA
JOIN 
    ITEMCOMPRA ON COMPRA.Cod = ITEMCOMPRA.Cod_Compra
JOIN 
    PRODUTO ON ITEMCOMPRA.Cod_Prod = PRODUTO.Cod
JOIN 
    MARCA ON PRODUTO.Cod_Marca = MARCA.Cod
JOIN 
    CATEGORIA ON PRODUTO.Cod_Categoria = CATEGORIA.Cod
JOIN 
    SUBCATEGORIA ON PRODUTO.Cod_Subcategoria = SUBCATEGORIA.Cod;

CREATE VIEW View_Relatorio_Pedido_Fornecedor AS
SELECT  
    PEDIDO_FORNECEDOR.Cod,
    PEDIDO_FORNECEDOR.Data_Pedido_Fornecedor,
    PEDIDO_FORNECEDOR.Valor_total,
    FATURA.id,
    FATURA.dt_venc,
    FATURA.vl_total_final,
    TIPO_PAGAMENTO.descricao,
    NOTA_FISCAL_FORNECEDOR.NFE,
    PEDIDO_FORNECEDOR.CPF_gerente
FROM 
    PEDIDO_FORNECEDOR
LEFT JOIN 
    FATURA ON PEDIDO_FORNECEDOR.Cod = FATURA.cod_Pedido_Fornecedor
LEFT JOIN 
    PAGAMENTO ON FATURA.id = PAGAMENTO.id_fatura
LEFT JOIN 
    TIPO_PAGAMENTO ON PAGAMENTO.cod_tipo_pagamento = TIPO_PAGAMENTO.cod
LEFT JOIN 
    NOTA_FISCAL_FORNECEDOR ON PAGAMENTO.cod = NOTA_FISCAL_FORNECEDOR.cod_pagamento
LEFT JOIN 
    GERENTE ON PEDIDO_FORNECEDOR.CPF_gerente = GERENTE.CPF;

CREATE VIEW View_Relatorio_Vendas_Produto AS
SELECT 
    COMPRA.Cod AS Codigo_Compra,
    COMPRA.Data_Compra,
    CLIENTE.Nome AS Cliente_Nome,
    CLIENTE.Email AS Cliente_Email,
    ITEMCOMPRA.Cod_Produto AS Codigo_Produto,
    ITEMCOMPRA.Quantidade,
    ITEMCOMPRA.Preco_Unitario,
    (ITEMCOMPRA.Quantidade * ITEMCOMPRA.Preco_Unitario) AS Valor_Total_Compra
FROM 
    COMPRA
INNER JOIN 
    ITEMCOMPRA ON COMPRA.Cod = ITEMCOMPRA.Cod_Compra
INNER JOIN 
    CLIENTE ON COMPRA.Cod_Cliente = CLIENTE.Cod;


SELECT * FROM View_Relatorio_Compra_Produtos
WHERE Data_Compra BETWEEN '2024-01-01' AND '2024-12-31';

SELECT * FROM View_Relatorio_Pedido_Fornecedor;

SELECT * FROM View_Relatorio_Vendas_Produto
WHERE Data_Compra BETWEEN '2024-01-01' AND '2024-12-31';