USE supermercado;

#Feito usando o ACID


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
