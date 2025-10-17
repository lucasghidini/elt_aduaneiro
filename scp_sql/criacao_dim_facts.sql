CREATE OR REPLACE TABLE dim_tempo ( 
    id_data INT PRIMARY KEY,
    data_completa DATE UNIQUE,
    ano INT, mes INT, dia INT,
    trimestre INT,
    nome_mes VARCHAR(50)
);
CREATE OR REPLACE TABLE dim_produtos (
    id_produto INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    codigo_ncm VARCHAR(20) UNIQUE,
    descricao_mercadoria TEXT
);
CREATE OR REPLACE TABLE dim_paises (
    id_pais INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    nome_pais VARCHAR(255) UNIQUE
);
CREATE OR REPLACE TABLE dim_portos (
    id_porto INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    nome_porto VARCHAR(255) UNIQUE
);
CREATE OR REPLACE TABLE dim_modais (
    id_modal INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    descricao_modal VARCHAR(100) UNIQUE
);
CREATE OR REPLACE TABLE dim_agentes (
    id_agente INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    nome_agente VARCHAR(255)
);
CREATE OR REPLACE TABLE dim_canais (
    id_canal INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    descricao_canal VARCHAR(50) UNIQUE
);

-----
USE DATABASE DADOS_ADUANEIROS;
CREATE OR REPLACE TABLE fatos_processos_importacao(
    id_processo_fato INT AUTOINCREMENT START 1 INCREMENT 1 PRIMARY KEY,
    id_processo_original VARCHAR(50),
    id_data_registro INT,
    id_data_desembaraco INT,
    id_produto INT,
    id_importador INT,
    id_exportador INT,
    id_pais_origem INT,
    id_modal_transporte INT,
    id_porto_entrada INT,
    id_canal INT,

    valor_mercadoria_usd DECIMAL(18, 2),
    valor_frete_usd DECIMAL(18, 2),
    valor_seguro_usd DECIMAL(18, 2),
    taxa_cambio DECIMAL(10, 4),
    valor_aduaneiro_brl DECIMAL(18, 2),
    ii_valor_brl DECIMAL(18, 2),
    ipi_valor_brl DECIMAL(18, 2),
    pis_valor_brl DECIMAL(18, 2),
    cofins_valor_brl DECIMAL(18, 2),

    FOREIGN KEY (id_data_registro) REFERENCES dim_tempo(id_data),
    FOREIGN KEY (id_data_desembaraco) REFERENCES dim_tempo(id_data),
    FOREIGN KEY (id_produto) REFERENCES dim_produtos(id_produto),
    FOREIGN KEY (id_importador) REFERENCES dim_agentes(id_agente),
    FOREIGN KEY (id_exportador) REFERENCES dim_agentes(id_agente),
    FOREIGN KEY (id_pais_origem) REFERENCES dim_paises(id_pais),
    FOREIGN KEY (id_modal_transporte) REFERENCES dim_modais(id_modal),
    FOREIGN KEY (id_porto_entrada) REFERENCES dim_portos(id_porto),
    FOREIGN KEY (id_canal) REFERENCES dim_canais(id_canal)

);
