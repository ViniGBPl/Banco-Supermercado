
CREATE DATABASE Supermercado;
USE Supermercado;




CREATE TABLE Setor (
    IdSetor INT AUTO_INCREMENT PRIMARY KEY,
    NomeSetor VARCHAR(50) NOT NULL
);


CREATE TABLE Produto (
    IdProduto INT AUTO_INCREMENT PRIMARY KEY,
    NomeProduto VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50),
    Preco DECIMAL(10, 2) NOT NULL CHECK (Preco >= 0),
    QuantidadeEstoque INT NOT NULL CHECK (QuantidadeEstoque >= 0),
    DataValidade DATE,
    IdFornecedor INT,
    IdSetor INT,
    FOREIGN KEY (IdFornecedor) REFERENCES Fornecedor(IdFornecedor),
    FOREIGN KEY (IdSetor) REFERENCES Setor(IdSetor)
);

## O QUE FOI FEITO COM BASE NO MODDELO LOGICO RELACIONAL



CREATE TABLE FORNCEDOR (
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


CREATE TABLE FUNCIONARIO (
	CPF CHAR(11) NOT NULL UNIQUE PRIMARY KEY,
    id_Filial INT,
    Data_admissao DATE,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')), # coloquei assim para garantir que só seja M ou F
	Estado_Civil VARCHAR(20), 
    Login VARCHAR (100) NOT NULL,
	Senha VARCHAR (100) NOT NULL,
	RG CHAR(10) NOT NULL, #Inicialmente coloquei assim
    Nome VARCHAR (100) NOT NULL,
    Situação BOOLEAN NOT NULL, #considerei que seria um TRUE para ativo e FALSE para inativo 
    Endereco VARCHAR(2000),
    FOREIGN KEY(id_Filial) REFERENCES FILIAL(ID)
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
    IdCliente INT AUTO_INCREMENT PRIMARY KEY,
    ##NomeCliente VARCHAR(100) NOT NULL, o seguite seria para o atributo nome, já que ele é composto 
    P_nome VARCHAR(100) NOT NULL,
    M_nome VARCHAR(100),
    U_nome VARCHAR(100), 
    #Finalização do nome
    
    CPF CHAR(11) NOT NULL UNIQUE PRIMARY KEY,
    RG VARCHAR(10) NOT NULL,
    Telefone VARCHAR(15),
    # o que seria o endereço
    CEP char(8),
    Numero VARCHAR(5),
    Cidade VARCHAR(20),
	Descricao VARCHAR(100),
    # Terminio do endereço
    
    DataNascimento DATE not null,
    Email VARCHAR(50) ,
    DataCadastro DATE not null,
    Senha VARCHAR(200), 
	Vl_credito DECIMAL(10,2),
	id_filial INT,
    
    FOREIGN KEY (id_filial) REFERENCES Filial(id)
);

CREATE TABLE ENTREGA(
	Seq INT AUTO_INCREMENT PRIMARY KEY UNIQUE, #Usei o chat para esse atributo Seq, talvez seja necessário mudar 
	CPF_Entregador CHAR (11) NOT NULL PRIMARY KEY,
	Data_Entrega DATE NOT NULL,
	Hora_Estimada TIME NOT NULL, 
        
	FOREIGN KEY (CPF_Entregador) REFERENCES ENTREGADOR (CPF)
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


CREATE TABLE MATRIZ (
	CNPJ VARCHAR(20) NOT NULL UNIQUE PRIMARY KEY, ##MUDAR O numero maáximo de caracteres do CNPJ
	Telefone VARCHAR(12) not null,
	nome_fantasia VARCHAR(50) NOT NULL,
	tipo VARCHAR(50) NOT null
);


CREATE TABLE FILIAL (
	ID INT NOT NULL UNIQUE PRIMARY KEY ,
	CPF_GERENTE VARCHAR(11),
	Endereco VARCHAR(200),
	Qtde_fun INT,
	Cnpj_Matriz VARCHAR(20),

	FOREIGN KEY (Cnpj_Matriz) REFERENCES MATRIZ(CNPJ),
	FOREIGN KEY (CPF_GERENTE) REFERENCES GERENTE(CPF)

);

CREATE TABLE ESTOQUE (
	id_estoque INT AUTO_INCREMENT PRIMARY KEY NOT NULL UNIQUE,# no modelo que o professor passou, está mostrando tudo junto 
    id_Filial INT,
    descricao VARCHAR(250),
    dt_ult_Entrada DATE NOT NULL,
    
    FOREIGN KEY(id_Filial) REFERENCES FILIAL(ID)

);

CREATE TABLE ITEM_ESTOQUE(
	Id_Estoque INT PRIMARY KEY NOT NULL,
	Cod_Prod INT PRIMARY KEY NOT NULL,
    Data_Validade DATE,
    Data_Fabricacao DATE,
    Data_Entrada DATE,
    Valor_Compra DECIMAL(10,2),
    qtd_atual INT, #Tem que ver a logica para fazer a relaçao com a quantidade atual 
    qtd_min INT,
	
    FOREIGN KEY(Id_Estoque) REFERENCES ESTOQUE(id_estoque),
    FOREIGN KEY(Cod_Prod) REFERENCES PRODUTO_REF(Cod)

);

CREATE TABLE PERDA (
    id INT AUTO_INCREMENT PRIMARY KEY,  
    data_Perda DATE NOT NULL,  
    Quantidade_perdida INT NOT NULL,  
    Motivo VARCHAR(255),  
    Id_Estoque INT NOT NULL,  
    Cod_Prod INT NOT NULL,  
    

    FOREIGN KEY (Id_Estoque, Cod_Prod) REFERENCES ItemEstoque(Id_Estoque, Cod_Prod) 
);

CREATE TABLE UNIDADE_PROD(
	Cod INT AUTO_INCREMENT PRIMARY KEY ,
    Descricao VARCHAR(200),
    Sigla VARCHAR(4) #Talvez tenha que mudar essa parte 
);

CREATE TABLE MARCA_PROD(
	Cod INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(200)
    
);

CREATE TABLE CATEGORIA(
	Cod INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(200)
    
);

CREATE TABLE SUBCATEGORIA(
	Cod INT AUTO_INCREMENT PRIMARY KEY,
    Cod_Categoria INT,
    Descricao VARCHAR(200),
    
    FOREIGN KEY(Cod_Categoria) REFERENCES CATEGORIA (Cod)
    
);

CREATE TABLE PRODUTO_REF( 
	Cod INT AUTO_INCREMENT PRIMARY KEY ,
    Id_Unidade INT NOT NULL,
    Id_Marca INT NOT NULL,
    Id_SubCateg INT NOT NULL,
    cod_Fornecedor INT NOT NULL,
    Preco_por_tabela DECIMAL(10,2) , 
	Cod_barra VARCHAR(20) UNIQUE, ## A quantidade de digitos foi colocado de acordo com o chatgpt, talvez tenha que modificar  
    Freq_pedido INT NOT NULL ,
    Qtd_estoque INT , ## colocar a regra de negocio 	
    Descricao VARCHAR(200),
    Qtd_min INT , ## Colocar a regra de negocio 
    Preco_ult_compra DECIMAL (10,2),
    
	FOREIGN KEY (Id_Unidade) REFERENCES UNIDADE_PROD ( Cod ), ## mudei o UNIDADE para UNIDADE_PROD
	FOREIGN KEY (Id_Marca) REFERENCES MARCA_PROD ( Cod ), ## mudei o MARCA para MARCA_PROD
	FOREIGN KEY (Id_SubCateg) REFERENCES SUBCATEGORIA ( Cod ),
	FOREIGN KEY (cod_fornecedor) REFERENCES FORNECEDOR (Cod)
);

CREATE TABLE ITEMCOMPRA ( 
	Cod_compra INT PRIMARY KEY,
    Cod_produto INT PRIMARY KEY,
    Quantidade INT NOT NULL,
    Valor_desconto_item DECIMAL(10,2),
    Valor_unitario DECIMAL(10,2),
    
	FOREIGN KEY( Cod_compra) REFERENCES COMPRA ( Cod ),
	FOREIGN KEY( Cod_produto) REFERENCES PRODUTO_REF ( Cod ) #mudei de PRODUTOREF para PRODUTO_REF

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

CREATE TABLE TIPO_PAGAMENTO (
	cod_tp_pag INT PRIMARY KEY, # ESSE TALVEZ SEJA MELHOR USAR UM ENUM PARA DEFINIR OS CODIGO , LOGO DEVE SER MUDADO O ESSE TIPO INT 
	descricao VARCHAR(200)
);

CREATE TABLE FATURA ( 
	id INT AUTO_INCREMENT PRIMARY KEY,
    cod_Pedido_Fornecedor INT NOT NULL,
    dt_venc DATE, 
    vl_pago_atual DECIMAL(10,2),
    vl_total_final DECIMAL(10,2),
    dt_emissao DATE ,
    status_fatura BOOLEAN , # Mudei status para status_fatura , talvez seja necessário mudar o tipo BOOLEAN para o de ENUM
	dt_paga DATE,
    multa DECIMAL(10,2), 
    
	FOREIGN KEY(cod_Pedido_Fornecedor) REFERENCES PEDIDO_FORNECEDOR (Cod) # Mudei PEDIDOFORNECEDOR  para PEDIDO_FORNECEDOR 
);

CREATE TABLE NOTA_FISCAL ( 
	NFE VARCHAR(50) PRIMARY KEY,  
    ICMS DECIMAL(10,2) NOT NULL,  
    
    #nesse de baixo, usei as regras de negocio passadas pelo chat, talvez seja necessário validar.
    Valor_Total DECIMAL(10,2) NOT NULL CHECK (Valor_Total >= 0),
    Valor_Total_Desconto DECIMAL(10,2) CHECK (Valor_Total_Desconto >= 0), 
    data_NotaFical DATE NOT NULL,  
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

CREATE TABLE PEDIDO_FORNECEDOR ( 
	Cod INT AUTO_INCREMENT PRIMARY KEY,
    CPF_gerente CHAR(11),
    Total_desconto DECIMAL(10,2),
    Valor_total_IPI DECIMAL(10,2) , # VER SE PRECISA DE REGRA DE NEGÓCIO
    Valor_total DECIMAL (10,2),
    Data_Pedido_Forncedor DATE , 
	Status_Pedido_Forncedor BOOLEAN , # Ver se seria melhor colocar como do TIPO ENUM
    Valor_frete DECIMAL(10,2), #PRECISA COLOCAR A REGRA DE NEGÓCIO
    
	FOREIGN KEY (CPF_gerente) REFERENCES GERENTE (CPF) 
    );


CREATE TABLE ITEM_PEDIDO (
	Cod_produto_ref INT PRIMARY KEY ,
    Cod_pedido_fornecedor INT PRIMARY KEY,
    Quantidade INT NOT NULL ,
    Preco_unitario DECIMAL(10,2) NOT NULL ,#TALVEZ COLOCAR REGRA DE NEGOCIOS

	FOREIGN KEY (cod_produto_ref ) REFERENCES PRODUTO_REF (Cod),#MUDEI DE PRODUTOREF PARA PRODUTO_REF
	FOREIGN KEY(cod_pedido_fornecedor) REFERENCES PEDIDO_FORNECEDOR ( Cod) #MUDEIO DE PEDIDOFORNECEDOR PARA PEDIDO_FORNECEDOR
);

#O QUE FOI FEITO COM BASE NO MODELO LOGICO RELACIONAL 

CREATE TABLE OperadorCaixa (
    IdOperador INT AUTO_INCREMENT PRIMARY KEY,
    NomeOperador VARCHAR(100) NOT NULL,
    Turno ENUM('Manhã', 'Tarde', 'Noite') NOT NULL,
    IdSetor INT,
    FOREIGN KEY (IdSetor) REFERENCES Setor(IdSetor)
);


CREATE TABLE Venda (
    IdVenda INT AUTO_INCREMENT PRIMARY KEY,
    DataVenda DATE NOT NULL,
    ValorTotal DECIMAL(10, 2) NOT NULL CHECK (ValorTotal >= 0),
    IdCliente INT,
    IdOperador INT,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
    FOREIGN KEY (IdOperador) REFERENCES OperadorCaixa(IdOperador)
);


CREATE TABLE VendaProduto (
    IdVenda INT,
    IdProduto INT,
    Quantidade INT NOT NULL CHECK (Quantidade > 0),
    PrecoUnitario DECIMAL(10, 2) NOT NULL CHECK (PrecoUnitario >= 0),
    ValorTotal DECIMAL(10,2) GENERATED ALWAYS AS (Quantidade * PrecoUnitario) STORED,
    PRIMARY KEY (IdVenda, IdProduto),
    FOREIGN KEY (IdVenda) REFERENCES Venda(IdVenda) ON DELETE CASCADE,
    FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto) ON DELETE CASCADE
);


CREATE TABLE Encomenda (
    IdEncomenda INT AUTO_INCREMENT PRIMARY KEY,
    DataEncomenda DATE NOT NULL,
    DataEntrega DATE CHECK (DataEntrega >= DataEncomenda),
    Status ENUM('Pendente', 'Em andamento', 'Entregue', 'Cancelada') NOT NULL DEFAULT 'Pendente',
    IdCliente INT,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);


CREATE TABLE Promocao (
    IdPromocao INT AUTO_INCREMENT PRIMARY KEY,
    NomePromocao VARCHAR(100) NOT NULL,
    Desconto DECIMAL(5, 2) NOT NULL CHECK (Desconto BETWEEN 0 AND 100),
    DataInicio DATE NOT NULL,
    DataFim DATE NOT NULL CHECK (DataFim >= DataInicio)
);


CREATE TABLE ProdutoPromocao (
    IdPromocao INT,
    IdProduto INT,
    PRIMARY KEY (IdPromocao, IdProduto),
    FOREIGN KEY (IdPromocao) REFERENCES Promocao(IdPromocao) ON DELETE CASCADE,
    FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto) ON DELETE CASCADE
);


CREATE TABLE MovimentacaoEstoque (
    IdMovimentacao INT AUTO_INCREMENT PRIMARY KEY,
    TipoMovimentacao ENUM('Entrada', 'Saída') NOT NULL,
    DataMovimentacao DATE NOT NULL,
    Quantidade INT NOT NULL CHECK (Quantidade > 0),
    Origem VARCHAR(255),
    IdProduto INT,
    FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto)
);
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

DELIMITER ;