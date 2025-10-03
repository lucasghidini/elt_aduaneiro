import os
import boto3
import snowflake.connector
from botocore.exceptions import ClientError
from dotenv import load_dotenv
from datetime import date



def upload_file_to_s3(file_path, nome_bucket, bucket_path):
    """Faz upload de um arquivo local para um bucket S3."""
    s3_client = boto3.client('s3')
    print(f'Iniciando upload do arquivo {file_path} para o bucket {nome_bucket} no caminho {bucket_path}')
    

    
    try:
        s3_client.upload_file(file_path, nome_bucket, bucket_path)
        print(f'Upload do arquivo {file_path} concluído com sucesso para o bucket {nome_bucket} no caminho {bucket_path}')
        return True
    except FileNotFoundError:
        print(f'O arquivo {file_path} não foi encontrado.')
        return False
    except ClientError as e:
        print(f'Erro ao fazer upload do arquivo {file_path} para o bucket {nome_bucket}: {e}')  
        return False
    


def load_s3_to_snowflak(snowflake_conn, patch_destino_s3, aws_credentials, snowflake_table):
        """Carrega dados de um arquivo no S3 para uma tabela no Snowflake."""
        print(f'Iniciando carga do arquivo {patch_destino_s3} do S3 para a tabela {snowflake_table} no Snowflake')

        copy_sql= f"""
        COPY INTO {snowflake_table}
        FROM '{patch_destino_s3}'
        CREDENTIALS=(
            AWS_KEY_ID='{aws_credentials['AWS_ACCESS']}'
            AWS_SECRET_KEY='{aws_credentials['AWS_SECRET_KEY']}'
        )
        FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ';' SKIP_HEADER = 1 ENCODING = 'UTF-8');
        """

        cursor = None
        try:
            cursor = snowflake_conn.cursor()
            cursor.execute("USE DATABASE DADOS_ADUANEIROS;")
            cursor.execute(copy_sql)
            print(f'Carga do arquivo {patch_destino_s3} concluída com sucesso para a tabela {snowflake_table} no Snowflake')
        except Exception as e:
            print(f'Erro ao carregar o arquivo {patch_destino_s3} para a tabela {snowflake_table} no Snowflake: {e}')
        finally:
            if cursor:
                cursor.close()


if __name__ == "__main__":
    load_dotenv()
    AWS_ACCESS = os.getenv('AWS_ACCESS')
    AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
    SNOWFLAKE_USER = os.getenv('SNOWFLAKE_USER')
    SNOWFLAKE_PASSWORD = os.getenv('SNOWFLAKE_PASSWORD')
    SNOWFLAKE_ACCOUNT = os.getenv('SNOWFLAKE_ACCOUNT')
    
    if not all([AWS_ACCESS, AWS_SECRET_KEY, SNOWFLAKE_USER, SNOWFLAKE_PASSWORD, SNOWFLAKE_ACCOUNT]):
        raise ValueError("Por favor, verifique se todas as variáveis de ambiente necessárias estão definidas no arquivo .env")



    NOME_DO_BUCKET_S3 = 'datalake-aduaneiro-lucasghidini'
    NOME_ARQUIVO = 'dados_aduaneiros.csv'
    file_path = 'C:\\Users\\GhidiniLucas\\Desktop\\Desktop\\Projetos\\Projeto AduaneiroETL\\data\\dados_aduaneiros.csv'
    
    bucket_path = f'bronze/raw/{NOME_ARQUIVO}'
    s3_uri = f's3://{NOME_DO_BUCKET_S3}/{bucket_path}'
    nome_bucket = NOME_DO_BUCKET_S3
    
    snowflake_table = 'STAGING_DADOS_ADUANEIROS'
    
    sucesso_upload = upload_file_to_s3(file_path, nome_bucket, bucket_path)

    if sucesso_upload:
        snowflake_connection = None
        try:
            print('Conectando ao Snowflake...')
            snowflake_connection = snowflake.connector.connect(
                user=SNOWFLAKE_USER,
                password=SNOWFLAKE_PASSWORD,
                account=SNOWFLAKE_ACCOUNT
            )
            print('Conexão ao Snowflake estabelecida com sucesso.')


            aws_creds ={
                'AWS_ACCESS': AWS_ACCESS,
                'AWS_SECRET_KEY': AWS_SECRET_KEY
            }

            load_s3_to_snowflak(snowflake_connection, s3_uri, aws_creds, snowflake_table)

        except snowflake.connector.errors.Error as e:
            print(f'Erro ao conectar ao Snowflake: {e}')
        finally:
            if snowflake_connection:
                snowflake_connection.close()
                print('Conexão ao Snowflake fechada.')

            