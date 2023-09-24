import boto3

# Configurar las credenciales de AWS 
aws_access_key_id = 'ACCESS_KEY'
aws_secret_access_key = 'SECRET_KEY'
region_name = 'REGION' 

# Crea un cliente S3
s3 = boto3.client('s3', region_name=region_name, aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key)

# Nombre del archivo que deseas descargar
bucket_name = 'devops-tryouts'
file_key = 'FILE_KEY'

# Nombre de archivo de destino
download_path = 'archivo_descargado.txt'

# Descargando el archivo ...
try:
    s3.download_file(bucket_name, file_key, download_path)
    print(f"Archivo '{file_key}' descargado correctamente como '{download_path}'")
except Exception as e:
    print(f"Error al descargar el archivo: {e}")
