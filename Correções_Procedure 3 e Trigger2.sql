#correções
# Para a trigger item 2 . Opcional 

DELIMITER //

CREATE TRIGGER set_funcionario_ativo 
BEFORE INSERT ON FUNCIONARIO 
FOR EACH ROW 
BEGIN
    SET NEW.Situação = TRUE;
END;

DELIMITER ;
## usar como teste do trigger 

#INSERT INTO FUNCIONARIO (CPF, id_Filial, Data_admissao, Sexo, Estado_Civil, Login, Senha, RG, Nome, Situação, Endereco)
#VALUES('33333333334', 4, '2023-02-14', 'M', 'Casado', 'entrega.teste', 'senha202', '3333333339', 'Vinicius santos', FALSE, 'Rua das Margaridas, 204');


## PARA OS PROCEDURES
##ITEM 3
DELIMITER //

CREATE PROCEDURE GerarNotasFiscalPedidoFornecedor(
    IN pedidoID INT,       
    IN dataNota DATE,      
    IN codPagamento INT    
)
BEGIN
    DECLARE pedidoExiste INT;
    DECLARE pagamentoExiste INT;
    DECLARE valorTotal DECIMAL(10,2);
    DECLARE valorDesconto DECIMAL(10,2);
    DECLARE valorFrete DECIMAL(10,2);
    DECLARE IPI DECIMAL(10,2);
    DECLARE ICMS DECIMAL(10,2);
    DECLARE numeroNFE VARCHAR(50);

    -- Definindo tratamento de erro
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN 
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro ao gerar a nota fiscal';
    END;

    START TRANSACTION;

    -- Verifica se o pedido fornecedor existe
    SELECT COUNT(*) INTO pedidoExiste FROM PEDIDO_FORNECEDOR WHERE Cod = pedidoID;

    IF pedidoExiste = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Pedido do fornecedor não encontrado';
    END IF;

    -- Verifica se o pagamento existe
    SELECT COUNT(*) INTO pagamentoExiste FROM PAGAMENTO WHERE Cod = codPagamento;

    IF pagamentoExiste = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Código de pagamento não encontrado';
    END IF;

    
    SELECT Valor_total, Total_desconto, Valor_frete, Valor_total_IPI 
    INTO valorTotal, valorDesconto, valorFrete, IPI
    FROM PEDIDO_FORNECEDOR
    WHERE Cod = pedidoID;

    SET ICMS = valorTotal * 0.10;

    SET numeroNFE = CONCAT('NFE', pedidoID);

    INSERT INTO NOTA_FISCAL (NFE, ICMS, Valor_total, Valor_total_Desconto, data_NotaFiscal, Valor_frete)
    VALUES (numeroNFE, ICMS, valorTotal, valorDesconto, dataNota, valorFrete);    

   
    INSERT INTO NOTA_FISCAL_FORNECEDOR (NFE, cod_pagamento, IPI)
    VALUES (numeroNFE, codPagamento, IPI);

 
    UPDATE PEDIDO_FORNECEDOR
    SET Status_Pedido_Fornecedor = TRUE
    WHERE Cod = pedidoID;

    COMMIT;
END //

DELIMITER ;


#call supermercado.GerarNotasFiscalPedidoFornecedor(2, '2025-05-20', 2);
#call supermercado.GerarNotasFiscalPedidoFornecedor(1, '2025-05-20', 1);

#SELECT * FROM supermercado.pedido_fornecedor;
#SELECT * FROM supermercado.nota_fiscal_fornecedor;
#SELECT * FROM supermercado.nota_fiscal

