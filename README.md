# Pipeline de Dados Aduaneiros (ELT na Nuvem)

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)

## 📖 Sobre o Projeto

Este projeto implementa um pipeline de dados **ELT (Extract, Load, Transform)** completo, demonstrando práticas modernas de engenharia de dados. Inspirado pela relevância econômica do Porto de Santos, o pipeline processa um conjunto de dados aduaneiros fictícios, movendo-os de um ambiente local para uma arquitetura de dados na nuvem, pronta para análise.

O objetivo principal é construir um **Data Warehouse** robusto e modelado, capaz de suportar análises de Business Intelligence e alimentar futuros modelos de Machine Learning.

## 🏛️ Arquitetura do Pipeline

O fluxo de dados segue o paradigma ELT, aproveitando a escalabilidade e o poder de processamento da nuvem.

**1. Extração e Carregamento (EL)**

+----------------+       +-------------------+       +-------------------+
|   Arquivo CSV  | ----> | Script Python (EL)| ----> | Amazon S3         |
|     (Local)    |       | (boto3, Snowflake)|       |   (Datalake /     |
+----------------+       +-------------------+       |   Bronze Layer)   |
                                 |                     +---------+---------+
                                 |                               |
                                 |  (COPY INTO - Load)           | (COPY INTO - Load)
                                 V                               V
                         +-------------------+             +-------------------+
                         | Snowflake         | <---------  | Snowflake         |
                         | (Staging Table)   |             | (Data Warehouse / |
                         +-------------------+             |   Star Schema)    |
                                 |                         +-------------------+
                                 |
                                 | (SQL Transforms)
                                 V
                         +-------------------+
                         | Snowflake         |
                         | (Camada Analítica |
                         |   Star Schema)    |
                         +-------------------+

-   Um script Python lê o arquivo CSV local e o carrega (Load) para a camada Bronze do Datalake no S3.
-   Em seguida, o script orquestra o carregamento (Load) do S3 para uma tabela de Staging no Snowflake.

**2. Transformação (T)**
[Snowflake (Staging Table)] -> [SQL Scripts] -> [Snowflake (Camada Analítica / Star Schema)]

-   A transformação ocorre inteiramente dentro do Snowflake, onde scripts SQL convertem os dados brutos da tabela de Staging para um modelo analítico limpo e performático (Star Schema).

## 📄 Modelo de Dados (Star Schema)

Para otimizar as consultas analíticas, os dados são organizados em um modelo dimensional (Star Schema), separando as métricas dos eventos (Fatos) do seu contexto descritivo (Dimensões).

* **Tabela Fato (`fato_processos_importacao`):** Armazena os dados numéricos de cada processo de importação (valores, impostos, taxas).
* **Tabelas de Dimensão (`dim_produtos`, `dim_paises`, `dim_portos`, etc.):** Armazenam os dados descritivos (nomes, descrições, categorias), garantindo consistência e performance.

## 🛠️ Tecnologias e Conceitos Utilizados

-   **Linguagem:** Python 3
-   **Cloud & Banco de Dados:**
    -   **Amazon S3:** Utilizado como Datalake para armazenar os dados brutos (Camada Bronze).
    -   **Snowflake:** Utilizado como Data Warehouse na nuvem para staging, transformação e armazenamento da camada analítica.
    -   **SQL:** Linguagem principal para toda a etapa de Transformação de dados.
-   **Bibliotecas Python:**
    -   `boto3`: Para interagir com a API da AWS e fazer o upload para o S3.
    -   `snowflake-connector-python`: Para conectar e executar comandos no Snowflake.
    -   `pandas`: Para a leitura e validação inicial dos dados.
    -   `python-dotenv`: Para o gerenciamento seguro de credenciais.
-   **Conceitos de Engenharia de Dados:**
    -   **ELT (Extract, Load, Transform):** Arquitetura moderna de pipeline de dados.
    -   **Datalake & Data Warehouse:** Implementação dos dois conceitos centrais de armazenamento de dados.
    -   **Modelagem Dimensional (Star Schema):** Desenho do modelo de dados para otimização analítica.
    -   **Infraestrutura como Código (IaC):** Utilização de scripts para provisionar recursos (Bucket S3).

## 🚀 Como Executar o Projeto

### 1. Pré-requisitos
-   Python 3.8 ou superior
-   Conta na [AWS](https://aws.amazon.com/free/) com um usuário IAM configurado.
-   Conta no [Snowflake](https://signup.snowflake.com/) (o trial de 30 dias é suficiente).
-   [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) instalado e configurado (`aws configure`).
-   Git.

### 2. Instalação
Clone o repositório e instale as dependências:
```bash
git clone https://github.com/lucasghidini/elt_aduaneiro
cd PROJETO ADUANEIROETL
pip install -r requirements.txt
