import docker
from datetime import datetime, timedelta

client = docker.from_env()

def list_containers():
    containers = client.containers.list(all=True)
    return containers

def remove_containers_old_days(days):
    cutoff_date = datetime.now() - timedelta(days=days)
    containers = list_containers()

    for container in containers:
        created_date = datetime.fromtimestamp(container.attrs['Created'])
        if created_date < cutoff_date:
            print(f"Eliminando contenedor {container.name} ({container.id}) creado el {created_date}")
            container.remove(force=True)
            print(f"Contenedor {container.name} eliminado")

if __name__ == "__main__":
    # Listar todos los contenedores
    containers = list_containers()
    
    print("Contenedores en ejecución e inactivos:")
    for container in containers:
        print(f"Nombre: {container.name}, Estado: {container.status}")
    
    # Eliminar contenedores inactivos con más de 7 días de antigüedad
    remove_containers_old_days(7)
