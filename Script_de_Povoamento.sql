USE Supermercado;

-- Inserir dados na tabela MATRIZ
INSERT INTO MATRIZ (CNPJ, Telefone, nome_fantasia, tipo)
VALUES 
('12345678000100', '1122334455', 'Supermercado Central', 'Matriz'),
('98765432000100', '1199887766', 'Supermercado Norte', 'Matriz');

-- Inserir dados na tabela FILIAL
INSERT INTO FILIAL (ID, CPF_GERENTE, Endereco, Qtde_fun, Cnpj_Matriz)
VALUES 
(1, '12345678901', 'Rua das Flores, 123', 50, '12345678000100'),
(2, '98765432109', 'Avenida dos Lagos, 456', 30, '98765432000100');

-- Inserir dados na tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (CPF, id_Filial, Data_admissao, Sexo, Estado_Civil, Login, Senha, RG, Nome, Situação, Endereco)
VALUES 
('12345678901', 1, '2020-01-15', 'M', 'Solteiro', 'joao.silva', 'senha123', '1234567890', 'João Silva', TRUE, 'Rua das Flores, 123'),
('98765432109', 2, '2019-05-20', 'F', 'Casado', 'maria.souza', 'senha456', '0987654321', 'Maria Souza', TRUE, 'Avenida dos Lagos, 456');

-- Inserir dados na tabela GERENTE
INSERT INTO GERENTE (CPF)
VALUES 
('12345678901'),
('98765432109');

-- Inserir dados na tabela ENTREGADOR
INSERT INTO ENTREGADOR (CPF)
VALUES 
('12345678901'),
('98765432109');

-- Inserir dados na tabela FORNECEDOR
INSERT INTO FORNECEDOR (NomeFornecedor, CNPJ, Telefone, Ativo, Rua, Bairro, CEP, Estado)
VALUES 
('Fornecedor A', '11111111000100', '1199999999', TRUE, 'Rua dos Fornecedores, 100', 'Centro', '12345678', 'SP'),
('Fornecedor B', '22222222000100', '1188888888', TRUE, 'Avenida das Indústrias, 200', 'Industrial', '87654321', 'RJ');

-- Inserir dados na tabela CLIENTE
INSERT INTO CLIENTE (CPF, P_nome, M_nome, U_nome, RG, Telefone, CEP, Numero, Cidade, Descricao, DataNascimento, Email, DataCadastro, Senha, Vl_credito, id_filial)
VALUES 
('11111111111', 'Carlos', 'Alberto', 'Silva', '1111111111', '1199999999', '12345678', '123', 'São Paulo', 'Casa 1', '1990-01-01', 'carlos.silva@email.com', '2023-01-01', 'senha123', 100.00, 1),
('22222222222', 'Ana', 'Maria', 'Santos', '2222222222', '1188888888', '87654321', '456', 'Rio de Janeiro', 'Apartamento 2', '1995-05-05', 'ana.santos@email.com', '2023-02-01', 'senha456', 200.00, 2);

-- Inserir dados na tabela ENTREGA
INSERT INTO ENTREGA (CPF_Entregador, Data_Entrega, Hora_Estimada)
VALUES 
('12345678901', '2023-10-01', '14:00:00'),
('98765432109', '2023-10-02', '15:30:00');

-- Inserir dados na tabela COMPRA
INSERT INTO COMPRA (Seq_Entrega, Valor_Total, Data_Compra, Valor_Total_Desconto, Status_Compra, CPF_Cliente)
VALUES 
(1, 150.00, '2023-10-01', 10.00, 'Pago', '11111111111'),
(2, 200.00, '2023-10-02', 20.00, 'Aguardando', '22222222222');

-- Inserir dados na tabela UNIDADE_PROD
INSERT INTO UNIDADE_PROD (Descricao, Sigla)
VALUES 
('Quilograma', 'KG'),
('Litro', 'L');

-- Inserir dados na tabela MARCA_PROD
INSERT INTO MARCA_PROD (Descricao)
VALUES 
('Marca A'),
('Marca B');

-- Inserir dados na tabela CATEGORIA
INSERT INTO CATEGORIA (Descricao)
VALUES 
('Alimentos'),
('Bebidas');

-- Inserir dados na tabela SUBCATEGORIA
INSERT INTO SUBCATEGORIA (Cod_Categoria, Descricao)
VALUES 
(1, 'Carnes'),
(2, 'Refrigerantes');

-- Inserir dados na tabela PRODUTO_REF
INSERT INTO PRODUTO_REF (Id_Unidade, Id_Marca, Id_SubCateg, cod_Fornecedor, Preco_por_tabela, Cod_barra, Freq_pedido, Qtd_estoque, Descricao, Qtd_min, Preco_ult_compra)
VALUES 
(1, 1, 1, 1, 10.00, '1234567890123', 5, 100, 'Carne Bovina', 10, 9.50),
(2, 2, 2, 2, 5.00, '9876543210987', 10, 200, 'Refrigerante Cola', 20, 4.50);

-- Inserir dados na tabela ESTOQUE
INSERT INTO ESTOQUE (id_Filial, descricao, dt_ult_Entrada)
VALUES 
(1, 'Estoque Principal', '2023-10-01'),
(2, 'Estoque Secundário', '2023-10-02');

-- Inserir dados na tabela ITEM_ESTOQUE
INSERT INTO ITEM_ESTOQUE (Id_Estoque, Cod_Prod, Data_Validade, Data_Fabricacao, Data_Entrada, Valor_Compra, qtd_atual, qtd_min)
VALUES 
(1, 1, '2024-01-01', '2023-09-01', '2023-10-01', 9.50, 100, 10),
(2, 2, '2024-02-01', '2023-09-15', '2023-10-02', 4.50, 200, 20);

-- Inserir dados na tabela PERDA
INSERT INTO PERDA (data_Perda, Quantidade_perdida, Motivo, Id_Estoque, Cod_Prod)
VALUES 
('2023-10-01', 5, 'Quebra', 1, 1),
('2023-10-02', 10, 'Vencimento', 2, 2);

-- Inserir dados na tabela ITEMCOMPRA
INSERT INTO ITEMCOMPRA (Cod_compra, Cod_produto, Quantidade, Valor_desconto_item, Valor_unitario)
VALUES 
(1, 1, 2, 1.00, 10.00),
(2, 2, 3, 1.50, 5.00);

-- Inserir dados na tabela TIPO_PAGAMENTO
INSERT INTO TIPO_PAGAMENTO (cod, descricao)
VALUES 
(1, 'Cartão de Crédito'),
(2, 'Dinheiro');

-- Inserir dados na tabela PEDIDO_FORNECEDOR
INSERT INTO PEDIDO_FORNECEDOR (CPF_gerente, Total_desconto, Valor_total_IPI, Valor_total, Data_Pedido_Forncedor, Status_Pedido_Forncedor, Valor_frete)
VALUES 
('12345678901', 10.00, 5.00, 100.00, '2023-10-01', TRUE, 15.00),
('98765432109', 20.00, 10.00, 200.00, '2023-10-02', TRUE, 25.00);

-- Inserir dados na tabela FATURA
INSERT INTO FATURA (cod_Pedido_Fornecedor, dt_venc, vl_pago_atual, vl_total_final, dt_emissao, status_fatura, dt_paga, multa)
VALUES 
(1, '2023-11-01', 50.00, 100.00, '2023-10-01', TRUE, '2023-10-05', 0.00),
(2, '2023-11-02', 100.00, 200.00, '2023-10-02', FALSE, NULL, 10.00);

-- Inserir dados na tabela PAGAMENTO
INSERT INTO PAGAMENTO (id_fatura, cod_compra, cod_tipo_pagamento, vl_pago, data_Pagamento, status_Pagamento)
VALUES 
(1, 1, 1, 100.00, '2023-10-05', TRUE),
(2, 2, 2, 200.00, '2023-10-06', FALSE);

-- Inserir dados na tabela NOTA_FISCAL
INSERT INTO NOTA_FISCAL (NFE, ICMS, Valor_Total, Valor_Total_Desconto, data_NotaFical, Valor_Frete)
VALUES 
('NFE123456789', 10.00, 150.00, 10.00, '2023-10-01', 15.00),
('NFE987654321', 20.00, 200.00, 20.00, '2023-10-02', 25.00);

-- Inserir dados na tabela NOTA_FISCAL_FORNECEDOR
INSERT INTO NOTA_FISCAL_FORNECEDOR (NFE, cod_pagamento, IPI)
VALUES 
('NFE123456789', 1, 5.00),
('NFE987654321', 2, 10.00);

-- Inserir dados na tabela NOTA_FISCAL_COMPRA
INSERT INTO NOTA_FISCAL_COMPRA (NFE, cod_pagamento)
VALUES 
('NFE123456789', 1),
('NFE987654321', 2);

-- Inserir dados na tabela ITEM_PEDIDO
INSERT INTO ITEM_PEDIDO (Cod_produto_ref, Cod_pedido_fornecedor, Quantidade, Preco_unitario)
VALUES 
(1, 1, 10, 9.50),
(2, 2, 20, 4.50);