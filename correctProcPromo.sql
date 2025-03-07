DROP PROCEDURE IF EXISTS AplicarPromocaoNaCompra;

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
    DECLARE v_Valor_Minimo DECIMAL(10,2) DEFAULT 0.01; -- Valor mínimo permitido para um produto

    -- Log: Início do procedimento
    SELECT 'Iniciando procedimento AplicarPromocaoNaCompra...' AS Log;

    -- Verifica se a compra existe
    SELECT COUNT(*) INTO v_Compra_Existe
    FROM COMPRA
    WHERE Cod = p_Cod_Compra;

    IF v_Compra_Existe = 0 THEN
        -- Log: Compra não encontrada
        SELECT 'Erro: Compra não encontrada.' AS Log;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Compra não encontrada.';
    END IF;

    -- Log: Compra encontrada
    SELECT 'Compra encontrada.' AS Log;

    -- Verifica se a promoção existe e obtém o percentual de redução
    SELECT Perc_Reducao INTO v_Perc_Reducao
    FROM PROMOCAO
    WHERE Cod = p_Cod_Promocao;

    IF v_Perc_Reducao IS NULL THEN
        -- Log: Promoção não encontrada
        SELECT 'Erro: Promoção não encontrada.' AS Log;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Promoção não encontrada.';
    END IF;

    -- Log: Promoção encontrada
    SELECT CONCAT('Promoção encontrada. Percentual de redução: ', v_Perc_Reducao) AS Log;

    -- Inicia uma transação para garantir a atomicidade
    START TRANSACTION;

    -- Bloco de tratamento de erros
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            -- Rollback em caso de erro
            ROLLBACK;
            -- Log: Erro durante a execução
            SELECT 'Erro ao aplicar a promoção. Transação revertida.' AS Log;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao aplicar a promoção. Transação revertida.';
        END;

        -- Log: Início da aplicação do desconto
        SELECT 'Aplicando desconto aos itens da compra...' AS Log;

        -- Log: Valores antes da atualização
        SELECT CONCAT('Valor_unitario: ', Valor_unitario, ', Perc_Reducao: ', v_Perc_Reducao, ', Valor_Minimo: ', v_Valor_Minimo) AS Log
        FROM ITEMCOMPRA
        WHERE Cod_Compra = p_Cod_Compra;

        -- Aplica o desconto em cada item da compra, garantindo que o valor não seja zerado
        UPDATE ITEMCOMPRA
        SET Valor_desconto_item = LEAST(Valor_unitario * v_Perc_Reducao / 100, Valor_unitario - v_Valor_Minimo),
            Valor_unitario = GREATEST(Valor_unitario - (Valor_unitario * v_Perc_Reducao / 100), v_Valor_Minimo)
        WHERE Cod_Compra = p_Cod_Compra;

        -- Log: Desconto aplicado com sucesso
        SELECT 'Desconto aplicado com sucesso!' AS Log;

        -- Calcula o valor total da compra com desconto (tratando NULL)
        SELECT COALESCE(SUM(Quantidade * Valor_unitario), 0)
        INTO v_Valor_Total_Compra
        FROM ITEMCOMPRA
        WHERE Cod_Compra = p_Cod_Compra;

        -- Log: Valor total da compra calculado
        SELECT CONCAT('Valor total da compra: ', v_Valor_Total_Compra) AS Log;

        -- Calcula o valor total do desconto aplicado (tratando NULL)
        SELECT COALESCE(SUM(Quantidade * Valor_desconto_item), 0)
        INTO v_Valor_Total_Desconto
        FROM ITEMCOMPRA
        WHERE Cod_Compra = p_Cod_Compra;

        -- Log: Valor total do desconto calculado
        SELECT CONCAT('Valor total do desconto: ', v_Valor_Total_Desconto) AS Log;

        -- Atualiza o valor total da compra e o valor total de desconto na tabela COMPRA
        UPDATE COMPRA
        SET Valor_Total = v_Valor_Total_Compra,
            Valor_Total_Desconto = v_Valor_Total_Desconto
        WHERE Cod = p_Cod_Compra;

        -- Log: Compra atualizada com sucesso
        SELECT 'Compra atualizada com sucesso!' AS Log;

        -- Confirma a transação
        COMMIT;

        -- Log: Promoção aplicada com sucesso
        SELECT 'Promoção aplicada com sucesso!' AS Mensagem;
    END;
END //

DELIMITER ;

--testes
-- Suponha que a compra com Cod = 1 tenha Valor_Total = 150.00 e a promoção com Cod = 1 tenha Perc_Reducao = 15.00
CALL AplicarPromocaoNaCompra(1, 1);

-- Verifique os logs gerados pelo procedimento
-- Resultado esperado: Logs mostrando o desconto aplicado e o valor total atualizado.

-- Verifique os valores dos itens da compra após aplicar a promoção
SELECT Cod_Compra, Cod_Produto, Valor_unitario, Valor_desconto_item
FROM ITEMCOMPRA
WHERE Cod_Compra = 1;
-- Resultado esperado: Valor_unitario e Valor_desconto_item atualizados com desconto de 15%.

-- Verifique o valor total da compra após aplicar a promoção
SELECT Cod, Valor_Total, Valor_Total_Desconto
FROM COMPRA
WHERE Cod = 1;
-- Resultado esperado: Valor_Total e Valor_Total_Desconto atualizados.

-- Tente aplicar uma promoção a uma compra que não existe
CALL AplicarPromocaoNaCompra(999, 1);
-- Resultado esperado: Erro "Compra não encontrada."

-- Tente aplicar uma promoção que não existe a uma compra válida
CALL AplicarPromocaoNaCompra(1, 999);
-- Resultado esperado: Erro "Promoção não encontrada."