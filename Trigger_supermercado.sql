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
    IF NEW.DataNascimento IS NOT NULL THEN
        SET NEW.idade = TIMESTAMPDIFF(YEAR, NEW.DataNascimento, CURDATE());
    ELSE
        SET NEW.idade = NULL;
    END IF;
END //

DELIMITER ;

####falta testar
#Trigger para atualizar a quantidade de produto

#Trigger para adionar uma quantidade de produto

#Trigger para atualizar a quantidade de produto
#Não é necessário usar transactions explicitamente em triggers, pois o MySQL já gerencia isso internamente.

--trigger de atualização do estoque para cada operação de item_estoque

DELIMITER //

CREATE TRIGGER AtualizarEstoqueProdutoRefInsert
AFTER INSERT ON ITEM_ESTOQUE
FOR EACH ROW
BEGIN
    -- Atualiza a quantidade em estoque do produto após inserção
    UPDATE PRODUTO_REF
    SET qtd_estoque = qtd_estoque + NEW.qtd_atual
    WHERE Cod = NEW.Cod_Prod;
END //

CREATE TRIGGER AtualizarEstoqueProdutoRefUpdate
AFTER UPDATE ON ITEM_ESTOQUE
FOR EACH ROW
BEGIN
    -- Atualiza a quantidade em estoque do produto após atualização
    UPDATE PRODUTO_REF
    SET qtd_estoque = qtd_estoque - OLD.qtd_atual + NEW.qtd_atual
    WHERE Cod = NEW.Cod_Prod;
END //

CREATE TRIGGER AtualizarEstoqueProdutoRefDelete
AFTER DELETE ON ITEM_ESTOQUE
FOR EACH ROW
BEGIN
    -- Atualiza a quantidade em estoque do produto após exclusão
    UPDATE PRODUTO_REF
    SET qtd_estoque = qtd_estoque - OLD.qtd_atual
    WHERE Cod = OLD.Cod_Prod;
END //

DELIMITER ;

## Falta testar



#trigger do para qauntidade de funcionarios na filial


###Pode usar como teste
#INSERT INTO FUNCIONARIO (CPF, id_Filial, Data_admissao, Sexo, Estado_Civil, Login, Senha, RG, Nome, Situação, Endereco)
#VALUES ('12345678902', 1, '2023-10-01', 'M', 'Solteiro', 'joao.silva', 'senha123', '1234567890', 'João Silva', TRUE, 'Rua A, 123');


#DELETE FROM FUNCIONARIO WHERE CPF = '12345678902';

# Verificar se a quantidade de funcionários na filial foi atualizada
#SELECT * FROM FILIAL WHERE ID = 1;
###Pode usar como teste


#Inserir
DELIMITER //

CREATE TRIGGER after_funcionario_insert
AFTER INSERT ON FUNCIONARIO
FOR EACH ROW
BEGIN
    UPDATE FILIAL
    SET Qtde_fun = Qtde_fun + 1
    WHERE ID = NEW.id_Filial;
END //

DELIMITER ;


#Para retirar

DELIMITER //

CREATE TRIGGER after_funcionario_delete
AFTER DELETE ON FUNCIONARIO
FOR EACH ROW
BEGIN

    UPDATE FILIAL
    SET Qtde_fun = GREATEST(Qtde_fun - 1, 0)
    WHERE ID = OLD.id_Filial;
END //




    # Para a trigger item 2 . Opcional 

DELIMITER //

CREATE TRIGGER set_funcionario_ativo 
BEFORE INSERT ON FUNCIONARIO 
FOR EACH ROW 
BEGIN
    SET NEW.Situação = TRUE;
END;

DELIMITER ;

DELIMITER ;

