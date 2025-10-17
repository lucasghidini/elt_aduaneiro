USE DATABASE DADOS_ADUANEIROS;

INSERT INTO dim_paises (nome_pais)
    SELECT DISTINCT UPPER(TRIM(Pais_origem))
    FROM STAGING_DADOS_ADUANEIROS
    WHERE
        pais_origem IS NOT NULL AND pais_origem != '';

INSERT INTO dim_portos (nome_porto)
    SELECT DISTINCT UPPER(TRIM(PORTO_ENTRADA))
    FROM STAGING_DADOS_ADUANEIROS
    WHERE
        porto_entrada IS NOT NULL AND porto_entrada != '';

INSERT INTO dim_modais (descricao_modal)
    SELECT DISTINCT UPPER(TRIM(MODAL_TRANSPORTE))
    FROM STAGING_DADOS_ADUANEIROS
    WHERE
        modal_transporte IS NOT NULL AND modal_transporte != '';


INSERT INTO dim_produtos (codigo_ncm, descricao_mercadoria)
    SELECT DISTINCT NCM, DESCRICAO_MERCADORIA
    FROM STAGING_DADOS_ADUANEIROS
    WHERE
        NCM IS NOT NULL AND NCM != '';

INSERT INTO dim_agentes (nome_agente)
    SELECT DISTINCT UPPER(TRIM(IMPORTADOR)) 
    FROM STAGING_DADOS_ADUANEIROS WHERE IMPORTADOR IS NOT NULL AND IMPORTADOR != ''
    UNION
    SELECT DISTINCT UPPER(TRIM(EXPORTADOR))   
    FROM STAGING_DADOS_ADUANEIROS WHERE EXPORTADOR IS NOT NULL AND EXPORTADOR != '';


INSERT INTO dim_tempo (id_data, data_completa, ano, mes, dia, trimestre, nome_mes)
SELECT DISTINCT
    YEAR(d.data_unica) * 1000 + MONTH(d.data_unica) * 100 + DAY(d.data_unica) AS id_data,
    d.data_unica AS data_completa,
    YEAR(d.data_unica) as ano,
    MONTH(d.data_unica) as mes,
    DAY(d.data_unica) as dia,
    QUARTER(d.data_unica) as trimestre,
    MONTHNAME(d.data_unica) as nome_mes
FROM (
        SELECT TRY_TO_DATE(Data_Registro) as data_unica FROM STAGING_DADOS_ADUANEIROS
        UNION
        SELECT TRY_TO_DATE(DATA_DESEMBARACO) as data_unica FROM STAGING_DADOS_ADUANEIROS        
) d
WHERE d.data_unica IS NOT NULL;



INSERT INTO  fatos_processos_importacao (
    id_processo_original, id_data_registro, id_data_desembaraco, id_produto, 
    id_importador, id_exportador, id_pais_origem, id_modal_transporte, 
    id_porto_entrada, id_canal, valor_mercadoria_usd, valor_frete_usd, 
    valor_seguro_usd, taxa_cambio, valor_aduaneiro_brl, ii_valor_brl, 
    ipi_valor_brl, pis_valor_brl, cofins_valor_brl
)
SELECT  
    s.ID_PROCESSO,
    dr.id_data,
    dd.id_data,
    p.id_produto,
    imp.id_agente,
    exp.id_agente,
    pais.id_pais,
    modal.id_modal,
    porto.id_porto,
    canal.id_canal,

    TRY_TO_DECIMAL(REPLACE(s.Valor_Mercadoria_USD, ',', '.'), 18, 2), 
    TRY_TO_DECIMAL(REPLACE(s.Valor_Frete_USD, ',', '.'), 18, 2),
    TRY_TO_DECIMAL(REPLACE(s.Valor_Seguro_USD, ',', '.'), 18, 2),
    TRY_TO_DECIMAL(REPLACE(s.Taxa_Cambio, ',', '.'), 10, 4),
    TRY_TO_DECIMAL(REPLACE(s.Valor_Aduaneiro_BRL, ',', '.'), 18, 2),
    TRY_TO_DECIMAL(REPLACE(s.II_Valor_BRL, ',', '.'), 18, 2),
    TRY_TO_DECIMAL(REPLACE(s.IPI_Valor_BRL, ',', '.'), 18, 2),
    TRY_TO_DECIMAL(REPLACE(s.PIS_Valor_BRL, ',', '.'), 18, 2),
    TRY_TO_DECIMAL(REPLACE(s.COFINS_Valor_BRL, ',', '.'), 18, 2)
FROM
    STAGING_DADOS_ADUANEIROS s
    LEFT JOIN dim_tempo dr ON TRY_TO_DATE(s.Data_Registro) = dr.data_completa
    LEFT JOIN dim_tempo dd ON TRY_TO_DATE(s.Data_Desembaraco) = dd.data_completa
    LEFT JOIN dim_produtos p ON s.NCM = p.codigo_ncm
    LEFT JOIN dim_agentes imp ON UPPER(TRIM(s.Importador)) = imp.nome_agente
    LEFT JOIN dim_agentes exp ON UPPER(TRIM(s.Exportador)) = exp.nome_agente
    LEFT JOIN dim_paises pais ON UPPER(TRIM(s.Pais_Origem)) = pais.nome_pais
    LEFT JOIN dim_modais modal ON UPPER(TRIM(s.Modal_Transporte)) = modal.descricao_modal
    LEFT JOIN dim_portos porto ON UPPER(TRIM(s.Porto_Entrada)) = porto.nome_porto
    LEFT JOIN dim_canais canal ON UPPER(TRIM(s.Canal_Parametrizacao)) = canal.descricao_canal;