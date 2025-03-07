DELIMITER //

CREATE TRIGGER AtualizarEstoqueProdutoRefInsert
AFTER INSERT ON ITEM_ESTOQUE
FOR EACH ROW
BEGIN
    DECLARE v_Estoque_Atual INT;

    -- Log: Início do trigger
    SELECT CONCAT('Trigger acionado para Cod_Prod: ', NEW.Cod_Prod, ', qtd_atual: ', NEW.qtd_atual) AS Log;

    -- Obtém a quantidade atual em estoque do produto
    SELECT qtd_estoque INTO v_Estoque_Atual
    FROM PRODUTO_REF
    WHERE Cod = NEW.Cod_Prod;

    -- Log: Quantidade atual em estoque antes da atualização
    SELECT CONCAT('Quantidade atual em estoque (antes): ', v_Estoque_Atual) AS Log;

    -- Verifica se a nova quantidade resultaria em um estoque negativo
    IF v_Estoque_Atual + NEW.qtd_atual < 0 THEN
        -- Log: Erro de estoque negativo
        SELECT CONCAT('Erro: A quantidade em estoque não pode ser negativa. Cod_Prod: ', NEW.Cod_Prod, ', qtd_atual: ', NEW.qtd_atual) AS Log;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: A quantidade em estoque não pode ser negativa.';
    ELSE
        -- Atualiza o estoque do produto
        UPDATE PRODUTO_REF
        SET qtd_estoque = qtd_estoque + NEW.qtd_atual
        WHERE Cod = NEW.Cod_Prod;

        -- Log: Quantidade atual em estoque após a atualização
        SELECT CONCAT('Quantidade atual em estoque (após): ', qtd_estoque) AS Log
        FROM PRODUTO_REF
        WHERE Cod = NEW.Cod_Prod;
    END IF;
END //

DELIMITER ;

--testes
-- Suponha que o produto com Cod = 3 (Detergente Líquido) tenha qtd_estoque = 150
-- Inserir um novo item no estoque com Id_Estoque = 3 e Cod_Prod = 3
INSERT INTO ITEM_ESTOQUE (Id_Estoque, Cod_Prod, Data_Validade, Data_Fabricacao, Data_Entrada, Valor_Compra, qtd_atual, qtd_min)
VALUES (8, 3, '2024-12-31', '2024-01-01', '2024-01-01', 7.50, 50, 15);

-- Verifique se a quantidade em estoque do produto foi atualizada corretamente
SELECT Cod, Descricao, qtd_estoque
FROM PRODUTO_REF
WHERE Cod = 3;
-- Resultado esperado: qtd_estoque = 200 (150 + 50)

-- Suponha que o produto com Cod = 4 (Sabonete em Barra) tenha qtd_estoque = 300
-- Tente inserir uma quantidade que resulte em estoque negativo
INSERT INTO ITEM_ESTOQUE (Id_Estoque, Cod_Prod, Data_Validade, Data_Fabricacao, Data_Entrada, Valor_Compra, qtd_atual, qtd_min)
VALUES (6, 4, '2024-12-31', '2024-01-01', '2024-01-01', 2.50, -400, 30);
-- Resultado esperado: Erro "Erro: A quantidade em estoque não pode ser negativa."

-- Verifique se a quantidade em estoque do produto não foi alterada
SELECT Cod, Descricao, qtd_estoque
FROM PRODUTO_REF
WHERE Cod = 4;
-- Resultado esperado: qtd_estoque = 300 (não alterado)