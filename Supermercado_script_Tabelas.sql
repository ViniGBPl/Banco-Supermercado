
CREATE DATABASE supermercado;
USE supermercado;


-- Criação da tabela MATRIZ
CREATE TABLE MATRIZ (
    CNPJ VARCHAR(20) NOT NULL UNIQUE PRIMARY KEY,
    Telefone VARCHAR(12) NOT NULL,
    nome_fantasia VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) NOT NULL
);

-- Criação da tabela FILIAL
CREATE TABLE FILIAL (
    ID INT NOT NULL UNIQUE PRIMARY KEY,
    CPF_GERENTE VARCHAR(11),
    Endereco VARCHAR(200),
    Qtde_fun INT,
    Cnpj_Matriz VARCHAR(20),
    FOREIGN KEY (Cnpj_Matriz) REFERENCES MATRIZ(CNPJ)
);

-- Criação da tabela FUNCIONARIO
CREATE TABLE FUNCIONARIO (
    CPF CHAR(11) NOT NULL UNIQUE PRIMARY KEY,
    id_Filial INT,
    Data_admissao DATE,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
    Estado_Civil VARCHAR(20),
    Login VARCHAR(100) NOT NULL,
    Senha VARCHAR(100) NOT NULL,
    RG CHAR(10) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Situação BOOLEAN NOT NULL,
    Endereco VARCHAR(2000),
    FOREIGN KEY (id_Filial) REFERENCES FILIAL(ID)
);





CREATE TABLE FORNECEDOR (
    Cod INT AUTO_INCREMENT PRIMARY KEY, ##  mudei IdFornecedor para Cod
    NomeFornecedor VARCHAR(100) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE,
    Telefone VARCHAR(15), #Esse está representado só no modelo ER
    Ativo BOOLEAN, # Para saber se o fornecedor está ativo
    Rua VARCHAR(100),
	Bairro VARCHAR(100) ,
    CEP VARCHAR(20) , # Trocar por um do tipo char
    Estado VARCHAR(20)

);




CREATE TABLE GERENTE(
	CPF CHAR(11) NOT NULL UNIQUE PRIMARY KEY,
	FOREIGN KEY(CPF) REFERENCES FUNCIONARIO(CPF)
);

CREATE TABLE ENTREGADOR(
	CPF CHAR(11) NOT NULL UNIQUE PRIMARY KEY,
	FOREIGN KEY(CPF) REFERENCES FUNCIONARIO(CPF)
);



CREATE TABLE CLIENTE (
    CPF CHAR(11) NOT NULL PRIMARY KEY, -- Chave primária
    P_nome VARCHAR(100) NOT NULL,
    M_nome VARCHAR(100),
    U_nome VARCHAR(100),
    RG VARCHAR(10) NOT NULL,
    Telefone VARCHAR(15),
    CEP CHAR(8),
    Numero VARCHAR(5),
    Cidade VARCHAR(20),
    Descricao VARCHAR(100),
    DataNascimento DATE NOT NULL,
    Email VARCHAR(50),
    DataCadastro DATE NOT NULL,
    Senha VARCHAR(200),
    Vl_credito DECIMAL(10,2),
    id_filial INT,
    FOREIGN KEY (id_filial) REFERENCES FILIAL(ID)
);

CREATE TABLE ENTREGA (
    Seq INT AUTO_INCREMENT PRIMARY KEY UNIQUE, -- Chave primária
    CPF_Entregador CHAR(11) NOT NULL, -- Chave estrangeira para ENTREGADOR
    Data_Entrega DATE NOT NULL, -- Data da entrega
    Hora_Estimada TIME NOT NULL, -- Hora estimada da entrega
    FOREIGN KEY (CPF_Entregador) REFERENCES ENTREGADOR(CPF) -- Chave estrangeira
);

CREATE TABLE COMPRA(
	Cod INT AUTO_INCREMENT PRIMARY KEY UNIQUE,
    Seq_Entrega INT NOT NULL,
    Valor_Total DECIMAL(10,2) NOT NULL,
	Data_Compra DATE NOT NULL,
    Valor_Total_Desconto DECIMAL(10,2), # Talvez tenha que fazer um procedure ou um trigh para calcular esse desconto
    Status_Compra ENUM('Pago', 'Aguardando', 'Cancelada'), # tem que definir quais seriam os tipos ENUM, mas também acho que poderia usar um BOOLEAN
    CPF_Cliente CHAR(11) NOT NULL,

    FOREIGN KEY (CPF_Cliente) REFERENCES CLIENTE(CPF)

);

CREATE TABLE UNIDADE_PROD (
    Cod INT AUTO_INCREMENT PRIMARY KEY, -- Chave primária
    Descricao VARCHAR(200),
    Sigla VARCHAR(4)
);

CREATE TABLE MARCA_PROD (
    Cod INT AUTO_INCREMENT PRIMARY KEY, -- Chave primária
    Descricao VARCHAR(200)
);

CREATE TABLE CATEGORIA(
	Cod INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(200)

);

CREATE TABLE SUBCATEGORIA (
    Cod INT AUTO_INCREMENT PRIMARY KEY, -- Chave primária
    Cod_Categoria INT,
    Descricao VARCHAR(200),
    FOREIGN KEY (Cod_Categoria) REFERENCES CATEGORIA(Cod)
);



CREATE TABLE PRODUTO_REF (
    Cod INT AUTO_INCREMENT PRIMARY KEY, -- Chave primária
    Id_Unidade INT NOT NULL,
    Id_Marca INT NOT NULL,
    Id_SubCateg INT NOT NULL,
    cod_Fornecedor INT NOT NULL,
    Preco_por_tabela DECIMAL(10,2),
    Cod_barra VARCHAR(20) UNIQUE,
    Freq_pedido INT NOT NULL,
    Qtd_estoque INT,
    Descricao VARCHAR(200),
    Qtd_min INT,
    Preco_ult_compra DECIMAL(10,2),
    FOREIGN KEY (Id_Unidade) REFERENCES UNIDADE_PROD(Cod),
    FOREIGN KEY (Id_Marca) REFERENCES MARCA_PROD(Cod),
    FOREIGN KEY (Id_SubCateg) REFERENCES SUBCATEGORIA(Cod),
    FOREIGN KEY (cod_Fornecedor) REFERENCES FORNECEDOR(Cod)
);

CREATE TABLE ESTOQUE (
	id_estoque INT AUTO_INCREMENT PRIMARY KEY NOT NULL UNIQUE,# no modelo que o professor passou, está mostrando tudo junto
    id_Filial INT,
    descricao VARCHAR(250),
    dt_ult_Entrada DATE NOT NULL,

    FOREIGN KEY(id_Filial) REFERENCES FILIAL(ID)

);

CREATE TABLE ITEM_ESTOQUE (
    Id_Estoque INT NOT NULL,
    Cod_Prod INT NOT NULL,
    Data_Validade DATE NOT NULL,
    Data_Fabricacao DATE NOT NULL,
    Data_Entrada DATE NOT NULL,
    Valor_Compra DECIMAL(10,2),
    qtd_atual INT,
    qtd_min INT,

    PRIMARY KEY (Id_Estoque, Cod_Prod), -- Chave primária composta
    FOREIGN KEY (Id_Estoque) REFERENCES ESTOQUE(id_estoque),
    FOREIGN KEY (Cod_Prod) REFERENCES PRODUTO_REF(Cod)
);

CREATE TABLE PERDA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_Perda DATE NOT NULL,
    Quantidade_perdida INT NOT NULL,
    Motivo VARCHAR(255),
    Id_Estoque INT NOT NULL,
    Cod_Prod INT NOT NULL,
    FOREIGN KEY (Id_Estoque, Cod_Prod) REFERENCES ITEM_ESTOQUE(Id_Estoque, Cod_Prod)
);



CREATE TABLE ITEMCOMPRA (
    Cod_compra INT,
    Cod_produto INT,
    Quantidade INT NOT NULL,
    Valor_desconto_item DECIMAL(10,2),
    Valor_unitario DECIMAL(10,2),

    PRIMARY KEY (Cod_compra, Cod_produto), -- Chave primária composta
    FOREIGN KEY (Cod_compra) REFERENCES COMPRA(Cod),
    FOREIGN KEY (Cod_produto) REFERENCES PRODUTO_REF(Cod)
);

CREATE TABLE TIPO_PAGAMENTO (
	cod INT PRIMARY KEY, # ESSE TALVEZ SEJA MELHOR USAR UM ENUM PARA DEFINIR OS CODIGO , LOGO DEVE SER MUDADO O ESSE TIPO INT
	descricao VARCHAR(200)
);





-- Criar a tabela PEDIDO_FORNECEDOR
CREATE TABLE PEDIDO_FORNECEDOR (
    Cod INT AUTO_INCREMENT PRIMARY KEY,
    CPF_gerente CHAR(11),
    Total_desconto DECIMAL(10,2),
    Valor_total_IPI DECIMAL(10,2),
    Valor_total DECIMAL(10,2),
    Data_Pedido_Forncedor DATE,
    Status_Pedido_Forncedor BOOLEAN,
    Valor_frete DECIMAL(10,2),
    FOREIGN KEY (CPF_gerente) REFERENCES GERENTE(CPF)
);

-- Criar a tabela FATURA
CREATE TABLE FATURA (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Chave primária
    cod_Pedido_Fornecedor INT NOT NULL, -- Chave estrangeira para PEDIDO_FORNECEDOR
    dt_venc DATE, -- Data de vencimento da fatura
    vl_pago_atual DECIMAL(10,2), -- Valor pago até o momento
    vl_total_final DECIMAL(10,2), -- Valor total da fatura
    dt_emissao DATE, -- Data de emissão da fatura
    status_fatura BOOLEAN, -- Status da fatura (paga/não paga)
    dt_paga DATE, -- Data de pagamento da fatura
    multa DECIMAL(10,2), -- Valor da multa (se houver)
    FOREIGN KEY (cod_Pedido_Fornecedor) REFERENCES PEDIDO_FORNECEDOR(Cod) -- Chave estrangeira
);

CREATE TABLE PAGAMENTO (
	Cod INT AUTO_INCREMENT PRIMARY KEY,
    id_fatura INT NOT NULL,
    cod_compra INT NOT NULL,
    cod_tipo_pagamento INT NOT NULL,
    vl_pago DECIMAL(10,2) NOT NULL,
    data_Pagamento DATE , # Mude de data para data_Pagamento
    status_Pagamento BOOLEAN , #Mudei de status para status_pagamento, talvez seja necessário usar o tipo ENUM nesse

	FOREIGN KEY(id_fatura) REFERENCES FATURA (id),
	FOREIGN KEY(cod_compra) REFERENCES COMPRA (cod),
	FOREIGN KEY(cod_tipo_pagamento) REFERENCES TIPO_PAGAMENTO (cod)
);


CREATE TABLE NOTA_FISCAL (
	NFE VARCHAR(50) PRIMARY KEY,
    ICMS DECIMAL(10,2) NOT NULL,

    #nesse de baixo, usei as regras de negocio passadas pelo chat, talvez seja necessário validar.
    Valor_Total DECIMAL(10,2) NOT NULL CHECK (Valor_Total >= 0),
    Valor_Total_Desconto DECIMAL(10,2) CHECK (Valor_Total_Desconto >= 0),
    data_NotaFiscal DATE NOT NULL,
    Valor_Frete DECIMAL(10,2) CHECK (Valor_Frete >= 0)
);

CREATE TABLE NOTA_FISCAL_FORNECEDOR(
	NFE VARCHAR(50) PRIMARY KEY,
    cod_pagamento INT NOT NULL,
    IPI DECIMAL(10,2) NOT NULL CHECK (IPI >= 0), #REGRA DE NEGOCIO DO CHAT

	FOREIGN KEY (NFE) REFERENCES NOTA_FISCAL (NFE), # MUDEI DE Nota fiscal PARA NOTA_FISCAL
	FOREIGN KEY (cod_pagamento ) REFERENCES PAGAMENTO (cod )

);

CREATE TABLE NOTA_FISCAL_COMPRA(
	NFE VARCHAR(50) PRIMARY KEY NOT NULL,
	cod_pagamento INT NOT NULL,

	FOREIGN KEY ( NFE) REFERENCES NOTA_FISCAL (NFE), #MUDEI DE Nota fiscal para NOTA_FISCAL
	FOREIGN KEY (cod_pagamento) REFERENCES PAGAMENTO (Cod)
);


CREATE TABLE ITEM_PEDIDO (
    Cod_produto_ref INT,
    Cod_pedido_fornecedor INT,
    Quantidade INT NOT NULL,
    Preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Cod_produto_ref, Cod_pedido_fornecedor), -- Chave primária composta
    FOREIGN KEY (Cod_produto_ref) REFERENCES PRODUTO_REF(Cod),
    FOREIGN KEY (Cod_pedido_fornecedor) REFERENCES PEDIDO_FORNECEDOR(Cod)
);

#O QUE FOI FEITO COM BASE NO MODELO LOGICO RELACIONAL




DELIMITER //

CREATE PROCEDURE AtualizarEstoqueAposVenda(
    IN p_IdProduto INT,
    IN p_QuantidadeVendida INT
)
BEGIN
    UPDATE Produto
    SET QuantidadeEstoque = QuantidadeEstoque - p_QuantidadeVendida
    WHERE IdProduto = p_IdProduto;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE RegistrarMovimentacaoEstoque(
    IN TipoMovimentacao ENUM('Entrada', 'Saída'),
    IN DataMovimentacao DATE,
    IN Quantidade INT,
    IN Origem VARCHAR(255),
    IN IdProduto INT
)
BEGIN
    INSERT INTO MovimentacaoEstoque (TipoMovimentacao, DataMovimentacao, Quantidade, Origem, IdProduto)
    VALUES (TipoMovimentacao, DataMovimentacao, Quantidade, Origem, IdProduto);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ListarVendasCliente(
    IN IdCliente INT
)
BEGIN
    SELECT * FROM Venda
    WHERE IdCliente = IdCliente;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AdicionarProduto(
    IN NomeProduto VARCHAR(100),
    IN Categoria VARCHAR(50),
    IN Preco DECIMAL(10, 2),
    IN QuantidadeEstoque INT,
    IN DataValidade DATE,
    IN IdFornecedor INT,
    IN IdSetor INT
)
BEGIN
    INSERT INTO Produto (NomeProduto, Categoria, Preco, QuantidadeEstoque, DataValidade, IdFornecedor, IdSetor)
    VALUES (NomeProduto, Categoria, Preco, QuantidadeEstoque, DataValidade, IdFornecedor, IdSetor);
END //

