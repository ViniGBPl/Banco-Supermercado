USE supermercado;

#Feito usando o ACID


##atualizr o estoque depois da venda de um item do estoque 

DELIMITER //

CREATE PROCEDURE AtualizarEstoqueCadastrarCompra(
    IN itemID INT,
    IN qtdComprada INT
)
BEGIN
    DECLARE qtdAtual INT;

    -- Tratamento de erro para garantir ACID
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Falha ao atualizar o estoque';
    END;

    START TRANSACTION;
    
    SELECT qtd_atual INTO qtdAtual FROM ITEM_ESTOQUE WHERE Id_Estoque = itemID;

    IF qtdAtual IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item não encontrado no estoque';
    ELSEIF qtdAtual < qtdComprada THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantidade superior ao disponível';
    ELSE
        
        UPDATE ITEM_ESTOQUE
        SET qtd_atual = qtd_atual - qtdComprada
        WHERE Id_Estoque = itemID;

        COMMIT;
    END IF;
END //

DELIMITER ;


##Para gerar as NOTAS_FISCAIS DE UM  PEDIDO_FORNECEDOR

delimiter //

create procedure GerarNotasFiscalPedidoFornecedor( 
	in pedidoID int,
    in numeroNFE varchar(50),
    in datanota DATE,
    in valorTotal decimal(10,2),
    in valorDesconto decimal(10,2),
    in valorFrete Decimal(10,2),
    IN ICMS decimal(10,2),
    in ip decimal(10,2),
    in codpagamento int
    )
    
Begin
	declare pedidoExiste int;
	
    declare exit handler for sqlexception
    begin 
		rollback;
        signal sqlstate '45000' set message_text = 'Não foi possível gerar a nota fiscal';
	end;
    
    Start transaction;
    
    select count(*) into pedidoExiste from pedido_fornecedor where Cod = pedidoID;
    
    if pedidoExiste = 0 then
		rollback;
        signal sqlstate '45000' set message_text = 'Pedido do fornecedor não encontrado';
	else
		insert into NOTA_FISCAL(NFE, ICMS, Valor_total, Valor_total_Desconto, data_NotaFiscal, Valor_frete)
		values (numeroNFE, ICMS, valorTotal, valorDesconto, dataNota, valorFrete);    
        
        insert into nota_fiscal_fornecedor (NFE, cod_pagamento, IPI)
        values (numeroNFE, codPagamento, IPI);
        
        update pedido_fornecedor
        set Status_Pedido_Forncedor = True
        where Cod = pedidoID;
        
        COMMIT;
	end if;
end //    

#usei esse para testar 
#CALL supermercado.GerarNotasFiscalPedidoFornecedor(
#    1,             -- pedidoID
#    'NFE123456',   -- numeroNFE
#    '2024-03-03',  -- dataNota
#    500.00,        -- valorTotal
#    50.00,         -- valorDesconto
#    20.00,         -- valorFrete
#    18.00,         -- ICMS
 #   10.00,         -- IPI
#    2              -- codPagamento
#);
    
    
    
    
## Gerar um FATURA e PAGAMENTO depois de um PEDIDO_FORNECEDOR

Delimiter //

CREATE PROCEDURE GerarFaturaPagamentoPedidoFornecedor(
    IN pedidoID INT,
    IN dataVencimento DATE,
    IN dataPagamento DATE,
    IN codTipoPagamento INT
)
BEGIN 
    DECLARE pedidoExiste INT DEFAULT 0;
    DECLARE valorTotal DECIMAL(10,2) DEFAULT 0.00;
    DECLARE faturaID INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao gerar a fatura e o pagamento';
    END;

    START TRANSACTION;
    
    -- Verifica se o pedido existe e pega o valor total
    SELECT COUNT(*), COALESCE(SUM(Valor_total), 0)
    INTO pedidoExiste, valorTotal
    FROM PEDIDO_FORNECEDOR
    WHERE Cod = pedidoID;

    IF pedidoExiste = 0 OR valorTotal = 0 THEN 
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pedido do fornecedor não encontrado ou sem valor total';
    ELSE
        -- Cria a fatura
        INSERT INTO FATURA (cod_Pedido_Fornecedor, dt_venc, vl_pago_atual, vl_total_final, dt_emissao, status_fatura)
        VALUES (pedidoID, dataVencimento, 0.00, valorTotal, CURDATE(), 0);

        SET faturaID = LAST_INSERT_ID();

        -- Registra o pagamento
        INSERT INTO PAGAMENTO (id_fatura, cod_compra, cod_tipo_pagamento, vl_pago, data_Pagamento, status_Pagamento)
        VALUES (faturaID, pedidoID, codTipoPagamento, valorTotal, dataPagamento, 1);
        
        COMMIT;
    END IF;
END //
