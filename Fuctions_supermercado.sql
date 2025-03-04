Use supermercado;
DELIMITER //

CREATE FUNCTION VerificarEstoqueSuficiente(
    p_Cod_Prod INT,      
    p_Quantidade INT     
)
RETURNS BOOLEAN 
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_Estoque_Disponivel INT;
    SELECT qtd_atual
    INTO v_Estoque_Disponivel
    FROM ITEM_ESTOQUE
    WHERE Cod_Prod = p_Cod_Prod
    LIMIT 1; 
    IF v_Estoque_Disponivel >= p_Quantidade THEN
        RETURN TRUE; 
    ELSE
        RETURN FALSE; 
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION CalcularValorTotalPedidoFornecedor(
    p_Cod_Pedido_Fornecedor INT 
)
RETURNS DECIMAL(10, 2) 
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_Valor_Total DECIMAL(10, 2);
    SELECT SUM(Quantidade * IFNULL(Preco_unitario, 0))
    INTO v_Valor_Total
    FROM ITEM_PEDIDO
    WHERE Cod_pedido_fornecedor = p_Cod_Pedido_Fornecedor;
    RETURN IFNULL(v_Valor_Total, 0); 
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION VerificarProdutoProximoVencimento(
    p_Cod_Prod INT, 
    p_N INT         
)
RETURNS BOOLEAN 
DETERMINISTIC
READS SQL DATA

BEGIN
    DECLARE v_Data_Validade DATE;
    SELECT Data_Validade
    INTO v_Data_Validade
    FROM ITEM_ESTOQUE
    WHERE Cod_Prod = p_Cod_Prod
    LIMIT 1; 

    IF v_Data_Validade <= CURDATE() + INTERVAL p_N DAY THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE; 
    END IF;
END //

DELIMITER ;