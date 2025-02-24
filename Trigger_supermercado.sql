Use supermercado;

#Para o trigger funcionar, parte de calcular a idade do cliente a partir da data de nascimetno 

alter table CLIENTE
add column idade int;

#trigger para calcular a idade do cliente durante o cadastro 

DELIMITER //

CREATE TRIGGER calcular_idade_insert
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    SET NEW.idade = TIMESTAMPDIFF(YEAR, NEW.DataNascimento, CURDATE());
END //

DELIMITER ;

