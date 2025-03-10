USE supermercado;

DELIMITER //

CREATE PROCEDURE csv_runner(caminho_arquivo VARCHAR(255))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE current_table VARCHAR(40);
    DECLARE current_line TEXT;
    DECLARE file_handle INT;
    DECLARE query_load_data TEXT;
    DECLARE header_line TEXT; -- Declaração da variável header_line

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Verifica se o arquivo existe
    DECLARE EXIT HANDLER FOR SQLSTATE 'HY000'
    BEGIN
        SELECT 'Erro: O arquivo especificado não existe ou não pode ser acessado.' AS Mensagem;
    END;

    -- Cria uma tabela temporária e carrega o arquivo CSV nela
    CREATE TEMPORARY TABLE temp_csv (
        linha TEXT
    );

    -- Monta a query para carregar o arquivo CSV na tabela temporária
    SET query_load_data = CONCAT(
        "LOAD DATA LOCAL INFILE '", caminho_arquivo, "' ",
        "INTO TABLE temp_csv ",
        "FIELDS TERMINATED BY '\n' ",
        "LINES TERMINATED BY '\n' ",
        "IGNORE 0 ROWS;"
    );

    -- Executa a query dinamicamente
    PREPARE stmt FROM query_load_data;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Cursor para percorrer as linhas do arquivo
    DECLARE index CURSOR FOR SELECT linha FROM temp_csv;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN index;

    read_loop: LOOP
        FETCH index INTO current_line;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Verifica se a linha indica uma nova tabela
        IF current_line NOT LIKE '%,%' THEN
            SET current_table = current_line; -- Nome da tabela
            FETCH index INTO header_line; -- Lê a linha de cabeçalho
        ELSE
            -- Monta a query para carregar os dados na tabela atual
            SET query_load_data = CONCAT(
                "LOAD DATA LOCAL INFILE '", caminho_arquivo, "' ",
                "INTO TABLE ", current_table, " ",
                "FIELDS TERMINATED BY ',' ",
                "ENCLOSED BY '\"' ",
                "LINES TERMINATED BY '\n' ",
                "IGNORE ", (SELECT COUNT(*) FROM temp_csv WHERE linha = current_table) + 1, " ROWS;"
            );

            -- Executa a query dinamicamente
            PREPARE stmt FROM query_load_data;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;
    END LOOP;

    CLOSE index;

    -- Remove a tabela temporária
    DROP TEMPORARY TABLE temp_csv;

    -- Mensagem de conclusão
    SELECT 'Dados carregados com sucesso para todas as tabelas!' AS Mensagem;
END //

DELIMITER ;

CALL csv_runner('/var/lib/mysql-files/dataload.csv')