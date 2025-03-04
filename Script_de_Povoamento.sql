USE supermercado;

-- Inserir mais dados na tabela MATRIZ
INSERT INTO MATRIZ (CNPJ, Telefone, nome_fantasia, tipo)
VALUES
('12345678000100', '1122334455', 'Supermerc ado Central', 'Matriz'),
('98765432000100', '1199887766', 'Supermercado Norte', 'Matriz'),
('55555555000100', '1133334444', 'Supermercado Sul', 'Matriz'),
('66666666000100', '1144445555', 'Supermercado Leste', 'Matriz');

-- Inserir mais dados na tabela FILIAL
INSERT INTO FILIAL (ID, CPF_GERENTE, Endereco, Qtde_fun, Cnpj_Matriz)
VALUES
(1, '12345678901', 'Rua das Flores, 123', 50, '12345678000100'), #a quantidade de funcionaários não corresponde ao real
(2, '98765432109', 'Avenida dos Lagos, 456', 30, '98765432000100'),
(3, '11111111111', 'Rua das Palmeiras, 789', 40, '55555555000100'),
(4, '22222222222', 'Avenida das Acácias, 101', 60, '66666666000100');

-- Inserir mais dados na tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (CPF, id_Filial, Data_admissao, Sexo, Estado_Civil, Login, Senha, RG, Nome, Situação, Endereco)
VALUES
('12345678901', 1, '2020-01-15', 'M', 'Solteiro', 'joao.silva', 'senha123', '1234567890', 'João Silva', TRUE, 'Rua das Flores, 123'),
('98765432109', 2, '2019-05-20', 'F', 'Casado', 'maria.souza', 'senha456', '0987654321', 'Maria Souza', TRUE, 'Avenida dos Lagos, 456'),
('11111111111', 3, '2021-03-10', 'M', 'Divorciado', 'carlos.oliveira', 'senha789', '1111111111', 'Carlos Oliveira', TRUE, 'Rua das Palmeiras, 789'),
('22222222222', 4, '2022-07-25', 'F', 'Solteiro', 'ana.costa', 'senha101', '2222222222', 'Ana Costa', TRUE, 'Avenida das Acácias, 101'),
('33333333333', 1, '2023-02-14', 'M', 'Casado', 'pedro.santos', 'senha202', '3333333333', 'Pedro Santos', TRUE, 'Rua das Margaridas, 202'),
('33333333334', 4, '2023-02-14', 'M', 'Casado', 'entrega.teste', 'senha202', '3333333339', 'Vinicius santos', TRUE, 'Rua das Margaridas, 204');

-- Inserir mais dados na tabela GERENTE
INSERT INTO GERENTE (CPF)
VALUES
('12345678901'),
('98765432109'),
('11111111111'),
('22222222222');

-- Inserir mais dados na tabela ENTREGADOR
INSERT INTO ENTREGADOR (CPF)
VALUES
('12345678901'),
('98765432109'),
('33333333333'),
('33333333334');

-- Inserir mais dados na tabela FORNECEDOR
INSERT INTO FORNECEDOR (NomeFornecedor, CNPJ, Telefone, Ativo, Rua, Bairro, CEP, Estado)
VALUES
('Fornecedor A', '11111111000100', '1199999999', TRUE, 'Rua dos Fornecedores, 100', 'Centro', '12345678', 'SP'),
('Fornecedor B', '22222222000100', '1188888888', TRUE, 'Avenida das Indústrias, 200', 'Industrial', '87654321', 'RJ'),
('Fornecedor C', '33333333000100', '1177777777', TRUE, 'Rua das Fábricas, 300', 'Industrial', '54321678', 'MG'),
('Fornecedor D', '44444444000100', '1166666666', TRUE, 'Avenida dos Produtos, 400', 'Comercial', '87651234', 'RS');

-- Inserir mais dados na tabela CLIENTE
INSERT INTO CLIENTE (CPF, P_nome, M_nome, U_nome, RG, Telefone, CEP, Numero, Cidade, Descricao, DataNascimento, Email, DataCadastro, Senha, Vl_credito, id_filial)
VALUES
('11111111111', 'Carlos', 'Alberto', 'Silva', '1111111111', '1199999999', '12345678', '123', 'São Paulo', 'Casa 1', '1990-01-01', 'carlos.silva@email.com', '2023-01-01', 'senha123', 100.00, 1),
('22222222222', 'Ana', 'Maria', 'Santos', '2222222222', '1188888888', '87654321', '456', 'Rio de Janeiro', 'Apartamento 2', '1995-05-05', 'ana.santos@email.com', '2023-02-01', 'senha456', 200.00, 2),
('33333333333', 'Pedro', 'Henrique', 'Oliveira', '3333333333', '1177777777', '54321678', '789', 'Belo Horizonte', 'Casa 3', '1985-10-10', 'pedro.oliveira@email.com', '2023-03-01', 'senha789', 150.00, 3),
('44444444444', 'Juliana', 'Cristina', 'Costa', '4444444444', '1166666666', '87651234', '101', 'Porto Alegre', 'Apartamento 4', '1992-12-12', 'juliana.costa@email.com', '2023-04-01', 'senha101', 300.00, 4),
('66666666666', 'Maria', 'Fernanda', 'Silva', '6666666666', '1166666666', '12345678', '303', 'São Paulo', 'Casa 6', '1995-09-20', 'maria.silva@email.com', '2023-10-06', 'senha666', 600.00, 2);

-- Inserir mais dados na tabela ENTREGA
INSERT INTO ENTREGA (CPF_Entregador, Data_Entrega, Hora_Estimada)
VALUES
('12345678901', '2023-10-01', '14:00:00'),
('98765432109', '2023-10-02', '15:30:00'),
('33333333333', '2023-10-03', '16:00:00'),
('12345678901', '2023-10-04', '17:30:00');

-- Inserir mais dados na tabela COMPRA
INSERT INTO COMPRA (Seq_Entrega, Valor_Total, Data_Compra, Valor_Total_Desconto, Status_Compra, CPF_Cliente)
VALUES
(1, 150.00, '2023-10-01', 10.00, 'Pago', '11111111111'),
(2, 200.00, '2023-10-02', 20.00, 'Aguardando', '22222222222'),
(3, 250.00, '2023-10-03', 15.00, 'Cancelada', '33333333333'),
(4, 300.00, '2023-10-04', 25.00, 'Pago', '44444444444');

-- Inserir mais dados na tabela UNIDADE_PROD
INSERT INTO UNIDADE_PROD (Descricao, Sigla)
VALUES
('Quilograma', 'KG'),
('Litro', 'L'),
('Unidade', 'UN'),
('Metro', 'M');

-- Inserir mais dados na tabela MARCA_PROD
INSERT INTO MARCA_PROD (Descricao)
VALUES
('Marca A'),
('Marca B'),
('Marca C'),
('Marca D'),
('Marca teste'),
('Marca teste1');

-- Inserir mais dados na tabela CATEGORIA
INSERT INTO CATEGORIA (Descricao)
VALUES
('Alimentos'),
('Bebidas'),
('Limpeza'),
('Higiene');

-- Inserir mais dados na tabela SUBCATEGORIA
INSERT INTO SUBCATEGORIA (Cod_Categoria, Descricao)
VALUES
(1, 'Carnes'),
(2, 'Refrigerantes'),
(3, 'Detergentes'),
(4, 'Sabonetes'),
(1,'Massa'),
(2,'cerveja'),
(2,'vinho'),
(4,'Shampoo'),
(4,'Condicionador'),
(1,'Vegetais');

-- Inserir mais dados na tabela PRODUTO_REF
INSERT INTO PRODUTO_REF (Id_Unidade, Id_Marca, Id_SubCateg, cod_Fornecedor, Preco_por_tabela, Cod_barra, Freq_pedido, Qtd_estoque, Descricao, Qtd_min, Preco_ult_compra)
VALUES
(1, 1, 1, 1, 10.00, '1234567890123', 5, 100, 'Carne Bovina', 10, 9.50),
(2, 2, 2, 2, 5.00, '9876543210987', 10, 200, 'Refrigerante Cola', 20, 4.50),
(3, 3, 3, 3, 8.00, '5555555555555', 7, 150, 'Detergente Líquido', 15, 7.50),
(4, 4, 4, 4, 3.00, '6666666666666', 12, 300, 'Sabonete em Barra', 30, 2.50),
(1, 1, 10, 4, 10.00,6666666666667, 20, 300 ,'Cenoura grande','20',19.00),
(2, 2, 2, 2, 10.00,6666666666668, 20, 300 ,'Coca-cola','20',19.00),
(1, 4, 5, 1, 10.00, '1234567890124', 5, 100, 'Pizza de Queijo', 10, 9.50),
(2, 4, 8, 3, 3.00, '6666646666668', 12, 300, 'Shampo verde', 30, 2.50),
(2, 4, 9, 4, 3.00, '6666666666669', 12, 300, 'Condicionador Verde', 30, 2.50),
(2, 3, 7, 2, 5.00, '9876543210907', 10, 200, 'Vinho verde', 20, 4.50);
-- Inserir mais dados na tabela ESTOQUE
INSERT INTO ESTOQUE (id_Filial, descricao, dt_ult_Entrada)
VALUES
(1, 'Estoque Principal', '2023-10-01'),
(2, 'Estoque Secundário', '2023-10-02'),
(3, 'Estoque Terciário', '2023-10-03'),
(4, 'Estoque Quaternário', '2023-10-04');

-- Inserir mais dados na tabela ITEM_ESTOQUE
INSERT INTO ITEM_ESTOQUE (Id_Estoque, Cod_Prod, Data_Validade, Data_Fabricacao, Data_Entrada, Valor_Compra, qtd_atual, qtd_min)
VALUES
(1, 1, '2024-01-01', '2023-09-01', '2023-10-01', 9.50, 100, 10),
(2, 2, '2024-02-01', '2023-09-15', '2023-10-02', 4.50, 200, 20),
(3, 3, '2024-03-01', '2023-09-20', '2023-10-03', 7.50, 150, 15),
(4, 4, '2024-04-01', '2023-09-25', '2023-10-04', 2.50, 300, 30);

-- Inserir mais dados na tabela PERDA
INSERT INTO PERDA (data_Perda, Quantidade_perdida, Motivo, Id_Estoque, Cod_Prod)
VALUES
('2023-10-01', 5, 'Quebra', 1, 1),
('2023-10-02', 10, 'Vencimento', 2, 2),
('2023-10-03', 8, 'Quebra', 3, 3),
('2023-10-04', 12, 'Vencimento', 4, 4);

-- Inserir mais dados na tabela ITEMCOMPRA
INSERT INTO ITEMCOMPRA (Cod_compra, Cod_produto, Quantidade, Valor_desconto_item, Valor_unitario)
VALUES
(1, 1, 2, 1.00, 10.00),
(2, 2, 3, 1.50, 5.00),
(3, 3, 4, 2.00, 8.00),
(4, 4, 5, 1.00, 3.00);

-- Inserir mais dados na tabela TIPO_PAGAMENTO
INSERT INTO TIPO_PAGAMENTO (cod, descricao)
VALUES
(1, 'Cartão de Crédito'),
(2, 'Dinheiro'),
(3, 'Pix'),
(4, 'Cartão de Débito');

-- Inserir mais dados na tabela PEDIDO_FORNECEDOR
INSERT INTO PEDIDO_FORNECEDOR (CPF_gerente, Total_desconto, Valor_total_IPI, Valor_total, Data_Pedido_Fornecedor, Status_Pedido_Fornecedor, Valor_frete)
VALUES
('12345678901', 10.00, 5.00, 100.00, '2023-10-01', TRUE, 15.00),
('98765432109', 20.00, 10.00, 200.00, '2023-10-02', TRUE, 25.00),
('11111111111', 15.00, 7.00, 150.00, '2023-10-03', TRUE, 20.00),
('22222222222', 25.00, 12.00, 250.00, '2023-10-04', TRUE, 30.00);

-- Inserir mais dados na tabela FATURA
INSERT INTO FATURA (cod_Pedido_Fornecedor, dt_venc, vl_pago_atual, vl_total_final, dt_emissao, status_fatura, dt_paga, multa)
VALUES
(1, '2023-11-01', 50.00, 100.00, '2023-10-01', TRUE, '2023-10-05', 0.00),
(2, '2023-11-02', 100.00, 200.00, '2023-10-02', FALSE, NULL, 10.00),
(3, '2023-11-03', 75.00, 150.00, '2023-10-03', TRUE, '2023-10-06', 0.00),
(4, '2023-11-04', 125.00, 250.00, '2023-10-04', FALSE, NULL, 15.00);

-- Inserir mais dados na tabela PAGAMENTO
INSERT INTO PAGAMENTO (id_fatura, cod_compra, cod_tipo_pagamento, vl_pago, data_Pagamento, status_Pagamento)
VALUES
(1, 1, 1, 100.00, '2023-10-05', TRUE),
(2, 2, 2, 200.00, '2023-10-06', FALSE),
(3, 3, 3, 150.00, '2023-10-07', TRUE),
(4, 4, 4, 250.00, '2023-10-08', FALSE);

-- Inserir mais dados na tabela NOTA_FISCAL
INSERT INTO NOTA_FISCAL (NFE, ICMS, Valor_Total, Valor_Total_Desconto, data_NotaFiscal, Valor_Frete)
VALUES
('NFE123456789', 10.00, 150.00, 10.00, '2023-10-01', 15.00),
('NFE987654321', 20.00, 200.00, 20.00, '2023-10-02', 25.00),
('NFE555555555', 15.00, 250.00, 15.00, '2023-10-03', 20.00),
('NFE666666666', 25.00, 300.00, 25.00, '2023-10-04', 30.00);

-- Inserir mais dados na tabela NOTA_FISCAL_FORNECEDOR
INSERT INTO NOTA_FISCAL_FORNECEDOR (NFE, cod_pagamento, IPI)
VALUES
('NFE123456789', 1, 5.00),
('NFE987654321', 2, 10.00),
('NFE555555555', 3, 7.00),
('NFE666666666', 4, 12.00);

-- Inserir mais dados na tabela NOTA_FISCAL_COMPRA
INSERT INTO NOTA_FISCAL_COMPRA (NFE, cod_pagamento)
VALUES
('NFE123456789', 1),
('NFE987654321', 2),
('NFE555555555', 3),
('NFE666666666', 4);

-- Inserir mais dados na tabela ITEM_PEDIDO
INSERT INTO ITEM_PEDIDO (Cod_produto_ref, Cod_pedido_fornecedor, Quantidade, Preco_unitario)
VALUES
(1, 1, 10, 9.50),
(2, 2, 20, 4.50),
(3, 3, 15, 7.50),
(4, 4, 25, 2.50);