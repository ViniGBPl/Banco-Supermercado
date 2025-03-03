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
        


