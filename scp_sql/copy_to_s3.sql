USE DATABASE DADOS_ADUANEIROS;

CREATE OR REPLACE STAGE stage_s3_camada_analitica
    URL = 's3://datalake-aduaneiro-lucasghidini/Ouro/'
      CREDENTIALS = (
        AWS_KEY_ID = ''
        AWS_SECRET_KEY = ''
);

CREATE OR REPLACE FILE FORMAT formato_parquet
    TYPE = PARQUET;

COPY INTO @stage_s3_camada_analitica/fato_processos_importacao/
FROM FATOS_PROCESSOS_IMPORTACAO
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_produtos/
FROM DIM_PRODUTOS
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_paises/
FROM DIM_PAISES
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_portos/
FROM DIM_PORTOS
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_agentes/
FROM DIM_AGENTES
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_canais/
FROM DIM_CANAIS
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_modais/
FROM DIM_MODAIS
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;

COPY INTO @stage_s3_camada_analitica/dim_tempo/
FROM DIM_TEMPO
FILE_FORMAT = (FORMAT_NAME = 'formato_parquet')
OVERWRITE = TRUE;
