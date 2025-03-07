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

--stored procedure para aplicar o desconto da promocao a cada itemcompra da compra de um cliente
DELIMITER //

CREATE PROCEDURE AplicarPromocaoNaCompra(
    IN p_Cod_Compra INT,   -- Código da compra
    IN p_Cod_Promocao INT  -- Código da promoção
)
BEGIN
    DECLARE v_Valor_Total_Compra DECIMAL(10,2);
    DECLARE v_Valor_Total_Desconto DECIMAL(10,2);
    DECLARE v_Perc_Reducao DECIMAL(5,2);
    DECLARE v_Compra_Existe INT;
    DECLARE v_Promocao_Existe INT;

    -- Verifica se a compra existe
    SELECT COUNT(*) INTO v_Compra_Existe
    FROM COMPRA
    WHERE Cod = p_Cod_Compra;

    IF v_Compra_Existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Compra não encontrada.';
    END IF;

    -- Verifica se a promoção existe e obtém o percentual de redução
    SELECT Perc_Reducao INTO v_Perc_Reducao
    FROM PROMOCAO
    WHERE Cod = p_Cod_Promocao;

    IF v_Perc_Reducao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Promoção não encontrada.';
    END IF;

    -- Inicia uma transação para garantir a atomicidade
    START TRANSACTION;

    -- Bloco de tratamento de erros
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            -- Rollback em caso de erro
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao aplicar a promoção. Transação revertida.';
        END;

        -- Aplica o desconto em cada item da compra
        UPDATE ITEMCOMPRA
        SET Valor_desconto_item = (Preco_Unitario * v_Perc_Reducao / 100),
            Preco_Unitario = Preco_Unitario - (Preco_Unitario * v_Perc_Reducao / 100)
        WHERE Cod_Compra = p_Cod_Compra;

        -- Calcula o valor total da compra com desconto
        SELECT SUM(Quantidade * Preco_Unitario)
        INTO v_Valor_Total_Compra
        FROM ITEMCOMPRA
        WHERE Cod_Compra = p_Cod_Compra;

        -- Calcula o valor total do desconto aplicado
        SELECT SUM(Quantidade * Valor_desconto_item)
        INTO v_Valor_Total_Desconto
        FROM ITEMCOMPRA
        WHERE Cod_Compra = p_Cod_Compra;

        -- Atualiza o valor total da compra e o valor total de desconto na tabela COMPRA
        UPDATE COMPRA
        SET Valor_Total = v_Valor_Total_Compra,
            Valor_Total_Desconto = v_Valor_Total_Desconto
        WHERE Cod = p_Cod_Compra;

        -- Confirma a transação
        COMMIT;

        SELECT 'Promoção aplicada com sucesso!' AS Mensagem;
    END;
END //

DELIMITER ;




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
