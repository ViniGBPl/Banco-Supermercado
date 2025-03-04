CREATE OR REPLACE VIEW View_Relatorio_Compra_Produtos AS
SELECT  
    COMPRA.Cod AS Codigo_Compra,
    COMPRA.Data_Compra,
    ITEMCOMPRA.Cod_produto AS Codigo_Produto,
    PRODUTO_REF.Descricao AS Nome_Produto,
    MARCA_PROD.Descricao AS Marca,
    CATEGORIA.Descricao AS Categoria,
    SUBCATEGORIA.Descricao AS Subcategoria,
    ITEMCOMPRA.Quantidade,
    ITEMCOMPRA.Valor_unitario AS Preco_Unitario,
    (ITEMCOMPRA.Quantidade * ITEMCOMPRA.Valor_unitario) AS Valor_Total
FROM 
    COMPRA
JOIN 
    ITEMCOMPRA ON COMPRA.Cod = ITEMCOMPRA.Cod_compra
JOIN 
    PRODUTO_REF ON ITEMCOMPRA.Cod_produto = PRODUTO_REF.Cod
JOIN 
    MARCA_PROD ON PRODUTO_REF.Id_Marca = MARCA_PROD.Cod
JOIN 
    SUBCATEGORIA ON PRODUTO_REF.Id_SubCateg = SUBCATEGORIA.Cod
JOIN 
    CATEGORIA ON SUBCATEGORIA.Cod_Categoria = CATEGORIA.Cod;

-- Criação da Stored Procedure
DROP PROCEDURE IF EXISTS Relatorio_Compra_Produtos_Por_Data;

DELIMITER //

CREATE PROCEDURE Relatorio_Compra_Produtos_Por_Data(
    IN data_inicio DATE,
    IN data_fim DATE
)
BEGIN
    SELECT * 
    FROM View_Relatorio_Compra_Produtos
    WHERE Data_Compra BETWEEN data_inicio AND data_fim;
END //

-- Testar a procedure para compras em 2023
CALL Relatorio_Compra_Produtos_Por_Data('2023-01-01', '2023-12-31');

-- Testar a procedure para compras em 2024
CALL Relatorio_Compra_Produtos_Por_Data('2024-01-01', '2024-12-31');


###Relatório de PEDIDO_FORNECEDOR por FATURA, TIPO_PAGAMENTO,  NF_FORNECEDOR, E GERENTE

CREATE OR REPLACE VIEW View_Relatorio_Pedido_Fornecedor AS
SELECT  
    PEDIDO_FORNECEDOR.Cod,
    PEDIDO_FORNECEDOR.Data_Pedido_Fornecedor AS Data_Pedido,
    PEDIDO_FORNECEDOR.Valor_total,
    FATURA.id,
    FATURA.dt_venc,
    FATURA.vl_total_final,
    TIPO_PAGAMENTO.descricao,
    NOTA_FISCAL_FORNECEDOR.NFE,
    FUNCIONARIO.Nome AS Nome_Gerente -- Adicionado o nome do gerente
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
    GERENTE ON PEDIDO_FORNECEDOR.CPF_gerente = GERENTE.CPF
LEFT JOIN 
    FUNCIONARIO ON GERENTE.CPF = FUNCIONARIO.CPF; -- Relacionamento corrigido


##Relatório de PRODUTOS e suas AVARIAS em ESTOQUE parametrizado  por 2 datas do período e o código do ESTOQUE

DELIMITER //

CREATE PROCEDURE GerarRelatorioProdutosPerdas(
    IN Data_Inicio DATE,
    IN Data_Fim DATE,
    IN Cod_Estoque INT
)
BEGIN
    SELECT  
        PRODUTO_REF.Cod AS Codigo_Produto,
        PRODUTO_REF.Descricao AS Descricao_Produto,
        MARCA_PROD.Descricao AS Marca_Produto,
        UNIDADE_PROD.Sigla AS Unidade_Medida,
        ESTOQUE.id_estoque AS Codigo_Estoque,
        ESTOQUE.descricao AS Descricao_Estoque,
        PERDA.id AS Codigo_Perda,
        PERDA.data_Perda AS Data_da_Perda,
        PERDA.Quantidade_perdida AS Quantidade_Perdida,
        PERDA.Motivo AS Motivo_da_Perda
    FROM 
        PRODUTO_REF
    JOIN 
        ITEM_ESTOQUE ON PRODUTO_REF.Cod = ITEM_ESTOQUE.Cod_Prod
    JOIN 
        ESTOQUE ON ITEM_ESTOQUE.Id_Estoque = ESTOQUE.id_estoque
    JOIN 
        PERDA ON ITEM_ESTOQUE.Id_Estoque = PERDA.Id_Estoque 
               AND ITEM_ESTOQUE.Cod_Prod = PERDA.Cod_Prod
    LEFT JOIN 
        MARCA_PROD ON PRODUTO_REF.Id_Marca = MARCA_PROD.Cod
    LEFT JOIN 
        UNIDADE_PROD ON PRODUTO_REF.Id_Unidade = UNIDADE_PROD.Cod
    WHERE 
        PERDA.data_Perda BETWEEN Data_Inicio AND Data_Fim
        AND ESTOQUE.id_estoque = Cod_Estoque;
END //

DELIMITER ;



## Relatório proposto 


CREATE OR REPLACE VIEW View_Relatorio_Vendas_Produto AS
SELECT 
    COMPRA.Cod AS Codigo_Compra,
    COMPRA.Data_Compra,
    CLIENTE.P_nome AS Cliente_Nome, -- Use P_nome, M_nome e U_nome para o nome completo
    CLIENTE.Email AS Cliente_Email,
    ITEMCOMPRA.Cod_produto AS Codigo_Produto,
    ITEMCOMPRA.Quantidade,
    ITEMCOMPRA.Valor_unitario AS Preco_Unitario, -- Corrigido para Valor_unitario
    (ITEMCOMPRA.Quantidade * ITEMCOMPRA.Valor_unitario) AS Valor_Total_Compra
FROM 
    COMPRA
INNER JOIN 
    ITEMCOMPRA ON COMPRA.Cod = ITEMCOMPRA.Cod_compra
INNER JOIN 
    CLIENTE ON COMPRA.CPF_Cliente = CLIENTE.CPF; -- Corrigido para CPF_Cliente


SELECT * FROM View_Relatorio_Pedido_Fornecedor;

SELECT * FROM View_Relatorio_Vendas_Produto;
