CREATE DATABASE DADOS_ADUANEIROS;

USE DADOS_ADUANEIROS;

CREATE TABLE STAGING_DADOS_ADUANEIROS (
    ID_Processo VARCHAR,
    Data_Registro VARCHAR,
    Data_Desembaraco VARCHAR,
    Importador VARCHAR,
    Exportador VARCHAR,
    NCM VARCHAR,
    Descricao_Mercadoria VARCHAR,
    Pais_Origem VARCHAR,
    Modal_Transporte VARCHAR,
    Porto_Entrada VARCHAR,
    Valor_Mercadoria_USD VARCHAR,
    Valor_Frete_USD VARCHAR,
    Valor_Seguro_USD VARCHAR,
    Taxa_Cambio VARCHAR,
    Valor_Aduaneiro_BRL VARCHAR,
    II_Valor_BRL VARCHAR,
    IPI_Valor_BRL VARCHAR,
    PIS_Valor_BRL VARCHAR,
    COFINS_Valor_BRL VARCHAR,
    Canal_Parametrizacao VARCHAR
);
