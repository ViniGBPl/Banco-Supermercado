use supermercado;


-- Criar usuários para cada funcionário baseado no login e senha da tabela FUNCIONARIO
DROP USER IF EXISTS 'carlos.oliveira'@'%';#tem que retirar antes
DROP USER IF EXISTS 'entrega.teste'@'%';#tem que retirar antes
DROP USER IF EXISTS 'carlos.silva'@'%'; #tem que retirar antes
CREATE USER 'carlos.oliveira'@'%' IDENTIFIED BY 'senha789';##Para o gerente
CREATE USER 'entrega.teste'@'%' IDENTIFIED BY 'senha202'; ##Para o entregador
CREATE USER 'carlos.silva'@'%' IDENTIFIED BY 'senha123';##Para o CLIENTE

#Criação das roles
DROP ROLE IF EXISTS GERENTE;
DROP ROLE IF EXISTS ENTREGADOR;
DROP ROLE IF EXISTS CLIENTE;

Create role GERENTE, ENTREGADOR, CLIENTE;

GRANT CLIENTE TO 'carlos.silva'@'%';
GRANT GERENTE TO 'carlos.oliveira'@'%';
GRANT ENTREGADOR TO 'entrega.teste'@'%';

#definido role
SET DEFAULT ROLE CLIENTE TO 'carlos.silva'@'%';
SET DEFAULT ROLE ENTREGADOR TO 'entrega.teste'@'%';
SET DEFAULT ROLE GERENTE TO 'carlos.oliveira'@'%';


#definição de privilegios 

##PARA O GERENTE####

# O gerente vai ter acesso a todos o funcionários 
Grant select, insert, update, delete on supermercado.funcionario to GERENTE;
GRANT SELECT, INSERT, UPDATE, DELETE ON Supermercado.gerente TO GERENTE;
Grant Select, Insert, Update, delete on supermercado.entregador to GERENTE;


# Para o gerente se gereniciar outros , seria tipo um chefe geral 
GRANT SELECT, INSERT, UPDATE, DELETE ON Supermercado.gerente TO GERENTE;


#Para gerenciar o estoque
Grant select, insert,update on supermercado.estoque to GERENTE;
Grant select, insert, update on  supermercado.item_estoque to GERENTE;

#Para o gerente visualizar vendas e cliente

Grant select, insert, update on supermercado.compra to GERENTE;
Grant select, insert, update on supermercado.itemcompra to GERENTE;
Grant select, insert, update on supermercado.cliente to GERENTE;

#Para o fornecedor 
Grant select , insert, update on supermercado.fornecedor to GERENTE;

#Gerente pode dar grant pra outros funcionarios
GRANT GRANT OPTION ON supermercado.* TO GERENTE;

##PARA  ENTREGADOR #####

#Para atualizar os status da entrega
Grant select, update(Data_Entrega,Hora_Estimada) on supermercado.entrega to ENTREGADOR;

#Visualizar dados da entrega para o entregador
 Grant select on supermercado.compra to ENTREGADOR;
 
 #Ver o endereço do cliente e outra informação que ajudem a identificar a pessoa
 Grant select on supermercado.cliente to ENTREGADOR;

##PARA O CLIENTE#####

#Para visualizar e editar os próprios dados
Grant select, update(Email, Senha, Telefone, CEP, Numero,Cidade, Descricao) on supermercado.cliente to CLIENTE;
 
 #Para realizar Compras e Visualizar o histório de compras 
 Grant select,insert on supermercado.compra to CLIENTE;
 Grant select,insert on supermercado.itemcompra to CLIENTE;
 
 #Precisa ver qual logica vai ser feita para o cliente visualizar apenas a sua compra 

SHOW GRANTS FOR 'carlos.silva'@'%';
SHOW GRANTS FOR 'carlos.oliveira'@'%';
SHOW GRANTS FOR 'entrega.teste'@'%'